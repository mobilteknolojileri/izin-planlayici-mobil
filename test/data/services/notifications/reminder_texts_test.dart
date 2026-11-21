import 'dart:ui' show Locale;

import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/services/notifications/reminder.dart';
import 'package:izin_planla/data/services/notifications/reminder_texts.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';

void main() {
  final texts = ReminderTexts(lookupAppLocalizations(const Locale('tr')));

  ({String title, String body}) text(Reminder reminder) => texts.of(reminder);

  test('channel texts', () {
    expect(texts.channelName, 'Hatırlatmalar');
    expect(
      texts.channelDescription,
      'Resmî tatil, köprü, hak ediş ve izin hatırlatmaları',
    );
  });

  test('holiday reminder says how many days are left', () {
    HolidayReminder holiday(int days) =>
        HolidayReminder(holidayName: 'Yılbaşı', daysUntil: days);

    expect(text(holiday(7)), (
      title: 'Resmî tatil yaklaşıyor',
      body: 'Yılbaşı için 7 gün kaldı.',
    ));
    expect(text(holiday(1)).body, 'Yarın Yılbaşı.');
    expect(text(holiday(0)).body, 'Bugün Yılbaşı.');
  });

  test('bridge reminder adds the leave days and the whole break', () {
    expect(
      text(
        const BridgeReminder(
          holidayName: 'Ramazan Bayramı 1. Gün',
          daysUntil: 10,
          leaveDays: 1.5,
          totalDaysOff: 9,
        ),
      ),
      (
        title: 'Köprü fırsatı',
        body:
            'Ramazan Bayramı 1. Gün için 10 gün kaldı. Bu tatile 1,5 gün izin '
            'eklersen toplam 9 gün tatil yaparsın.',
      ),
    );
  });

  test('accrual reminder names the profile and the days', () {
    expect(text(const AccrualReminder(profileName: 'Ayşe', days: 14)), (
      title: 'Yeni izin hakkı',
      body: 'Ayşe için bugün 14 gün yıllık izin hakkı doğdu.',
    ));
  });

  test('leave start and return reminders', () {
    LeaveStartReminder start(int days) =>
        LeaveStartReminder(profileName: 'Ayşe', daysUntil: days);

    expect(text(start(3)), (
      title: 'İzin yaklaşıyor',
      body: 'Ayşe için planlanan izin 3 gün sonra başlıyor.',
    ));
    expect(text(start(1)).body, 'Ayşe için planlanan izin yarın başlıyor.');
    expect(text(start(0)).body, 'Ayşe için planlanan izin bugün başlıyor.');
    expect(text(const LeaveReturnReminder(profileName: 'Ayşe')), (
      title: 'İzin bitiyor',
      body: 'Ayşe için yarın işe dönüş günü.',
    ));
  });

  test('year end warns a civil servant and informs a worker', () {
    expect(
      text(const YearEndExpiringReminder(profileName: 'Ayşe', days: 4.5)),
      (
        title: 'Kullanılmamış izin düşecek',
        body:
            "Ayşe için 4,5 gün izin yıl sonuna kadar kullanılmazsa 1 Ocak'ta "
            'düşecek.',
      ),
    );
    expect(text(const YearEndUnusedReminder(profileName: 'Ayşe', days: 6)), (
      title: 'Kullanılmamış izin var',
      body:
          'Ayşe için 6 gün kullanılmamış izin var. Bu izin yıl sonunda '
          'düşmez, sonraki yıla geçer.',
    ));
  });

  test('test notification', () {
    expect(texts.testTitle, 'Bildirimler açık');
    expect(texts.testBody, 'Hatırlatmalar böyle görünecek.');
  });
}
