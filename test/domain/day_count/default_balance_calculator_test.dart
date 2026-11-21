import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/domain/day_count/default_balance_calculator.dart';
import 'package:izin_planla/domain/models/models.dart';

import 'day_count_fixtures.dart';

void main() {
  const calculator = DefaultBalanceCalculator();

  LeaveBalance balance(
    Profile profile,
    List<EntitlementPeriod> periods,
    List<LeaveRecord> leaves,
    DateTime today,
  ) => calculator.balance(
    profile: profile,
    periods: periods,
    leaves: leaves,
    holidays: holidays,
    today: today,
  );

  group('4857', () {
    final periods = [
      EntitlementPeriod(accrualDate: day(2025, 3, 1), days: 14),
      EntitlementPeriod(accrualDate: day(2026, 3, 1), days: 14),
    ];

    test('splits used and planned by the start date', () {
      final result = balance(laborLaw(leaveUsedBeforeTracking: 3), periods, [
        leave(day(2026, 11, 9), day(2026, 11, 13)),
        // Starts today: used.
        leave(day(2026, 11, 20), day(2026, 11, 20)),
        // Starts tomorrow and after: planned.
        leave(day(2026, 11, 23), day(2026, 11, 27)),
        leave(day(2026, 6, 1), day(2026, 6, 5), type: LeaveType.sick),
      ], day(2026, 11, 20));

      expect(result.earned, 28);
      expect(result.used, 9);
      expect(result.planned, 5);
      expect(result.remaining, 14);
      expect(result.expiringAtYearEnd, 0);
    });

    test('a planned leave moves to used when its day comes', () {
      final leaves = [leave(day(2026, 11, 23), day(2026, 11, 27))];

      final before = balance(laborLaw(), periods, leaves, day(2026, 11, 22));
      final after = balance(laborLaw(), periods, leaves, day(2026, 11, 23));

      expect((before.used, before.planned), (0.0, 5.0));
      expect((after.used, after.planned), (5.0, 0.0));
      expect(before.remaining, after.remaining);
    });

    test('periods accrued after today are not earned yet', () {
      final result = balance(
        laborLaw(),
        [...periods, EntitlementPeriod(accrualDate: day(2027, 3, 1), days: 14)],
        const [],
        day(2026, 11, 20),
      );

      expect(result.earned, 28);
      expect(result.remaining, 28);
    });

    test('insufficient balance goes negative and stays visible', () {
      final result = balance(
        laborLaw(),
        [EntitlementPeriod(accrualDate: day(2026, 3, 1), days: 14)],
        [
          leave(day(2026, 11, 9), day(2026, 11, 20)),
          leave(day(2026, 12, 7), day(2026, 12, 11)),
        ],
        day(2026, 11, 30),
      );

      expect(result.used, 11);
      expect(result.planned, 5);
      expect(result.remaining, -2);
    });

    test('leave before any accrual is debt', () {
      final result = balance(laborLaw(), const [], [
        leave(day(2026, 11, 9), day(2026, 11, 13)),
      ], day(2026, 11, 20));

      expect(result.earned, 0);
      expect(result.used, 5);
      expect(result.remaining, -5);
    });

    test('debt is paid by the next accrual', () {
      final result = balance(
        laborLaw(),
        [EntitlementPeriod(accrualDate: day(2026, 12, 1), days: 14)],
        [leave(day(2026, 11, 9), day(2026, 11, 13))],
        day(2026, 12, 2),
      );

      expect(result.earned, 14);
      expect(result.used, 5);
      expect(result.remaining, 9);
    });

    test('unused days never expire, even if a period says so', () {
      final result = balance(
        laborLaw(),
        [
          EntitlementPeriod(
            accrualDate: day(2026, 3, 1),
            days: 14,
            expiresOn: day(2027, 1, 1),
          ),
        ],
        const [],
        day(2027, 6, 1),
      );

      expect(result.earned, 14);
      expect(result.remaining, 14);
      expect(result.expiringAtYearEnd, 0);
    });

    test('half-day and hourly leave reduce the balance', () {
      final result = balance(laborLaw(), periods, [
        leave(day(2026, 11, 9), day(2026, 11, 9), unit: LeaveUnit.halfDay),
        leave(
          day(2026, 11, 10),
          day(2026, 11, 10),
          unit: LeaveUnit.hours,
          hours: 2,
        ),
      ], day(2026, 11, 20));

      expect(result.used, 0.75);
      expect(result.remaining, 27.25);
    });

    test('only annual leave reduces the balance', () {
      final result = balance(laborLaw(), periods, [
        for (final type in LeaveType.values)
          leave(
            day(2026, 11, 9),
            day(2026, 11, 13),
            type: type,
            deductsFromAnnual: true,
          ),
      ], day(2026, 11, 20));

      expect(result.used, 5);
    });
  });

  group('657', () {
    EntitlementPeriod year(int y, {bool withExpiry = true}) =>
        EntitlementPeriod(
          accrualDate: day(y, 1, 1),
          days: 20,
          calendarYear: y,
          expiresOn: withExpiry ? day(y + 2, 1, 1) : null,
        );

    final twelveDays2026 = [
      leave(day(2026, 11, 9), day(2026, 11, 20)),
      leave(day(2026, 12, 7), day(2026, 12, 18)),
    ];

    test('usage comes from the previous year first', () {
      final result = balance(
        civilServant(),
        [year(2025), year(2026), year(2027)],
        twelveDays2026,
        day(2027, 2, 1),
      );

      // 2025's 20 days were used up in 2026, 4 more came from 2026.
      expect(result.earned, 40);
      expect(result.used, 4);
      expect(result.remaining, 36);
      expect(result.expiringAtYearEnd, 16);
    });

    test('unused days of the year before last are dropped', () {
      final result = balance(
        civilServant(),
        [year(2025), year(2026), year(2027)],
        [leave(day(2026, 11, 9), day(2026, 11, 20))],
        day(2027, 2, 1),
      );

      // 2025 had 8 days left, they were dropped on 1 January 2027.
      expect(result.earned, 40);
      expect(result.used, 0);
      expect(result.remaining, 40);
    });

    test('shows what is dropped at year end', () {
      final result = balance(
        civilServant(),
        [year(2025), year(2026)],
        [leave(day(2026, 11, 9), day(2026, 11, 20))],
        day(2026, 12, 1),
      );

      expect(result.earned, 40);
      expect(result.used, 12);
      expect(result.remaining, 28);
      expect(result.expiringAtYearEnd, 8);
    });

    test('planned leave before year end lowers what is dropped', () {
      final result = balance(
        civilServant(),
        [year(2025), year(2026)],
        [
          leave(day(2026, 11, 9), day(2026, 11, 20)),
          leave(day(2026, 12, 7), day(2026, 12, 11)),
          // Next year's plan does not save this year's days.
          leave(day(2027, 1, 11), day(2027, 1, 15)),
        ],
        day(2026, 12, 1),
      );

      expect(result.planned, 10);
      expect(result.remaining, 18);
      expect(result.expiringAtYearEnd, 3);
    });

    test('nothing is dropped when the old year is used up', () {
      final result = balance(
        civilServant(),
        [year(2025), year(2026)],
        twelveDays2026,
        day(2026, 12, 20),
      );

      expect(result.used, 24);
      expect(result.remaining, 16);
      expect(result.expiringAtYearEnd, 0);
    });

    test('expiry falls back to the calendar year of the period', () {
      final withExpiry = balance(
        civilServant(),
        [year(2025), year(2026), year(2027)],
        twelveDays2026,
        day(2027, 2, 1),
      );
      final fallback = balance(
        civilServant(),
        [
          year(2025, withExpiry: false),
          year(2026, withExpiry: false),
          year(2027, withExpiry: false),
        ],
        twelveDays2026,
        day(2027, 2, 1),
      );

      expect(fallback, withExpiry);
    });

    test('second excuse block reduces the balance', () {
      final result = balance(
        civilServant(),
        [year(2026)],
        [
          leave(
            day(2026, 11, 9),
            day(2026, 11, 13),
            type: LeaveType.excuse,
            deductsFromAnnual: true,
          ),
          leave(day(2026, 11, 16), day(2026, 11, 20), type: LeaveType.excuse),
        ],
        day(2026, 11, 30),
      );

      expect(result.used, 5);
      expect(result.remaining, 15);
    });

    test('leave used before tracking counts against the current balance', () {
      final result = balance(
        civilServant(leaveUsedBeforeTracking: 5),
        [year(2025), year(2026), year(2027)],
        const [],
        day(2027, 2, 1),
      );

      expect(result.used, 5);
      expect(result.remaining, 35);
      expect(result.expiringAtYearEnd, 15);
    });
  });
}
