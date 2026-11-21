import 'package:izin_planla/domain/day_count/leave_cost.dart';
import 'package:izin_planla/domain/day_count/year_summary_calculator.dart';
import 'package:izin_planla/domain/models/models.dart';

/// Implementation of [YearSummaryCalculator]. Written by task 08.
///
/// - `earned`: days of the periods accrued in the year.
/// - `used`, `usedByMonth`: annual leave days counted on days of the year,
///   planned records included. A record across the year end is split by day.
///   `Profile.leaveUsedBeforeTracking` has no date and is left out.
/// - `usedByType`: counted days of every leave type, only types above zero.
/// - `totalDaysOff`: calendar days of the year that are a rest day of the
///   profile, a full-day holiday, a civil servant's administrative leave day
///   or inside a whole-day leave record of any type.
class DefaultYearSummaryCalculator implements YearSummaryCalculator {
  /// Creates the calculator.
  const new();

  @override
  YearSummary summary({
    required int year,
    required Profile profile,
    required List<EntitlementPeriod> periods,
    required List<LeaveRecord> leaves,
    required List<Holiday> holidays,
  }) {
    const cost = LeaveCost();
    final earned = periods
        .where((p) => p.accrualDate.year == year)
        .fold<double>(0, (sum, p) => sum + p.days);

    var used = 0.0;
    final byType = <LeaveType, double>{};
    final byMonth = {for (var month = 1; month <= 12; month++) month: 0.0};
    final daysOff = <DateTime>{};
    for (final leave in leaves) {
      final annual = cost.deductsFromAnnual(leave, profile);
      final days = cost
          .days(leave, profile, holidays)
          .where((d) => d.date.year == year);
      for (final day in days) {
        if (leave.unit == LeaveUnit.days) daysOff.add(day.date);
        if (day.value == 0) continue;
        byType.update(
          leave.type,
          (sum) => sum + day.value,
          ifAbsent: () => day.value,
        );
        if (annual) {
          used += day.value;
          byMonth.update(day.date.month, (sum) => sum + day.value);
        }
      }
    }

    final fullDayHolidays = {
      for (final h in holidays)
        if (!h.halfDay) _dateOnly(h.date),
    };
    final administrative = {
      for (final d in profile.administrativeLeaveDays) _dateOnly(d),
    };
    for (
      var date = DateTime.utc(year);
      date.year == year;
      date = DateTime.utc(date.year, date.month, date.day + 1)
    ) {
      if (_isRestDay(date, profile) ||
          fullDayHolidays.contains(date) ||
          (profile.employmentType == EmploymentType.civilServant &&
              administrative.contains(date))) {
        daysOff.add(date);
      }
    }

    return YearSummary(
      year: year,
      earned: earned,
      used: used,
      totalDaysOff: daysOff.length,
      usedByType: byType,
      usedByMonth: byMonth,
    );
  }

  /// Weekly rest and other non-working days (4857), Saturday and Sunday
  /// (657, mevzuat 2.5).
  static bool _isRestDay(DateTime date, Profile profile) {
    switch (profile.employmentType) {
      case EmploymentType.laborLaw:
        final schedule = profile.workSchedule;
        return date.weekday == schedule.weeklyRestDay ||
            !schedule.workDays.contains(date.weekday);
      case EmploymentType.civilServant:
        return date.weekday == DateTime.saturday ||
            date.weekday == DateTime.sunday;
    }
  }

  static DateTime _dateOnly(DateTime date) =>
      DateTime.utc(date.year, date.month, date.day);
}
