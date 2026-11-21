import 'dart:math' as math;

import 'package:izin_planla/domain/day_count/default_leave_day_counter.dart';
import 'package:izin_planla/domain/day_count/leave_day_counter.dart';
import 'package:izin_planla/domain/models/models.dart';

/// Days a leave record costs, with the record's [LeaveUnit] applied.
///
/// Whole-day records are counted day by day with [counter]. Half-day and
/// hourly records cover only the first day of their range. The law does not
/// regulate either, the app accepts them as workplace practice
/// (`docs/mevzuat.md` section 4).
class LeaveCost {
  /// Creates the helper. [counter] counts whole days.
  const new({this.counter = const DefaultLeaveDayCounter()});

  /// Counts the days of a range by the profile's law.
  final LeaveDayCounter counter;

  /// Whether [record] reduces the annual leave balance of [profile].
  ///
  /// Only annual leave does (4857 md. 56/4, `docs/mevzuat.md` 1.9). The one
  /// exception is a civil servant's second excuse block of 657 md. 104/C,
  /// marked with `LeaveRecord.deductsFromAnnual` (mevzuat 2.8).
  bool deductsFromAnnual(LeaveRecord record, Profile profile) =>
      record.type == LeaveType.annual ||
      (record.deductsFromAnnual &&
          profile.employmentType == EmploymentType.civilServant);

  /// Days counted for [record], one entry per calendar day it covers.
  ///
  /// A half-day record costs half a day, or nothing on a day that does not
  /// count. An hourly record costs `hours / dailyWorkingHours`, at most what
  /// the day itself costs.
  List<DayBreakdown> days(
    LeaveRecord record,
    Profile profile,
    List<Holiday> holidays,
  ) {
    if (record.unit == LeaveUnit.days) {
      return counter.count(record.range, profile, holidays).days;
    }
    final first = counter
        .count(
          DateRange(start: record.range.start, end: record.range.start),
          profile,
          holidays,
        )
        .days
        .first;
    final value = switch (record.unit) {
      LeaveUnit.days => first.value,
      LeaveUnit.halfDay => math.min(0.5, first.value),
      LeaveUnit.hours => _hoursValue(
        record.hours,
        profile.workSchedule.dailyWorkingHours,
        first.value,
      ),
    };
    return [first.copyWith(value: value)];
  }

  /// Total days counted for [record].
  double total(LeaveRecord record, Profile profile, List<Holiday> holidays) =>
      days(
        record,
        profile,
        holidays,
      ).fold<double>(0, (sum, day) => sum + day.value);

  static double _hoursValue(double? hours, double dailyHours, double dayValue) {
    if (hours == null || hours <= 0 || dayValue == 0) return 0;
    // A profile without daily hours cannot convert, the day counts in full.
    if (dailyHours <= 0) return dayValue;
    return math.min(hours / dailyHours, dayValue);
  }
}
