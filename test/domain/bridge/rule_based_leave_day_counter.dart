import 'package:izin_planla/domain/day_count/leave_day_counter.dart';
import 'package:izin_planla/domain/models/models.dart';

/// Test double for task 08's counter, following `docs/mevzuat.md` 1.9,
/// 1.10, 2.5 and 4 day by day. Records every range it is asked about.
class RuleBasedLeaveDayCounter implements LeaveDayCounter {
  /// Ranges passed to [count], in call order.
  final List<DateRange> calls = [];

  @override
  DayCount count(DateRange range, Profile profile, List<Holiday> holidays) {
    calls.add(range);
    final byDate = {for (final h in holidays) h.date: h};
    final dates = [
      for (var i = 0; i < range.dayCount; i++)
        DateTime.utc(range.start.year, range.start.month, range.start.day + i),
    ];
    final values = switch (profile.employmentType) {
      EmploymentType.laborLaw => [
        for (final date in dates) _laborLaw(date, profile, byDate[date]),
      ],
      EmploymentType.civilServant => _civilServant(dates, profile, byDate),
    };
    return DayCount(total: values.fold<double>(0, (a, b) => a + b));
  }

  double _laborLaw(DateTime date, Profile profile, Holiday? holiday) {
    final schedule = profile.workSchedule;
    if (date.weekday == schedule.weeklyRestDay) return 0;
    if (holiday != null && !holiday.halfDay) return 0;
    if (!schedule.workDays.contains(date.weekday) &&
        !schedule.saturdayCountsAsLeave) {
      return 0;
    }
    if (holiday != null) return schedule.halfDayDeduction.days;
    return 1;
  }

  List<double> _civilServant(
    List<DateTime> dates,
    Profile profile,
    Map<DateTime, Holiday> byDate,
  ) {
    bool weekend(DateTime d) => d.weekday >= DateTime.saturday;
    bool edge(DateTime d) {
      final h = byDate[d];
      return weekend(d) || (h != null && !h.halfDay);
    }

    var from = 0;
    var to = dates.length - 1;
    while (from <= to && edge(dates[from])) {
      from++;
    }
    while (to >= from && edge(dates[to])) {
      to--;
    }
    double inside(DateTime d) {
      if (weekend(d)) return 1;
      final h = byDate[d];
      if (h != null) {
        return h.halfDay ? profile.workSchedule.halfDayDeduction.days : 0;
      }
      if (profile.administrativeLeaveDays.contains(d)) return 0;
      return 1;
    }

    return [
      for (var i = 0; i < dates.length; i++)
        if (i < from || i > to) 0 else inside(dates[i]),
    ];
  }
}
