import 'dart:async';
import 'dart:developer' as developer;
import 'dart:ui' show Locale;

import 'package:izin_planla/data/repositories/holiday_repository.dart';
import 'package:izin_planla/data/repositories/leave_repository.dart';
import 'package:izin_planla/data/repositories/profile_repository.dart';
import 'package:izin_planla/data/repositories/settings_repository.dart';
import 'package:izin_planla/data/services/notifications/notification_gateway.dart';
import 'package:izin_planla/data/services/notifications/notification_service.dart';
import 'package:izin_planla/data/services/notifications/reminder_planner.dart';
import 'package:izin_planla/data/services/notifications/reminder_texts.dart';
import 'package:izin_planla/data/services/notifications/scheduled_reminder.dart';
import 'package:izin_planla/data/services/notifications/stable_notification_id.dart';
import 'package:izin_planla/domain/bridge/bridge_planner.dart';
import 'package:izin_planla/domain/day_count/balance_calculator.dart';
import 'package:izin_planla/domain/entitlement/entitlement_calculator.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:timezone/data/latest_10y.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// [NotificationService] that schedules local reminders in
/// `Europe/Istanbul`.
///
/// [reschedule] reads the current data, plans every reminder with
/// [ReminderPlanner] and makes the scheduled set match the plan. Platform
/// errors are logged and never thrown, so a denied permission or a broken
/// plugin does not stop the app.
class LocalNotificationService implements NotificationService {
  /// Creates the service. Tests replace `clock` and `localizations`.
  new({
    required this._gateway,
    required this._profileRepository,
    required this._leaveRepository,
    required this._settingsRepository,
    required this._holidayRepository,
    required this._entitlementCalculator,
    required this._balanceCalculator,
    required this._bridgePlanner,
    AppLocalizations? localizations,
    this._clock = DateTime.now,
  }) : _texts = ReminderTexts(
         localizations ?? lookupAppLocalizations(const Locale('tr')),
       );

  /// Time zone of every reminder.
  static const timeZone = 'Europe/Istanbul';

  final NotificationGateway _gateway;
  final ProfileRepository _profileRepository;
  final LeaveRepository _leaveRepository;
  final SettingsRepository _settingsRepository;
  final HolidayRepository _holidayRepository;
  final EntitlementCalculator _entitlementCalculator;
  final BalanceCalculator _balanceCalculator;
  final BridgePlanner _bridgePlanner;
  final ReminderTexts _texts;
  final DateTime Function() _clock;

  ReminderPlanner? _planner;
  Future<bool>? _initialization;
  Future<void>? _rescheduling;
  var _rescheduleAgain = false;

  @override
  Future<void> initialize() async {
    await _ensureInitialized();
  }

  @override
  Future<bool> requestPermission() async {
    if (!await _ensureInitialized()) return false;
    try {
      return await _gateway.requestPermission();
    } on Exception catch (error, stackTrace) {
      _log('Permission request failed', error, stackTrace);
      return false;
    }
  }

  /// Runs one reschedule at a time. A call during a running reschedule makes
  /// it run once more with the latest data and waits for that.
  @override
  Future<void> reschedule() {
    final running = _rescheduling;
    if (running != null) {
      _rescheduleAgain = true;
      return running;
    }
    return _rescheduling = _rescheduleUntilCurrent();
  }

  @override
  Future<void> cancelAll() async {
    await _rescheduling;
    if (!await _ensureInitialized()) return;
    try {
      await _gateway.cancelAll();
    } on Exception catch (error, stackTrace) {
      _log('Cancelling reminders failed', error, stackTrace);
    }
  }

  /// Shows a notification right away, to check the setup on a device.
  /// Returns whether it was handed to the system.
  Future<bool> showTestNotification() async {
    if (!await _ensureInitialized()) return false;
    try {
      await _gateway.show(
        id: testNotificationId,
        title: _texts.testTitle,
        body: _texts.testBody,
      );
      return true;
    } on Exception catch (error, stackTrace) {
      _log('Test notification failed', error, stackTrace);
      return false;
    }
  }

  Future<bool> _ensureInitialized() async {
    final pending = _initialization ??= _initialize();
    final ready = await pending;
    // A failed start is tried again on the next call.
    if (!ready && identical(_initialization, pending)) _initialization = null;
    return ready;
  }

  Future<bool> _initialize() async {
    try {
      tz_data.initializeTimeZones();
      _planner = ReminderPlanner(
        location: tz.getLocation(timeZone),
        entitlementCalculator: _entitlementCalculator,
        balanceCalculator: _balanceCalculator,
        bridgePlanner: _bridgePlanner,
      );
      await _gateway.initialize(
        channelName: _texts.channelName,
        channelDescription: _texts.channelDescription,
      );
      return true;
    } on Exception catch (error, stackTrace) {
      _log('Notification setup failed', error, stackTrace);
      return false;
    }
  }

  Future<void> _rescheduleUntilCurrent() async {
    try {
      do {
        _rescheduleAgain = false;
        await _rescheduleOnce();
      } while (_rescheduleAgain);
    } finally {
      // Cleared right after the last check, so no call is left unplanned.
      _rescheduling = null;
    }
  }

  Future<void> _rescheduleOnce() async {
    if (!await _ensureInitialized()) return;
    final planner = _planner;
    if (planner == null) return;
    try {
      // Without the permission nothing would show, so nothing is kept. The
      // next reschedule after the user allows notifications fills the list.
      final reminders = await _gateway.isPermissionGranted()
          ? await _plan(planner)
          : const <ScheduledReminder>[];
      final wanted = {for (final reminder in reminders) reminder.id};
      for (final id in await _gateway.pendingIds()) {
        if (!wanted.contains(id)) await _gateway.cancel(id);
      }
      for (final reminder in reminders) {
        final text = _texts.of(reminder.reminder);
        await _gateway.schedule(
          id: reminder.id,
          fireAt: reminder.fireAt,
          title: text.title,
          body: text.body,
        );
      }
    } on Exception catch (error, stackTrace) {
      _log('Scheduling reminders failed', error, stackTrace);
    }
  }

  Future<List<ScheduledReminder>> _plan(ReminderPlanner planner) async {
    final settings = await _settingsRepository.watch().first;
    final preferences = settings.notifications;
    final anyOn =
        preferences.holidayReminder ||
        preferences.accrualReminder ||
        preferences.plannedLeaveReminder ||
        preferences.yearEndReminder;
    if (!anyOn) return const [];

    final profiles = await _profileRepository.watchAll().first;
    final holidays = await _holidayRepository.all();
    final leavesByProfile = <String, List<LeaveRecord>>{
      for (final profile in profiles)
        profile.id: await _leaveRepository.watchForProfile(profile.id).first,
    };
    return planner.plan(
      now: _clock(),
      settings: settings,
      profiles: profiles,
      leavesByProfile: leavesByProfile,
      holidays: holidays,
    );
  }

  void _log(String message, Object error, StackTrace stackTrace) =>
      developer.log(
        message,
        name: 'notifications',
        error: error,
        stackTrace: stackTrace,
      );
}
