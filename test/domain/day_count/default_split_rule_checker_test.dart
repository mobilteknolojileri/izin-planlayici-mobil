import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/domain/day_count/default_split_rule_checker.dart';
import 'package:izin_planla/domain/models/models.dart';

import 'day_count_fixtures.dart';

void main() {
  const checker = DefaultSplitRuleChecker();

  final periods = [
    EntitlementPeriod(accrualDate: day(2026, 3, 1), days: 14),
    EntitlementPeriod(accrualDate: day(2027, 3, 1), days: 14),
  ];

  List<LeaveWarning> check(Profile profile, List<LeaveRecord> leaves) =>
      checker.check(
        profile: profile,
        periods: periods,
        leaves: leaves,
        holidays: holidays,
      );

  LeaveRecord travel(DateTime start, DateTime end) =>
      leave(start, end, type: LeaveType.travel);

  group('split rule, 4857', () {
    test('warns when no part of a split leave reaches 10 days', () {
      final warnings = check(laborLaw(), [
        // 15 July 2026 is a holiday: 4 days.
        leave(day(2026, 7, 13), day(2026, 7, 17)),
        leave(day(2026, 11, 9), day(2026, 11, 13)),
      ]);

      expect(warnings, [
        const LeaveWarning(
          type: LeaveWarningType.splitRule,
          params: {
            'accrualDate': '2026-03-01',
            'parts': '2',
            'longestDays': '5',
            'minimumDays': '10',
            'legalReference': '4857 md. 56',
          },
        ),
      ]);
    });

    test('a part of exactly 10 days is enough', () {
      final ten = leave(day(2026, 11, 23), day(2026, 12, 3));
      final warnings = check(laborLaw(), [
        ten,
        leave(day(2026, 7, 13), day(2026, 7, 17)),
      ]);

      expect(warnings, isEmpty);
    });

    test('a longest part of 9 days warns', () {
      final warnings = check(laborLaw(), [
        leave(day(2026, 11, 23), day(2026, 12, 2)),
        leave(day(2026, 7, 13), day(2026, 7, 17)),
      ]);

      expect(warnings.single.params['longestDays'], '9');
    });

    test('one record alone is not split', () {
      expect(
        check(laborLaw(), [leave(day(2026, 11, 9), day(2026, 11, 13))]),
        isEmpty,
      );
    });

    test('records of different periods are checked separately', () {
      final warnings = check(laborLaw(), [
        leave(day(2026, 11, 9), day(2026, 11, 13)),
        leave(day(2027, 3, 1), day(2027, 3, 5)),
      ]);

      expect(warnings, isEmpty);
    });

    test('planned records count as parts', () {
      final warnings = check(laborLaw(), [
        leave(day(2026, 11, 9), day(2026, 11, 13)),
        leave(day(2027, 2, 1), day(2027, 2, 3)),
      ]);

      expect(warnings.single.type, LeaveWarningType.splitRule);
    });

    test('a record that costs nothing is not a part', () {
      final warnings = check(laborLaw(), [
        leave(day(2026, 11, 9), day(2026, 11, 13)),
        leave(day(2026, 11, 15), day(2026, 11, 15)),
      ]);

      expect(warnings, isEmpty);
    });

    test('half-day records are parts too', () {
      final warnings = check(laborLaw(), [
        leave(day(2026, 11, 9), day(2026, 11, 13)),
        leave(day(2026, 11, 16), day(2026, 11, 16), unit: LeaveUnit.halfDay),
      ]);

      expect(warnings.single.params['parts'], '2');
    });

    test('other leave types are not parts', () {
      final warnings = check(laborLaw(), [
        leave(day(2026, 11, 9), day(2026, 11, 13)),
        leave(day(2026, 11, 16), day(2026, 11, 17), type: LeaveType.sick),
      ]);

      expect(warnings, isEmpty);
    });
  });

  group('split rule, 657', () {
    test('never warns', () {
      final warnings = check(civilServant(), [
        leave(day(2026, 7, 13), day(2026, 7, 17)),
        leave(day(2026, 11, 9), day(2026, 11, 13)),
        leave(day(2026, 11, 16), day(2026, 11, 16)),
      ]);

      expect(warnings, isEmpty);
    });
  });

  group('travel leave, 4857', () {
    test('warns above 4 days in a period', () {
      final warnings = check(laborLaw(), [
        travel(day(2026, 11, 9), day(2026, 11, 10)),
        travel(day(2026, 11, 11), day(2026, 11, 13)),
      ]);

      expect(warnings, [
        const LeaveWarning(
          type: LeaveWarningType.travelLeaveLimit,
          params: {
            'accrualDate': '2026-03-01',
            'days': '5',
            'limitDays': '4',
            'legalReference': '4857 md. 56',
          },
        ),
      ]);
    });

    test('4 days is allowed', () {
      expect(
        check(laborLaw(), [
          travel(day(2026, 11, 9), day(2026, 11, 10)),
          travel(day(2026, 11, 11), day(2026, 11, 12)),
        ]),
        isEmpty,
      );
    });

    test('fractional days are written with a dot', () {
      final warnings = check(laborLaw(), [
        travel(day(2026, 11, 9), day(2026, 11, 12)),
        leave(
          day(2026, 11, 13),
          day(2026, 11, 13),
          type: LeaveType.travel,
          unit: LeaveUnit.halfDay,
        ),
      ]);

      expect(warnings.single.params['days'], '4.5');
    });
  });

  group('travel leave, 657', () {
    test('warns above 4 days in a calendar year', () {
      final warnings = check(civilServant(), [
        travel(day(2026, 11, 9), day(2026, 11, 10)),
        travel(day(2026, 12, 7), day(2026, 12, 9)),
      ]);

      expect(warnings, [
        const LeaveWarning(
          type: LeaveWarningType.travelLeaveLimit,
          params: {
            'year': '2026',
            'days': '5',
            'limitDays': '4',
            'legalReference': '657 md. 102',
          },
        ),
      ]);
    });

    test('a record across the year end is split by day', () {
      // 2026: 30-31 December. 2027: 2-5 January, 1 January is a holiday.
      final crossing = travel(day(2026, 12, 30), day(2027, 1, 5));

      expect(check(civilServant(), [crossing]), isEmpty);

      final warnings = check(civilServant(), [
        crossing,
        travel(day(2027, 3, 1), day(2027, 3, 1)),
      ]);
      expect(warnings.single.params['year'], '2027');
      expect(warnings.single.params['days'], '5');
    });
  });
}
