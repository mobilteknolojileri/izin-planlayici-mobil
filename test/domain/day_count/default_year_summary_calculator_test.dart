import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/domain/day_count/default_year_summary_calculator.dart';
import 'package:izin_planla/domain/models/models.dart';

import 'day_count_fixtures.dart';

void main() {
  const calculator = DefaultYearSummaryCalculator();

  final periods = [
    EntitlementPeriod(accrualDate: day(2025, 3, 1), days: 14),
    EntitlementPeriod(accrualDate: day(2026, 3, 1), days: 14),
    EntitlementPeriod(accrualDate: day(2027, 3, 1), days: 20),
  ];

  YearSummary summary(int year, Profile profile, List<LeaveRecord> leaves) =>
      calculator.summary(
        year: year,
        profile: profile,
        periods: periods,
        leaves: leaves,
        holidays: holidays,
      );

  final leaves = [
    // Across the year end: 4 days in 2026, 6 in 2027.
    leave(day(2026, 12, 28), day(2027, 1, 8)),
    leave(day(2026, 11, 9), day(2026, 11, 13)),
    leave(day(2026, 10, 26), day(2026, 10, 26), unit: LeaveUnit.halfDay),
    leave(day(2026, 6, 1), day(2026, 6, 5), type: LeaveType.sick),
  ];

  test('2026 without leave: weekends and weekday holidays', () {
    final result = summary(2026, laborLaw(), const []);

    // 104 Saturdays and Sundays, 10 full-day holidays on weekdays.
    expect(result.totalDaysOff, 114);
    expect(result.used, 0);
    expect(result.usedByType, isEmpty);
    expect(result.usedByMonth.keys, [for (var m = 1; m <= 12; m++) m]);
    expect(result.usedByMonth.values, everyElement(0));
  });

  test('2026 with leave', () {
    final result = summary(2026, laborLaw(), leaves);

    expect(result.year, 2026);
    expect(result.earned, 14);
    expect(result.used, 9.5);
    expect(result.usedByType, {LeaveType.annual: 9.5, LeaveType.sick: 5.0});
    expect(result.usedByMonth[10], 0.5);
    expect(result.usedByMonth[11], 5);
    expect(result.usedByMonth[12], 4);
    expect(result.usedByMonth[6], 0);
    // Whole-day records add their working days, the half day adds none.
    expect(result.totalDaysOff, 114 + 4 + 5 + 5);
  });

  test('2027 gets the rest of the record across the year end', () {
    final result = summary(2027, laborLaw(), leaves);

    expect(result.earned, 20);
    expect(result.used, 6);
    expect(result.usedByMonth[1], 6);
  });

  test('a Monday to Saturday worker has fewer days off', () {
    final result = summary(
      2026,
      laborLaw(workSchedule: const WorkSchedule(workDays: [1, 2, 3, 4, 5, 6])),
      const [],
    );

    // 52 Sundays, 12 full-day holidays from Monday to Saturday.
    expect(result.totalDaysOff, 64);
  });

  test('657 counts the weekend inside leave and administrative leave', () {
    final servant = civilServant(administrativeLeaveDays: [day(2026, 12, 31)]);
    final result = summary(2026, servant, [
      leave(day(2026, 11, 9), day(2026, 11, 20)),
    ]);

    expect(result.used, 12);
    expect(result.totalDaysOff, 114 + 10 + 1);
  });

  test('administrative leave days do not apply to workers', () {
    final result = summary(
      2026,
      laborLaw(administrativeLeaveDays: [day(2026, 12, 31)]),
      const [],
    );

    expect(result.totalDaysOff, 114);
  });

  test('second excuse block of a civil servant is annual usage', () {
    final result = summary(2026, civilServant(), [
      leave(
        day(2026, 11, 9),
        day(2026, 11, 13),
        type: LeaveType.excuse,
        deductsFromAnnual: true,
      ),
    ]);

    expect(result.used, 5);
    expect(result.usedByType, {LeaveType.excuse: 5.0});
    expect(result.usedByMonth[11], 5);
  });
}
