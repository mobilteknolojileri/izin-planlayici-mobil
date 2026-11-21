import 'package:izin_planla/domain/day_count/leave_cost.dart';
import 'package:izin_planla/domain/day_count/split_rule_checker.dart';
import 'package:izin_planla/domain/models/models.dart';

/// Implementation of [SplitRuleChecker]. Written by task 08.
///
/// Labour Law (`docs/mevzuat.md` 1.11 and 1.12): each entitlement period
/// owns the records that start on or after its accrual date and before the
/// next accrual date. Records before the first accrual are not checked.
///
/// Civil servants (mevzuat 2.6 and 2.7): no split rule, travel leave is
/// summed per calendar year.
///
/// Days are counted days of [LeaveCost]. Warning params use machine formats:
/// dates as `yyyy-MM-dd`, days as `4` or `4.5`.
///
/// - [LeaveWarningType.splitRule]: `accrualDate`, `parts` (number of
///   records), `longestDays`, `minimumDays` (`10`), `legalReference`.
/// - [LeaveWarningType.travelLeaveLimit]: `days`, `limitDays` (`4`),
///   `legalReference`, plus `accrualDate` (4857) or `year` (657).
class DefaultSplitRuleChecker implements SplitRuleChecker {
  /// Creates the calculator.
  const new();

  /// At least one part of a split annual leave must reach this many days
  /// (4857 md. 56/3). The limit itself is enough.
  static const minimumPartDays = 10;

  /// Most travel leave days in a period (4857 md. 56/6) or a calendar year
  /// (657 md. 102).
  static const travelLimitDays = 4;

  @override
  List<LeaveWarning> check({
    required Profile profile,
    required List<EntitlementPeriod> periods,
    required List<LeaveRecord> leaves,
    required List<Holiday> holidays,
  }) => switch (profile.employmentType) {
    EmploymentType.laborLaw => _laborLaw(profile, periods, leaves, holidays),
    EmploymentType.civilServant => _civilServant(profile, leaves, holidays),
  };

  static List<LeaveWarning> _laborLaw(
    Profile profile,
    List<EntitlementPeriod> periods,
    List<LeaveRecord> leaves,
    List<Holiday> holidays,
  ) {
    const cost = LeaveCost();
    final accruals = {
      for (final p in periods) _dateOnly(p.accrualDate),
    }.toList()..sort();
    final warnings = <LeaveWarning>[];
    for (final (i, accrual) in accruals.indexed) {
      final next = i + 1 < accruals.length ? accruals[i + 1] : null;
      bool inPeriod(LeaveRecord leave) {
        final start = _dateOnly(leave.range.start);
        return !start.isBefore(accrual) &&
            (next == null || start.isBefore(next));
      }

      final owned = leaves.where(inPeriod).toList();
      final parts = [
        for (final leave in owned)
          if (leave.type == LeaveType.annual)
            cost.total(leave, profile, holidays),
      ].where((days) => days > 0).toList();
      final longest = parts.fold<double>(0, (max, d) => d > max ? d : max);
      if (parts.length > 1 && longest < minimumPartDays) {
        warnings.add(
          LeaveWarning(
            type: LeaveWarningType.splitRule,
            params: {
              'accrualDate': _formatDate(accrual),
              'parts': '${parts.length}',
              'longestDays': _formatDays(longest),
              'minimumDays': '$minimumPartDays',
              'legalReference': '4857 md. 56',
            },
          ),
        );
      }

      final travel = owned
          .where((leave) => leave.type == LeaveType.travel)
          .fold<double>(
            0,
            (sum, leave) => sum + cost.total(leave, profile, holidays),
          );
      if (travel > travelLimitDays) {
        warnings.add(
          _travelWarning(travel, '4857 md. 56', {
            'accrualDate': _formatDate(accrual),
          }),
        );
      }
    }
    return warnings;
  }

  static List<LeaveWarning> _civilServant(
    Profile profile,
    List<LeaveRecord> leaves,
    List<Holiday> holidays,
  ) {
    const cost = LeaveCost();
    final byYear = <int, double>{};
    for (final leave in leaves) {
      if (leave.type != LeaveType.travel) continue;
      for (final day in cost.days(leave, profile, holidays)) {
        byYear.update(
          day.date.year,
          (sum) => sum + day.value,
          ifAbsent: () => day.value,
        );
      }
    }
    final entries = byYear.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return [
      for (final MapEntry(key: year, value: days) in entries)
        if (days > travelLimitDays)
          _travelWarning(days, '657 md. 102', {'year': '$year'}),
    ];
  }

  static LeaveWarning _travelWarning(
    double days,
    String legalReference,
    Map<String, String> scope,
  ) => LeaveWarning(
    type: LeaveWarningType.travelLeaveLimit,
    params: {
      ...scope,
      'days': _formatDays(days),
      'limitDays': '$travelLimitDays',
      'legalReference': legalReference,
    },
  );

  static DateTime _dateOnly(DateTime date) =>
      DateTime.utc(date.year, date.month, date.day);

  static String _formatDate(DateTime date) =>
      const DateOnlyConverter().toJson(date);

  static String _formatDays(double days) =>
      days == days.roundToDouble() ? '${days.toInt()}' : '$days';
}
