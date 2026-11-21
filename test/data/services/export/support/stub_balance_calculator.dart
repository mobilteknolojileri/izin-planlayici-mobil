import 'package:izin_planla/domain/day_count/balance_calculator.dart';
import 'package:izin_planla/domain/models/models.dart';

/// Simple [BalanceCalculator] for tests, not the legal rules.
///
/// Annual records and records marked `deductsFromAnnual` count Monday to
/// Friday as 1, a half day as 0.5 and hours divided by the daily hours.
/// Days used before tracking are added to `used`, so tests see that the
/// export subtracts this baseline from each record.
class StubBalanceCalculator implements BalanceCalculator {
  /// Creates the calculator.
  const new();

  @override
  LeaveBalance balance({
    required Profile profile,
    required List<EntitlementPeriod> periods,
    required List<LeaveRecord> leaves,
    required List<Holiday> holidays,
    required DateTime today,
  }) {
    final earned = periods.fold<double>(0, (sum, p) => sum + p.days);
    var used = profile.leaveUsedBeforeTracking;
    var planned = 0.0;
    for (final leave in leaves) {
      if (leave.type != LeaveType.annual && !leave.deductsFromAnnual) continue;
      final cost = switch (leave.unit) {
        LeaveUnit.days => _weekdays(leave.range),
        LeaveUnit.halfDay => 0.5,
        LeaveUnit.hours =>
          (leave.hours ?? 0) / profile.workSchedule.dailyWorkingHours,
      };
      if (leave.range.start.isAfter(today)) {
        planned += cost;
      } else {
        used += cost;
      }
    }
    return LeaveBalance(
      earned: earned,
      used: used,
      planned: planned,
      remaining: earned - used - planned,
      expiringAtYearEnd: profile.employmentType == EmploymentType.civilServant
          ? 5
          : 0,
    );
  }

  double _weekdays(DateRange range) {
    var count = 0.0;
    for (var i = 0; i < range.dayCount; i++) {
      final day = range.start.add(Duration(days: i));
      if (day.weekday <= DateTime.friday) count++;
    }
    return count;
  }
}
