import 'package:izin_planla/domain/bridge/bridge_planner.dart';
import 'package:izin_planla/domain/day_count/balance_calculator.dart';
import 'package:izin_planla/domain/day_count/leave_day_counter.dart';
import 'package:izin_planla/domain/day_count/split_rule_checker.dart';
import 'package:izin_planla/domain/day_count/statutory_leave_advisor.dart';
import 'package:izin_planla/domain/day_count/year_summary_calculator.dart';
import 'package:izin_planla/domain/entitlement/entitlement_calculator.dart';
import 'package:izin_planla/domain/models/models.dart';

// Fixed sample results so screens can be built before tasks 07-09 finish.
// Values are illustrative only and do not follow the law. All fake
// calculators live in one file because task 16 replaces them together.

/// Fake [EntitlementCalculator]: 14 days on every hire anniversary.
class FakeEntitlementCalculator implements EntitlementCalculator {
  @override
  List<EntitlementPeriod> periods(Profile profile, {required DateTime until}) {
    final start = profile.employmentStartDate;
    final result = <EntitlementPeriod>[];
    for (var year = start.year + 1; year <= until.year; year++) {
      final date = DateTime.utc(year, start.month, start.day);
      if (!date.isAfter(until)) {
        result.add(EntitlementPeriod(accrualDate: date, days: 14));
      }
    }
    return result;
  }

  @override
  NextAccrual? nextAccrual(Profile profile, DateTime today) {
    final start = profile.employmentStartDate;
    var date = DateTime.utc(today.year, start.month, start.day);
    if (!date.isAfter(today)) {
      date = DateTime.utc(today.year + 1, start.month, start.day);
    }
    return NextAccrual(date: date, days: 20);
  }
}

/// Fake [LeaveDayCounter]: Monday-Friday count 1, other days 0.
class FakeLeaveDayCounter implements LeaveDayCounter {
  @override
  DayCount count(DateRange range, Profile profile, List<Holiday> holidays) {
    final days = <DayBreakdown>[
      for (var i = 0; i < range.dayCount; i++)
        _breakdown(range.start.add(Duration(days: i))),
    ];
    return DayCount(
      total: days.fold<double>(0, (sum, day) => sum + day.value),
      days: days,
    );
  }

  DayBreakdown _breakdown(DateTime date) {
    final weekend = date.weekday >= DateTime.saturday;
    return DayBreakdown(
      date: date,
      value: weekend ? 0 : 1,
      reason: weekend ? DayReason.weeklyRest : DayReason.workday,
    );
  }
}

/// Fake [BalanceCalculator] built on [FakeLeaveDayCounter].
class FakeBalanceCalculator implements BalanceCalculator {
  @override
  LeaveBalance balance({
    required Profile profile,
    required List<EntitlementPeriod> periods,
    required List<LeaveRecord> leaves,
    required List<Holiday> holidays,
    required DateTime today,
  }) {
    final counter = FakeLeaveDayCounter();
    final earned = periods.fold<double>(0, (sum, p) => sum + p.days);
    var used = 0.0;
    var planned = 0.0;
    for (final leave in leaves.where((l) => l.type == LeaveType.annual)) {
      final days = counter.count(leave.range, profile, holidays).total;
      if (leave.range.start.isAfter(today)) {
        planned += days;
      } else {
        used += days;
      }
    }
    return LeaveBalance(
      earned: earned,
      used: used,
      planned: planned,
      remaining: earned - used - planned,
    );
  }
}

/// Fake [SplitRuleChecker] that never warns.
class FakeSplitRuleChecker implements SplitRuleChecker {
  @override
  List<LeaveWarning> check({
    required Profile profile,
    required List<EntitlementPeriod> periods,
    required List<LeaveRecord> leaves,
    required List<Holiday> holidays,
  }) => const [];
}

/// Fake [StatutoryLeaveAdvisor] with a few fixed numbers.
class FakeStatutoryLeaveAdvisor implements StatutoryLeaveAdvisor {
  @override
  int? suggestedDays(LeaveType type, Profile profile, {DateTime? eventDate}) =>
      switch (type) {
        LeaveType.marriage || LeaveType.bereavement => 3,
        LeaveType.paternity => 10,
        _ => null,
      };
}

/// Fake [YearSummaryCalculator] with fixed numbers.
class FakeYearSummaryCalculator implements YearSummaryCalculator {
  @override
  YearSummary summary({
    required int year,
    required Profile profile,
    required List<EntitlementPeriod> periods,
    required List<LeaveRecord> leaves,
    required List<Holiday> holidays,
  }) => YearSummary(year: year, earned: 14, used: 5, totalDaysOff: 120);
}

/// Fake [BridgePlanner] with one fixed suggestion around 29 October 2026.
class FakeBridgePlanner implements BridgePlanner {
  static final _sample = BridgeSuggestion(
    leaveDays: [DateTime.utc(2026, 10, 30)],
    vacation: DateRange(
      start: DateTime.utc(2026, 10, 29),
      end: DateTime.utc(2026, 11),
    ),
    totalDaysOff: 4,
    leaveDaysUsed: 1,
    holidayNames: const ['Cumhuriyet Bayramı'],
  );

  @override
  List<BridgeSuggestion> suggestions({
    required int year,
    required Profile profile,
    required List<Holiday> holidays,
    double? budget,
    int maxLeaveDays = 5,
  }) => [_sample];

  @override
  List<BridgeSuggestion> optimalPlan({
    required int year,
    required Profile profile,
    required List<Holiday> holidays,
    required double budget,
  }) => [_sample];
}
