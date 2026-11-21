import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/domain/day_count/leave_cost.dart';
import 'package:izin_planla/domain/models/models.dart';

import 'day_count_fixtures.dart';

void main() {
  const cost = LeaveCost();

  double total(LeaveRecord record, Profile profile) =>
      cost.total(record, profile, holidays);

  LeaveRecord halfDay(DateTime date, {DateTime? end}) =>
      leave(date, end ?? date, unit: LeaveUnit.halfDay);

  LeaveRecord hourly(DateTime date, double hours) =>
      leave(date, date, unit: LeaveUnit.hours, hours: hours);

  group('whole days', () {
    test('match the day counter', () {
      final record = leave(day(2026, 3, 18), day(2026, 3, 24));

      expect(total(record, laborLaw()), 3.5);
      expect(total(record, civilServant()), 5.5);
      expect(cost.days(record, laborLaw(), holidays), hasLength(7));
    });
  });

  group('half day', () {
    test('costs half a day on a working day', () {
      expect(total(halfDay(day(2026, 11, 9)), laborLaw()), 0.5);
      expect(total(halfDay(day(2026, 11, 9)), civilServant()), 0.5);
    });

    test('costs nothing on a rest day or holiday', () {
      expect(total(halfDay(day(2026, 11, 15)), laborLaw()), 0);
      expect(total(halfDay(day(2026, 10, 29)), laborLaw()), 0);
      expect(total(halfDay(day(2026, 11, 14)), civilServant()), 0);
    });

    test('on an eve costs at most the eve setting', () {
      final eve = halfDay(day(2026, 10, 28));

      expect(total(eve, laborLaw()), 0.5);
      expect(
        total(
          eve,
          laborLaw(
            workSchedule: const WorkSchedule(
              halfDayDeduction: HalfDayDeduction.zero,
            ),
          ),
        ),
        0,
      );
    });

    test('covers only the first day of its range', () {
      final record = halfDay(day(2026, 11, 9), end: day(2026, 11, 13));
      final days = cost.days(record, laborLaw(), holidays);

      expect(days.single.date, day(2026, 11, 9));
      expect(days.single.value, 0.5);
      expect(days.single.reason, DayReason.workday);
    });
  });

  group('hourly', () {
    test('converts hours by the daily working hours', () {
      expect(total(hourly(day(2026, 11, 9), 4), laborLaw()), 0.5);
      expect(
        total(
          hourly(day(2026, 11, 9), 3),
          laborLaw(workSchedule: const WorkSchedule(dailyWorkingHours: 7.5)),
        ),
        closeTo(0.4, 1e-9),
      );
    });

    test('never costs more than the day', () {
      expect(total(hourly(day(2026, 11, 9), 10), laborLaw()), 1);
      expect(total(hourly(day(2026, 10, 28), 8), laborLaw()), 0.5);
    });

    test('costs nothing on a holiday or without hours', () {
      expect(total(hourly(day(2026, 10, 29), 4), laborLaw()), 0);
      final noHours = leave(
        day(2026, 11, 9),
        day(2026, 11, 9),
      ).copyWith(unit: LeaveUnit.hours);
      expect(total(noHours, laborLaw()), 0);
    });

    test('counts the full day when daily hours are not set', () {
      expect(
        total(
          hourly(day(2026, 11, 9), 2),
          laborLaw(workSchedule: const WorkSchedule(dailyWorkingHours: 0)),
        ),
        1,
      );
    });
  });

  group('deductsFromAnnual', () {
    test('annual leave deducts under both laws', () {
      final record = leave(day(2026, 11, 9), day(2026, 11, 9));

      expect(cost.deductsFromAnnual(record, laborLaw()), isTrue);
      expect(cost.deductsFromAnnual(record, civilServant()), isTrue);
    });

    test('other types do not deduct', () {
      for (final type in LeaveType.values.where((t) => t != LeaveType.annual)) {
        final record = leave(day(2026, 11, 9), day(2026, 11, 9), type: type);
        expect(cost.deductsFromAnnual(record, laborLaw()), isFalse);
        expect(cost.deductsFromAnnual(record, civilServant()), isFalse);
      }
    });

    test('second excuse block deducts only for a civil servant', () {
      final record = leave(
        day(2026, 11, 9),
        day(2026, 11, 13),
        type: LeaveType.excuse,
        deductsFromAnnual: true,
      );

      expect(cost.deductsFromAnnual(record, civilServant()), isTrue);
      expect(cost.deductsFromAnnual(record, laborLaw()), isFalse);
    });
  });
}
