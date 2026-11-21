import 'package:izin_planla/domain/day_count/leave_day_counter.dart';
import 'package:izin_planla/domain/models/models.dart';

/// Implementation of [LeaveDayCounter]. Written by task 08.
///
/// Labour Law profiles follow `docs/mevzuat.md` 1.9 and 1.10 (4857 md. 56/5),
/// civil servants follow 2.5 (DPB-2016) and both follow section 4 for eves
/// and 28 October (2429 md. 1, md. 2/B).
class DefaultLeaveDayCounter implements LeaveDayCounter {
  /// Creates the calculator.
  const new();

  @override
  DayCount count(DateRange range, Profile profile, List<Holiday> holidays) {
    final index = _holidayIndex(holidays);
    final dates = _datesOf(range);
    final days = switch (profile.employmentType) {
      EmploymentType.laborLaw => [
        for (final date in dates)
          _laborLawDay(date, profile.workSchedule, index[date]),
      ],
      EmploymentType.civilServant => _civilServantDays(dates, profile, index),
    };
    return DayCount(
      total: days.fold<double>(0, (sum, day) => sum + day.value),
      days: days,
    );
  }

  /// One holiday per date. A full-day entry wins over a half-day entry.
  static Map<DateTime, Holiday> _holidayIndex(List<Holiday> holidays) {
    final index = <DateTime, Holiday>{};
    for (final holiday in holidays) {
      final date = _dateOnly(holiday.date);
      final existing = index[date];
      if (existing == null || existing.halfDay) index[date] = holiday;
    }
    return index;
  }

  static List<DateTime> _datesOf(DateRange range) {
    final end = _dateOnly(range.end);
    return [
      for (
        var date = _dateOnly(range.start);
        !date.isAfter(end);
        date = DateTime.utc(date.year, date.month, date.day + 1)
      )
        date,
    ];
  }

  static DateTime _dateOnly(DateTime date) =>
      DateTime.utc(date.year, date.month, date.day);

  static bool _isFullDay(Holiday? holiday) =>
      holiday != null && !holiday.halfDay;

  static bool _isWeekend(DateTime date) =>
      date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;

  /// Steps of `docs/mevzuat.md` 1.9, checked in order.
  static DayBreakdown _laborLawDay(
    DateTime date,
    WorkSchedule schedule,
    Holiday? holiday,
  ) {
    // Step 1: weekly rest day (4857 md. 56/5).
    if (date.weekday == schedule.weeklyRestDay) {
      return DayBreakdown(date: date, value: 0, reason: DayReason.weeklyRest);
    }
    // Step 2: full-day national or religious holiday (4857 md. 56/5).
    if (holiday != null && _isFullDay(holiday)) {
      return DayBreakdown(
        date: date,
        value: 0,
        reason: DayReason.holiday,
        holidayName: holiday.name,
      );
    }
    // Step 3: non-working day other than weekly rest, by the Saturday
    // setting (mevzuat 1.10, Y9HD-2020).
    final working = schedule.workDays.contains(date.weekday);
    if (!working && !schedule.saturdayCountsAsLeave) {
      return DayBreakdown(
        date: date,
        value: 0,
        reason: DayReason.contractualRest,
      );
    }
    // Step 4: counted day. An eve or 28 October costs the morning only
    // (mevzuat section 4).
    if (holiday != null) {
      return DayBreakdown(
        date: date,
        value: schedule.halfDayDeduction.days,
        reason: DayReason.halfDayHoliday,
        holidayName: holiday.name,
      );
    }
    // A non-working Saturday counted by the setting keeps its own reason, so
    // the breakdown shows why a day off still costs a leave day.
    return DayBreakdown(
      date: date,
      value: 1,
      reason: working ? DayReason.workday : DayReason.contractualRest,
    );
  }

  /// Steps of `docs/mevzuat.md` 2.5 for a civil servant.
  static List<DayBreakdown> _civilServantDays(
    List<DateTime> dates,
    Profile profile,
    Map<DateTime, Holiday> index,
  ) {
    // Step 1: weekends and full-day holidays at both edges are trimmed.
    bool isEdge(DateTime date) => _isWeekend(date) || _isFullDay(index[date]);
    var first = 0;
    while (first < dates.length && isEdge(dates[first])) {
      first++;
    }
    var last = dates.length - 1;
    while (last >= first && isEdge(dates[last])) {
      last--;
    }
    final administrative = {
      for (final day in profile.administrativeLeaveDays) _dateOnly(day),
    };
    final deduction = profile.workSchedule.halfDayDeduction;
    return [
      for (final (i, date) in dates.indexed)
        if (i < first || i > last)
          DayBreakdown(
            date: date,
            value: 0,
            reason: DayReason.trimmedEdge,
            holidayName: _isFullDay(index[date]) ? index[date]?.name : null,
          )
        else
          _civilServantInnerDay(
            date,
            holiday: index[date],
            deduction: deduction,
            administrative: administrative.contains(date),
          ),
    ];
  }

  /// Steps 2 to 6 of `docs/mevzuat.md` 2.5 for a day inside the trimmed
  /// range.
  static DayBreakdown _civilServantInnerDay(
    DateTime date, {
    required Holiday? holiday,
    required HalfDayDeduction deduction,
    required bool administrative,
  }) {
    // Step 2: Saturday and Sunday inside the leave count, holiday or not.
    if (_isWeekend(date)) {
      return DayBreakdown(
        date: date,
        value: 1,
        reason: DayReason.weekendInsideLeave,
      );
    }
    // Step 3: full-day holiday on a weekday.
    if (holiday != null && _isFullDay(holiday)) {
      return DayBreakdown(
        date: date,
        value: 0,
        reason: DayReason.holiday,
        holidayName: holiday.name,
      );
    }
    // Step 5 before step 4: an administrative leave day is off as a whole
    // (mevzuat 3.4), so an eve marked as administrative leave costs nothing.
    if (administrative) {
      return DayBreakdown(
        date: date,
        value: 0,
        reason: DayReason.administrativeLeave,
      );
    }
    // Step 4: eve or 28 October on a weekday (mevzuat section 4).
    if (holiday != null) {
      return DayBreakdown(
        date: date,
        value: deduction.days,
        reason: DayReason.halfDayHoliday,
        holidayName: holiday.name,
      );
    }
    // Step 6: any other day.
    return DayBreakdown(date: date, value: 1, reason: DayReason.workday);
  }
}
