import 'package:izin_planla/data/database/app_database.dart';
import 'package:izin_planla/domain/models/models.dart';

/// Converts between [AppSettings] and the single [SettingsRow], so drift rows
/// never leave the data layer.
abstract final class SettingsMapper {
  /// Primary key of the only settings row.
  static const rowId = 1;

  /// The domain model stored in [row], or the fresh install defaults when
  /// no settings were saved yet.
  static AppSettings toModel(SettingsRow? row) {
    if (row == null) return const AppSettings();
    return AppSettings(
      themeMode: row.themeMode,
      activeProfileId: row.activeProfileId,
      notifications: NotificationPreferences(
        holidayReminder: row.holidayReminder,
        holidayDaysBefore: row.holidayDaysBefore,
        accrualReminder: row.accrualReminder,
        plannedLeaveReminder: row.plannedLeaveReminder,
        plannedLeaveDaysBefore: row.plannedLeaveDaysBefore,
        yearEndReminder: row.yearEndReminder,
      ),
    );
  }

  /// The row that stores [settings].
  static SettingsRow toRow(AppSettings settings) => SettingsRow(
    id: rowId,
    themeMode: settings.themeMode,
    activeProfileId: settings.activeProfileId,
    holidayReminder: settings.notifications.holidayReminder,
    holidayDaysBefore: settings.notifications.holidayDaysBefore,
    accrualReminder: settings.notifications.accrualReminder,
    plannedLeaveReminder: settings.notifications.plannedLeaveReminder,
    plannedLeaveDaysBefore: settings.notifications.plannedLeaveDaysBefore,
    yearEndReminder: settings.notifications.yearEndReminder,
  );
}
