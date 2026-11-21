import 'dart:math' as math;

import 'package:izin_planla/domain/models/models.dart';

/// Calendar arithmetic on date-only UTC values used by the entitlement rules.
///
/// Follows `docs/mevzuat.md` section 5: a one-year period ends on the day
/// matching its start day, and a 29 February that does not exist in the
/// target year becomes 28 February (TBK art. 92/3, applied by analogy).
extension CalendarArithmetic on DateTime {
  /// This calendar day as UTC midnight, dropping time and time zone.
  DateTime get dateOnly => DateTime.utc(year, month, day);

  /// The same calendar day [years] years later, or earlier when negative.
  ///
  /// 29 February maps to 28 February in a non-leap year.
  DateTime plusYears(int years) => _clamped(year + years, month, day);

  /// The calendar day [days] days later, or earlier when negative.
  DateTime plusDays(int days) => DateTime.utc(year, month, day + days);

  /// This day minus [service], as calendar arithmetic.
  ///
  /// Years and months are subtracted first, keeping the day of month and
  /// moving it to the month's last day when that month is shorter. The days
  /// are subtracted after that. `docs/mevzuat.md` section 5 only says
  /// "calendar arithmetic", the order is this calculator's choice.
  DateTime minusService(ServiceDuration service) {
    final monthIndex =
        year * 12 + month - 1 - service.years * 12 - service.months;
    // Dart's % is Euclidean, so the month is right for any year sign.
    final monthOfYear = monthIndex % 12;
    final shiftedYear = (monthIndex - monthOfYear) ~/ 12;
    return _clamped(shiftedYear, monthOfYear + 1, day).plusDays(-service.days);
  }

  /// Number of whole years from this day to [other].
  ///
  /// A year is complete on its anniversary, see [plusYears]. Used for age
  /// and length of service. Negative when [other] is a year or more earlier.
  int completedYearsUntil(DateTime other) {
    final start = dateOnly;
    final end = other.dateOnly;
    var years = end.year - start.year;
    if (start.plusYears(years).isAfter(end)) years--;
    return years;
  }

  /// This day as `yyyy-MM-dd`, the format of `AppliedRule.params` dates.
  String get isoDate => const DateOnlyConverter().toJson(this);
}

/// The day [day] of [month] in [year], moved back to the month's last day
/// when the month is shorter.
DateTime _clamped(int year, int month, int day) {
  final lastDay = DateTime.utc(year, month + 1, 0).day;
  return DateTime.utc(year, month, math.min(day, lastDay));
}
