import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/domain/bridge/bridge_calendar.dart';
import 'package:izin_planla/domain/bridge/bridge_day_kind.dart';
import 'package:izin_planla/domain/models/models.dart';

import 'bridge_test_data.dart';

void main() {
  final holidays = bundledHolidays();
  int n(int year, int month, int dayOfMonth) =>
      BridgeCalendar.dayNumber(day(year, month, dayOfMonth));

  group('day numbers', () {
    test('round trip and weekday match DateTime', () {
      for (var i = -800; i < 800; i += 7) {
        final date = DateTime.utc(1970, 1, 1 + i * 13);
        final number = BridgeCalendar.dayNumber(date);
        expect(BridgeCalendar.dateOf(number), date);
        expect(BridgeCalendar.weekdayOf(number), date.weekday);
      }
    });

    test('time of day is ignored', () {
      expect(
        BridgeCalendar.dayNumber(DateTime.utc(2027, 3, 8, 23, 59)),
        n(2027, 3, 8),
      );
    });
  });

  group('kindOf', () {
    final calendar = BridgeCalendar(laborProfile(), holidays);

    test('weekend and holidays are free, eves need the morning', () {
      expect(calendar.kindOf(n(2027, 3, 6)), BridgeDayKind.free);
      expect(calendar.kindOf(n(2027, 3, 7)), BridgeDayKind.free);
      expect(calendar.kindOf(n(2027, 3, 8)), BridgeDayKind.eve);
      expect(calendar.kindOf(n(2027, 3, 9)), BridgeDayKind.free);
      expect(calendar.kindOf(n(2027, 3, 12)), BridgeDayKind.workday);
      expect(calendar.kindOf(n(2027, 5, 15)), BridgeDayKind.free);
    });

    test('a working Saturday needs leave', () {
      final saturdays = BridgeCalendar(
        laborProfile(
          schedule: const WorkSchedule(workDays: [1, 2, 3, 4, 5, 6]),
        ),
        holidays,
      );
      expect(saturdays.kindOf(n(2027, 3, 13)), BridgeDayKind.workday);
      expect(saturdays.kindOf(n(2027, 5, 15)), BridgeDayKind.eve);
    });

    test('the weekly rest day is free even when listed as a work day', () {
      final fridayRest = BridgeCalendar(
        laborProfile(
          schedule: const WorkSchedule(
            workDays: [1, 2, 3, 4, 5, 6, 7],
            weeklyRestDay: DateTime.friday,
          ),
        ),
        holidays,
      );
      expect(fridayRest.kindOf(n(2027, 3, 12)), BridgeDayKind.free);
      expect(fridayRest.kindOf(n(2027, 3, 14)), BridgeDayKind.workday);
    });

    test('administrative leave is free only for a civil servant', () {
      final admin = [day(2027, 3, 12)];
      final officer = BridgeCalendar(
        civilServantProfile(administrativeLeaveDays: admin),
        holidays,
      );
      final worker = BridgeCalendar(
        laborProfile().copyWith(administrativeLeaveDays: admin),
        holidays,
      );
      expect(officer.kindOf(n(2027, 3, 12)), BridgeDayKind.free);
      expect(worker.kindOf(n(2027, 3, 12)), BridgeDayKind.workday);
    });

    test('no working weekday is reported', () {
      final none = BridgeCalendar(
        laborProfile(schedule: const WorkSchedule(workDays: [])),
        holidays,
      );
      expect(none.hasWorkDays, isFalse);
      expect(BridgeCalendar(laborProfile(), holidays).hasWorkDays, isTrue);
    });
  });

  group('breaks', () {
    final calendar = BridgeCalendar(laborProfile(), holidays);

    test('free days around the leave join the break', () {
      expect(calendar.breakStartFor(n(2027, 3, 12)), n(2027, 3, 9));
      expect(calendar.breakEndFor(n(2027, 3, 12)), n(2027, 3, 14));
      expect(calendar.breakStartFor(n(2027, 3, 8)), n(2027, 3, 6));
      expect(calendar.breakEndFor(n(2027, 3, 8)), n(2027, 3, 11));
    });

    test('a Saturday holiday frees no working day', () {
      expect(calendar.hasTimeOffIn(n(2027, 5, 1), n(2027, 5, 2)), isFalse);
      expect(calendar.hasTimeOffIn(n(2027, 3, 8), n(2027, 3, 8)), isTrue);
      expect(calendar.hasTimeOffIn(n(2027, 3, 12), n(2027, 3, 14)), isFalse);
    });

    test('clusters are named by their first holiday day', () {
      expect(calendar.clustersIn(n(2027, 3, 6), n(2027, 3, 14)), [
        n(2027, 3, 8),
      ]);
      expect(calendar.clustersIn(n(2027, 5, 14), n(2027, 5, 20)), [
        n(2027, 5, 15),
      ]);
      expect(calendar.clustersIn(n(2026, 5, 16), n(2026, 5, 31)), [
        n(2026, 5, 19),
        n(2026, 5, 26),
      ]);
    });

    test('holiday names come in date order without repeats', () {
      final twice = [...holidays, ...holidays];
      expect(
        BridgeCalendar(
          laborProfile(),
          twice,
        ).holidayNamesIn(n(2026, 10, 28), n(2026, 11, 1)),
        ['Cumhuriyet Bayramı Arifesi', 'Cumhuriyet Bayramı'],
      );
    });

    test('a full-day entry wins over a half-day entry on the same date', () {
      final both = BridgeCalendar(laborProfile(), [
        Holiday(
          date: day(2027, 3, 8),
          name: 'Full',
          type: HolidayType.national,
          halfDay: false,
        ),
        ...holidays,
      ]);
      expect(both.kindOf(n(2027, 3, 8)), BridgeDayKind.free);
    });
  });
}
