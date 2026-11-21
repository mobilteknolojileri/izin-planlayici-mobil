import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/database/mappers/settings_mapper.dart';
import 'package:izin_planla/domain/models/models.dart';

void main() {
  test('maps every settings field to the row and back', () {
    const settings = AppSettings(
      themeMode: AppThemeMode.dark,
      activeProfileId: 'p1',
      notifications: NotificationPreferences(
        holidayReminder: true,
        holidayDaysBefore: 3,
        accrualReminder: true,
        plannedLeaveReminder: true,
        plannedLeaveDaysBefore: 2,
        yearEndReminder: true,
      ),
    );

    final row = SettingsMapper.toRow(settings);

    expect(row.id, SettingsMapper.rowId);
    expect(SettingsMapper.toModel(row), settings);
  });

  test('a missing row means the fresh install defaults', () {
    expect(SettingsMapper.toModel(null), const AppSettings());
  });
}
