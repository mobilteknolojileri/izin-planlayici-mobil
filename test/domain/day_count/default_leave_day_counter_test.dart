import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/domain/day_count/default_leave_day_counter.dart';
import 'package:izin_planla/domain/models/models.dart';

import 'day_count_fixtures.dart';

void main() {
  const counter = DefaultLeaveDayCounter();

  DayCount count(DateRange r, Profile p) => counter.count(r, p, holidays);

  List<(double, DayReason)> steps(DayCount c) => [
    for (final d in c.days) (d.value, d.reason),
  ];

  WorkSchedule eve(HalfDayDeduction deduction) =>
      WorkSchedule(halfDayDeduction: deduction);

  group('4857', () {
    test('Ramazan 2026 with eve and weekend', () {
      final result = count(
        range(day(2026, 3, 18), day(2026, 3, 24)),
        laborLaw(),
      );

      expect(result.total, 3.5);
      expect(steps(result), [
        (1.0, DayReason.workday),
        (0.5, DayReason.halfDayHoliday),
        (0.0, DayReason.holiday),
        (0.0, DayReason.holiday),
        (0.0, DayReason.weeklyRest),
        (1.0, DayReason.workday),
        (1.0, DayReason.workday),
      ]);
      expect(result.days[1].holidayName, 'Ramazan Bayramı Arifesi');
      expect(result.days[2].holidayName, 'Ramazan Bayramı 1. Gün');
    });

    test('Kurban 2026 with a holiday on Saturday', () {
      final result = count(
        range(day(2026, 5, 25), day(2026, 6, 5)),
        laborLaw(),
      );

      expect(result.total, 6.5);
      final saturday = result.days.firstWhere(
        (d) => d.date == day(2026, 5, 30),
      );
      expect(saturday.reason, DayReason.holiday);
      expect(saturday.value, 0);
    });

    test('Ramazan 2027 starting on the eve', () {
      final result = count(
        range(day(2027, 3, 8), day(2027, 3, 12)),
        laborLaw(),
      );

      expect(result.total, 1.5);
    });

    test('Saturday setting on counts a non-working Saturday', () {
      final result = count(
        range(day(2026, 11, 9), day(2026, 11, 20)),
        laborLaw(),
      );

      expect(result.total, 11);
      final saturday = result.days[5];
      expect(saturday.date.weekday, DateTime.saturday);
      expect(saturday.value, 1);
      expect(saturday.reason, DayReason.contractualRest);
      expect(result.days[6].reason, DayReason.weeklyRest);
    });

    test('Saturday setting off does not count a non-working Saturday', () {
      final result = count(
        range(day(2026, 11, 9), day(2026, 11, 20)),
        laborLaw(
          workSchedule: const WorkSchedule(saturdayCountsAsLeave: false),
        ),
      );

      expect(result.total, 10);
      expect(result.days[5].value, 0);
      expect(result.days[5].reason, DayReason.contractualRest);
    });

    test('a working Saturday counts whatever the setting', () {
      final result = count(
        range(day(2026, 11, 9), day(2026, 11, 20)),
        laborLaw(
          workSchedule: const WorkSchedule(
            workDays: [1, 2, 3, 4, 5, 6],
            saturdayCountsAsLeave: false,
          ),
        ),
      );

      expect(result.total, 11);
      expect(result.days[5].reason, DayReason.workday);
    });

    test('weekly rest day follows the schedule', () {
      final result = count(
        range(day(2026, 11, 9), day(2026, 11, 15)),
        laborLaw(
          workSchedule: const WorkSchedule(weeklyRestDay: DateTime.saturday),
        ),
      );

      expect(result.days[5].reason, DayReason.weeklyRest);
      expect(result.days[6].reason, DayReason.contractualRest);
      expect(result.total, 6);
    });

    test('Kurban 2027 eve on Saturday follows the Saturday setting', () {
      final r = range(day(2027, 5, 10), day(2027, 5, 21));
      final on = count(r, laborLaw());
      final off = count(
        r,
        laborLaw(
          workSchedule: const WorkSchedule(saturdayCountsAsLeave: false),
        ),
      );

      expect(on.total, 7.5);
      expect(on.days[5].reason, DayReason.halfDayHoliday);
      expect(off.total, 7);
      expect(off.days[5].reason, DayReason.contractualRest);
      expect(
        on.days[9].holidayName,
        "Kurban Bayramı 4. Gün ve Atatürk'ü Anma, Gençlik ve Spor Bayramı",
      );
    });

    test('range across the year end', () {
      final r = range(day(2026, 12, 28), day(2027, 1, 8));
      final on = count(r, laborLaw());
      final off = count(
        r,
        laborLaw(
          workSchedule: const WorkSchedule(saturdayCountsAsLeave: false),
        ),
      );

      expect(on.total, 10);
      expect(off.total, 9);
      expect(on.days[4].reason, DayReason.holiday);
      expect(on.days[4].holidayName, 'Yılbaşı');
      // 2027-01-02 is the Saturday after a Friday holiday, not in the asset
      // (mevzuat 3.3), so the Saturday setting decides.
      expect(on.days[5].value, 1);
    });

    test('administrative leave days do not apply to workers', () {
      final result = count(
        range(day(2026, 10, 26), day(2026, 10, 30)),
        laborLaw(administrativeLeaveDays: [day(2026, 10, 28)]),
      );

      expect(result.total, 3.5);
      expect(result.days[2].reason, DayReason.halfDayHoliday);
    });
  });

  group('657', () {
    test('Ramazan 2026 counts the weekend inside the leave', () {
      final result = count(
        range(day(2026, 3, 18), day(2026, 3, 24)),
        civilServant(),
      );

      expect(result.total, 5.5);
      expect(steps(result), [
        (1.0, DayReason.workday),
        (0.5, DayReason.halfDayHoliday),
        (0.0, DayReason.holiday),
        (1.0, DayReason.weekendInsideLeave),
        (1.0, DayReason.weekendInsideLeave),
        (1.0, DayReason.workday),
        (1.0, DayReason.workday),
      ]);
    });

    test('Kurban 2026 counts a holiday Saturday inside the leave', () {
      final result = count(
        range(day(2026, 5, 25), day(2026, 6, 5)),
        civilServant(),
      );

      expect(result.total, 8.5);
    });

    test('Monday to the next Friday without holidays is 12 days', () {
      final result = count(
        range(day(2026, 11, 9), day(2026, 11, 20)),
        civilServant(),
      );

      expect(result.total, 12);
      expect(result.days[5].reason, DayReason.weekendInsideLeave);
    });

    test('Saturday setting has no effect', () {
      final result = count(
        range(day(2026, 11, 9), day(2026, 11, 20)),
        civilServant(
          workSchedule: const WorkSchedule(saturdayCountsAsLeave: false),
        ),
      );

      expect(result.total, 12);
    });

    test('Kurban 2027 eve on Saturday inside the leave counts 1', () {
      final result = count(
        range(day(2027, 5, 10), day(2027, 5, 21)),
        civilServant(),
      );

      expect(result.total, 9);
      expect(result.days[5].reason, DayReason.weekendInsideLeave);
      expect(result.days[5].value, 1);
    });

    test('weekends and holidays at both edges are trimmed', () {
      final result = count(
        range(day(2028, 5, 1), day(2028, 5, 8)),
        civilServant(),
      );

      expect(result.total, 2.5);
      expect(steps(result), [
        (0.0, DayReason.trimmedEdge),
        (1.0, DayReason.workday),
        (1.0, DayReason.workday),
        (0.5, DayReason.halfDayHoliday),
        (0.0, DayReason.trimmedEdge),
        (0.0, DayReason.trimmedEdge),
        (0.0, DayReason.trimmedEdge),
        (0.0, DayReason.trimmedEdge),
      ]);
      expect(result.days.first.holidayName, 'Emek ve Dayanışma Günü');
      expect(result.days[5].holidayName, 'Kurban Bayramı 2. Gün');
    });

    test('Ramazan 2028 trimmed at the start, leap day counted', () {
      final result = count(
        range(day(2028, 2, 26), day(2028, 3, 3)),
        civilServant(),
      );

      expect(result.total, 4);
      expect(result.days[3].date, day(2028, 2, 29));
      expect(result.days[3].reason, DayReason.workday);
    });

    test('a weekend-only range costs nothing', () {
      final result = count(
        range(day(2026, 11, 14), day(2026, 11, 15)),
        civilServant(),
      );

      expect(result.total, 0);
      expect(
        result.days.map((d) => d.reason),
        everyElement(DayReason.trimmedEdge),
      );
      expect(result.days.map((d) => d.holidayName), everyElement(isNull));
    });

    test('range across the year end', () {
      final result = count(
        range(day(2026, 12, 28), day(2027, 1, 8)),
        civilServant(),
      );

      expect(result.total, 11);
      expect(result.days[4].reason, DayReason.holiday);
      expect(result.days[5].reason, DayReason.weekendInsideLeave);
    });

    test('administrative leave day on a weekday is not counted', () {
      final result = count(
        range(day(2026, 12, 28), day(2027, 1, 8)),
        civilServant(administrativeLeaveDays: [day(2026, 12, 31)]),
      );

      expect(result.total, 10);
      expect(result.days[3].reason, DayReason.administrativeLeave);
      expect(result.days[3].value, 0);
    });

    test('administrative leave on an eve wins over the half day', () {
      final result = count(
        range(day(2026, 10, 26), day(2026, 10, 30)),
        civilServant(administrativeLeaveDays: [day(2026, 10, 28)]),
      );

      expect(result.total, 3);
      expect(result.days[2].reason, DayReason.administrativeLeave);
    });
  });

  group('the same range under both laws', () {
    test('gives different totals', () {
      final r = range(day(2026, 3, 18), day(2026, 3, 24));

      expect(count(r, laborLaw()).total, 3.5);
      expect(count(r, civilServant()).total, 5.5);
    });
  });

  group('eve and 28 October setting', () {
    final october28 = range(day(2026, 10, 28), day(2026, 10, 28));

    for (final (deduction, expected) in [
      (HalfDayDeduction.zero, 0.0),
      (HalfDayDeduction.half, 0.5),
      (HalfDayDeduction.full, 1.0),
    ]) {
      test('${deduction.name} costs $expected under both laws', () {
        final worker = count(october28, laborLaw(workSchedule: eve(deduction)));
        final servant = count(
          october28,
          civilServant(workSchedule: eve(deduction)),
        );

        expect(worker.total, expected);
        expect(servant.total, expected);
        expect(worker.days.single.reason, DayReason.halfDayHoliday);
        expect(worker.days.single.holidayName, 'Cumhuriyet Bayramı Arifesi');
      });
    }

    test('half is the default', () {
      expect(count(october28, laborLaw()).total, 0.5);
    });

    test('applies to a religious eve inside a longer range', () {
      final r = range(day(2026, 5, 25), day(2026, 5, 26));

      expect(
        count(r, laborLaw(workSchedule: eve(HalfDayDeduction.full))).total,
        2,
      );
      expect(
        count(r, civilServant(workSchedule: eve(HalfDayDeduction.zero))).total,
        1,
      );
    });
  });

  group('breakdown', () {
    test('has one entry per calendar day in order', () {
      final r = range(day(2026, 12, 20), day(2027, 1, 10));

      for (final profile in [laborLaw(), civilServant()]) {
        final result = count(r, profile);
        expect(result.days, hasLength(r.dayCount));
        expect(result.days.first.date, r.start);
        expect(result.days.last.date, r.end);
        expect(
          result.total,
          result.days.fold<double>(0, (sum, d) => sum + d.value),
        );
      }
    });

    test('normalizes local dates to UTC days', () {
      final local = DateRange(
        start: DateTime(2026, 3, 18, 15),
        end: DateTime(2026, 3, 24, 9),
      );
      final result = count(local, laborLaw());

      expect(result.total, 3.5);
      expect(result.days.first.date, day(2026, 3, 18));
      expect(result.days.first.date.isUtc, isTrue);
    });

    test('without holidays only the schedule matters', () {
      final result = counter.count(
        range(day(2026, 3, 18), day(2026, 3, 24)),
        laborLaw(),
        const [],
      );

      expect(result.total, 6);
    });
  });
}
