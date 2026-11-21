import 'package:drift/drift.dart';
import 'package:izin_planla/data/database/tables/profiles.dart';
import 'package:izin_planla/domain/models/models.dart';

/// The single `AppSettings` row. A missing row means the defaults of a fresh
/// install.
@DataClassName('SettingsRow')
class Settings extends Table {
  /// Always 1, so the table holds at most one row.
  IntColumn get id => integer().withDefault(const Constant(1))();

  /// Theme choice, stored by enum name.
  TextColumn get themeMode => textEnum<AppThemeMode>()();

  /// Profile shown on the home screen. Cleared when that profile is deleted.
  TextColumn get activeProfileId => text().nullable().references(
    Profiles,
    #id,
    onDelete: KeyAction.setNull,
  )();

  /// `NotificationPreferences.holidayReminder`.
  BoolColumn get holidayReminder => boolean()();

  /// `NotificationPreferences.holidayDaysBefore`.
  IntColumn get holidayDaysBefore => integer()();

  /// `NotificationPreferences.accrualReminder`.
  BoolColumn get accrualReminder => boolean()();

  /// `NotificationPreferences.plannedLeaveReminder`.
  BoolColumn get plannedLeaveReminder => boolean()();

  /// `NotificationPreferences.plannedLeaveDaysBefore`.
  IntColumn get plannedLeaveDaysBefore => integer()();

  /// `NotificationPreferences.yearEndReminder`.
  BoolColumn get yearEndReminder => boolean()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  bool get isStrict => true;

  @override
  List<String> get customConstraints => [
    'CHECK (id = 1)',
    "CHECK (theme_mode IN ('system', 'light', 'dark'))",
    'CHECK (holiday_days_before >= 0)',
    'CHECK (planned_leave_days_before >= 0)',
  ];
}
