import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_planla/config/dependencies.dart';
import 'package:izin_planla/data/repositories/backup_exception.dart';
import 'package:izin_planla/data/services/export/export_file.dart';
import 'package:izin_planla/data/services/export/export_format.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/ui/settings/view_models/settings_content.dart';
import 'package:izin_planla/ui/settings/view_models/settings_reminder.dart';
import 'package:izin_planla/ui/settings/view_models/settings_restore_failure.dart';
import 'package:izin_planla/ui/settings/view_models/settings_state.dart';
import 'package:izin_planla/utils/result.dart';

/// State and actions of the settings screen.
final settingsViewModelProvider =
    NotifierProvider<SettingsViewModel, SettingsState>(SettingsViewModel.new);

final _settingsProvider = StreamProvider<AppSettings>(
  (ref) => ref.watch(settingsRepositoryProvider).watch(),
);

final _profilesProvider = StreamProvider<List<Profile>>(
  (ref) => ref.watch(profileRepositoryProvider).watchAll(),
);

final _contentProvider = FutureProvider<SettingsContent>((ref) async {
  final settingsFuture = ref.watch(_settingsProvider.future);
  final profilesFuture = ref.watch(_profilesProvider.future);
  final settings = await settingsFuture;
  final profiles = await profilesFuture;
  return SettingsContent(
    settings: settings,
    profiles: profiles,
    activeProfile:
        profiles
            .where((profile) => profile.id == settings.activeProfileId)
            .firstOrNull ??
        profiles.firstOrNull,
  );
});

/// View model of the settings screen: work schedule of the active person,
/// theme, reminders, backup, restore, export and reset.
///
/// Every change is saved at once through the repositories, the screen
/// updates from their streams.
class SettingsViewModel extends Notifier<SettingsState> {
  @override
  SettingsState build() => SettingsState(content: ref.watch(_contentProvider));

  SettingsContent? get _content => state.content.value;

  Future<bool> _saveSettings(AppSettings settings) async {
    final result = await ref.read(settingsRepositoryProvider).save(settings);
    return result is Ok<void>;
  }

  Future<bool> _saveSchedule(WorkSchedule Function(WorkSchedule) change) {
    final profile = _content?.activeProfile;
    if (profile == null) return Future.value(false);
    return ref
        .read(profileRepositoryProvider)
        .save(profile.copyWith(workSchedule: change(profile.workSchedule)))
        .then((result) => result is Ok<void>);
  }

  /// Uses [mode] for the app theme.
  Future<bool> setThemeMode(AppThemeMode mode) async {
    final content = _content;
    if (content == null) return false;
    return await _saveSettings(content.settings.copyWith(themeMode: mode));
  }

  /// Adds or removes [weekday] from the working days. The last working
  /// day stays, a schedule without work days counts no leave at all.
  Future<bool> toggleWorkDay(int weekday) => _saveSchedule((schedule) {
    final days = {...schedule.workDays};
    if (days.contains(weekday)) {
      if (days.length > 1) days.remove(weekday);
    } else {
      days.add(weekday);
    }
    return schedule.copyWith(workDays: days.toList()..sort());
  });

  /// Whether a non-working Saturday counts as a leave day (4857 only).
  Future<bool> setSaturdayCountsAsLeave({required bool value}) => _saveSchedule(
    (schedule) => schedule.copyWith(saturdayCountsAsLeave: value),
  );

  /// How much an eve or 28 October morning costs.
  Future<bool> setHalfDayDeduction(HalfDayDeduction value) =>
      _saveSchedule((schedule) => schedule.copyWith(halfDayDeduction: value));

  /// Changes the daily working hours by [delta], within the allowed range.
  Future<bool> changeHours(double delta) => _saveSchedule(
    (schedule) => schedule.copyWith(
      dailyWorkingHours: (schedule.dailyWorkingHours + delta).clamp(
        SettingsContent.minHours,
        SettingsContent.maxHours,
      ),
    ),
  );

  /// Turns [reminder] on or off. Turning on asks for the notification
  /// permission first. Returns false when the permission is denied or
  /// saving fails, then nothing changes.
  Future<bool> setReminder(
    SettingsReminder reminder, {
    required bool enabled,
  }) async {
    final content = _content;
    if (content == null) return false;
    final notifications = ref.read(notificationServiceProvider);
    if (enabled && !await notifications.requestPermission()) return false;
    final current = content.settings.notifications;
    final next = switch (reminder) {
      SettingsReminder.holiday => current.copyWith(holidayReminder: enabled),
      SettingsReminder.accrual => current.copyWith(accrualReminder: enabled),
      SettingsReminder.planned => current.copyWith(
        plannedLeaveReminder: enabled,
      ),
      SettingsReminder.yearEnd => current.copyWith(yearEndReminder: enabled),
    };
    final saved = await _saveSettings(
      content.settings.copyWith(notifications: next),
    );
    if (saved) await notifications.reschedule();
    return saved;
  }

  /// Changes how many days before an event [reminder] comes. Only the
  /// holiday and planned leave reminders have this choice.
  Future<bool> changeDaysBefore(SettingsReminder reminder, int delta) async {
    final content = _content;
    if (content == null) return false;
    final current = content.settings.notifications;
    int clamp(int value) => value.clamp(
      SettingsContent.minDaysBefore,
      SettingsContent.maxDaysBefore,
    );
    final next = switch (reminder) {
      SettingsReminder.holiday => current.copyWith(
        holidayDaysBefore: clamp(current.holidayDaysBefore + delta),
      ),
      SettingsReminder.planned => current.copyWith(
        plannedLeaveDaysBefore: clamp(current.plannedLeaveDaysBefore + delta),
      ),
      SettingsReminder.accrual || SettingsReminder.yearEnd => current,
    };
    final saved = await _saveSettings(
      content.settings.copyWith(notifications: next),
    );
    if (saved) await ref.read(notificationServiceProvider).reschedule();
    return saved;
  }

  /// Shares a backup of all data. Returns whether it worked.
  Future<bool> backup() async =>
      await ref.read(exportServiceProvider).shareBackup() is Ok<void>;

  /// Lets the user pick a backup file. Returns its content, null when the
  /// user cancels, or an error.
  Future<Result<String?>> pickBackup() =>
      ref.read(exportServiceProvider).pickBackupFile();

  /// Replaces all data with the backup [json]. Returns null on success,
  /// otherwise why it failed. The data stays as it was on failure.
  Future<SettingsRestoreFailure?> restore(String json) async {
    final result = await ref.read(backupCodecProvider).restoreJson(json);
    final failure = switch (result) {
      Ok() => null,
      Err(error: NewerBackupException()) => SettingsRestoreFailure.newer,
      Err(error: InvalidBackupException()) => SettingsRestoreFailure.invalid,
      Err() => SettingsRestoreFailure.other,
    };
    if (failure == null) {
      await ref.read(notificationServiceProvider).reschedule();
    }
    return failure;
  }

  /// Builds the leave history of the active person in [format], then shares
  /// it or, with [save], lets the user save it. Returns whether it worked.
  Future<bool> export(ExportFormat format, {required bool save}) async {
    final profile = _content?.activeProfile;
    if (profile == null) return false;
    final service = ref.read(exportServiceProvider);
    final file = await service.exportLeaves(
      profileId: profile.id,
      format: format,
    );
    if (file is! Ok<ExportFile>) return false;
    final built = file.value;
    final result = save
        ? await service.saveToDevice(built)
        : await service.share(built);
    return result is Ok<void>;
  }

  /// Deletes all data. Returns a snapshot for [undoReset], or null when
  /// nothing was deleted.
  Future<String?> resetAll() async {
    final codec = ref.read(backupCodecProvider);
    final snapshot = await codec.exportJson();
    if (snapshot is! Ok<String>) return null;
    final reset = await codec.resetAll();
    if (reset is! Ok<void>) return null;
    await ref.read(notificationServiceProvider).cancelAll();
    return snapshot.value;
  }

  /// Brings back the data deleted by [resetAll]. Returns whether it worked.
  Future<bool> undoReset(String snapshot) async {
    final restored = await restore(snapshot);
    return restored == null;
  }
}
