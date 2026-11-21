import 'dart:async';
import 'dart:ui' show Locale;

import 'package:izin_planla/data/repositories/holiday_repository.dart';
import 'package:izin_planla/data/repositories/leave_repository.dart';
import 'package:izin_planla/data/repositories/profile_repository.dart';
import 'package:izin_planla/data/repositories/settings_repository.dart';
import 'package:izin_planla/data/services/home_widget/home_widget_content.dart';
import 'package:izin_planla/data/services/home_widget/home_widget_content_builder.dart';
import 'package:izin_planla/data/services/home_widget/home_widget_gateway.dart';
import 'package:izin_planla/data/services/home_widget/home_widget_service.dart';
import 'package:izin_planla/data/services/home_widget/plugin_home_widget_gateway.dart';
import 'package:izin_planla/domain/day_count/balance_calculator.dart';
import 'package:izin_planla/domain/entitlement/entitlement_calculator.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';

/// [HomeWidgetService] that writes the active profile's balance and the
/// holiday countdown for the coming days to the Android widget.
///
/// Call [start] once at app start so the widget follows every change of
/// the settings, the profiles and the leave records. The day change needs
/// no Dart code: the Kotlin provider picks the entry of the current date.
class DefaultHomeWidgetService implements HomeWidgetService {
  /// Creates the service. `now` and `gateway` are replaceable for tests.
  new({
    required SettingsRepository settingsRepository,
    required ProfileRepository profileRepository,
    required LeaveRepository leaveRepository,
    required HolidayRepository holidayRepository,
    required EntitlementCalculator entitlementCalculator,
    required BalanceCalculator balanceCalculator,
    AppLocalizations? l10n,
    this._gateway = const PluginHomeWidgetGateway(),
    this._now = DateTime.now,
  }) : _settings = settingsRepository,
       _profiles = profileRepository,
       _leaves = leaveRepository,
       _holidays = holidayRepository,
       _builder = HomeWidgetContentBuilder(
         entitlementCalculator: entitlementCalculator,
         balanceCalculator: balanceCalculator,
         l10n: l10n ?? lookupAppLocalizations(const Locale('tr')),
       );

  final SettingsRepository _settings;
  final ProfileRepository _profiles;
  final LeaveRepository _leaves;
  final HolidayRepository _holidays;
  final HomeWidgetGateway _gateway;
  final DateTime Function() _now;
  final HomeWidgetContentBuilder _builder;

  StreamSubscription<AppSettings>? _settingsSubscription;
  final List<StreamSubscription<Object?>> _dataSubscriptions = [];
  Future<void>? _running;
  bool _pending = false;

  @override
  Future<void> refresh() async {
    final settings = await _settings.watch().first;
    final profileId = settings.activeProfileId;
    final profile = profileId == null
        ? null
        : await _profiles.findById(profileId);
    final leaves = profile == null
        ? const <LeaveRecord>[]
        : await _leaves.watchForProfile(profile.id).first;
    final content = _builder.build(
      profile: profile,
      leaves: leaves,
      holidays: await _holidays.all(),
      themeMode: settings.themeMode,
      today: _now(),
    );
    // Written even when no widget is placed yet, so a widget added later
    // shows the current values at once.
    await _gateway.save(HomeWidgetContent.storageKey, content.encode());
    await _gateway.update();
  }

  @override
  Future<void> requestPin() async {
    await refresh();
    await _gateway.requestPin();
  }

  /// Refreshes now and after every change of the settings, the active
  /// profile or its leave records. Calling it again has no effect.
  void start() {
    _settingsSubscription ??= _settings.watch().listen(_watchProfile);
  }

  /// Stops following changes. A refresh that already started still ends.
  Future<void> dispose() async {
    await _settingsSubscription?.cancel();
    _settingsSubscription = null;
    await _cancelDataSubscriptions();
  }

  void _watchProfile(AppSettings settings) {
    // Synchronous, so two quick settings changes cannot both subscribe.
    unawaited(_cancelDataSubscriptions());
    // The settings themselves changed, for example the theme or the
    // active profile.
    _requestRefresh();
    final profileId = settings.activeProfileId;
    if (profileId == null) return;
    _dataSubscriptions
      ..add(_profiles.watchAll().skip(1).listen((_) => _requestRefresh()))
      ..add(
        _leaves
            .watchForProfile(profileId)
            .skip(1)
            .listen((_) => _requestRefresh()),
      );
  }

  Future<void> _cancelDataSubscriptions() async {
    final subscriptions = [..._dataSubscriptions];
    _dataSubscriptions.clear();
    await Future.wait(subscriptions.map((s) => s.cancel()));
  }

  /// Coalesces bursts of changes: one refresh runs at a time and at most
  /// one more follows it with the newest data.
  void _requestRefresh() {
    if (_running != null) {
      _pending = true;
      return;
    }
    _running = _drain();
  }

  Future<void> _drain() async {
    try {
      do {
        _pending = false;
        await refresh();
      } while (_pending);
    } finally {
      _running = null;
    }
  }
}
