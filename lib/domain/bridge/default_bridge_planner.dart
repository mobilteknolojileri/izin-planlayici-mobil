import 'dart:math' as math;

import 'package:izin_planla/domain/bridge/bridge_calendar.dart';
import 'package:izin_planla/domain/bridge/bridge_day_kind.dart';
import 'package:izin_planla/domain/bridge/bridge_plan_optimizer.dart';
import 'package:izin_planla/domain/bridge/bridge_planner.dart';
import 'package:izin_planla/domain/bridge/compare_bridge_suggestions.dart';
import 'package:izin_planla/domain/day_count/default_leave_day_counter.dart';
import 'package:izin_planla/domain/day_count/leave_day_counter.dart';
import 'package:izin_planla/domain/models/models.dart';

/// Implementation of [BridgePlanner]. Written by task 09.
///
/// A suggestion is one leave record that runs from its first to its last
/// leave day, plus the free days around it that join into one continuous
/// break. `leaveDaysUsed` is what the [LeaveDayCounter] deducts for that
/// record, so eves (`docs/mevzuat.md` 4), the Saturday setting (1.10) and
/// the civil servant weekend rule (2.5) follow the law without a second copy
/// of the rules here.
///
/// Rules of the search:
/// - Every leave day lies in the requested year. The break may run into the
///   neighbouring year.
/// - A break must contain a holiday or administrative leave that frees a
///   working day. A plain weekend with leave is not a bridge.
/// - Civil servant teachers get no annual leave (657 md. 103/2, section 2.2)
///   and get no suggestions.
class DefaultBridgePlanner implements BridgePlanner {
  /// Creates the planner. `counter` prices every leave range.
  const new({this._counter = const DefaultLeaveDayCounter()});

  final LeaveDayCounter _counter;

  /// Bridge suggestions for [year], best first.
  ///
  /// A suggestion is kept when its leave days used fit in [maxLeaveDays] and
  /// in [budget] when given. Suggestions that cover the same holidays form a
  /// group: the best of every group comes first, ordered by
  /// [compareBridgeSuggestions], then all the other suggestions in the same
  /// order.
  @override
  List<BridgeSuggestion> suggestions({
    required int year,
    required Profile profile,
    required List<Holiday> holidays,
    double? budget,
    int maxLeaveDays = 5,
    DateTime? after,
  }) {
    final limit = budget == null
        ? maxLeaveDays.toDouble()
        : math.min(budget, maxLeaveDays.toDouble());
    final candidates = _candidates(year, profile, holidays, limit, after)
      ..sort((a, b) => compareBridgeSuggestions(a.suggestion, b.suggestion));

    final groups = <String>{};
    final leaders = <BridgeSuggestion>[];
    final others = <BridgeSuggestion>[];
    for (final candidate in candidates) {
      (groups.add(candidate.group) ? leaders : others).add(
        candidate.suggestion,
      );
    }
    return List.unmodifiable([...leaders, ...others]);
  }

  /// Non-overlapping suggestions for [year] that give the most days off
  /// for [budget], in date order.
  ///
  /// Breaks in the plan never share a day. Between plans with equal days off
  /// the one that uses fewer leave days wins. See [BridgePlanOptimizer].
  @override
  List<BridgeSuggestion> optimalPlan({
    required int year,
    required Profile profile,
    required List<Holiday> holidays,
    required double budget,
    DateTime? after,
  }) => const BridgePlanOptimizer().solve([
    for (final candidate in _candidates(year, profile, holidays, budget, after))
      candidate.suggestion,
  ], budget: budget);

  /// Every leave range in [year] that costs at most [limit] days and makes
  /// a bridge, in date order. With [after], breaks that start on or before
  /// that day are left out.
  List<_Candidate> _candidates(
    int year,
    Profile profile,
    List<Holiday> holidays,
    double limit,
    DateTime? after,
  ) {
    if (limit.isNaN || limit < 0) return [];
    if (profile.employmentType == EmploymentType.civilServant &&
        profile.isTeacher) {
      return [];
    }
    final calendar = BridgeCalendar(profile, holidays);
    if (!calendar.hasWorkDays) return [];

    final first = BridgeCalendar.dayNumber(DateTime.utc(year));
    final last = BridgeCalendar.dayNumber(DateTime.utc(year, 12, 31));
    // A counted day costs at most 1, so no record in the year costs more
    // than its number of days.
    final maxCost = math.min(limit, (last - first + 1).toDouble());
    final yearHolidays = [
      for (final holiday in holidays)
        if (BridgeCalendar.dayNumber(holiday.date) case final day
            when day >= first && day <= last)
          holiday,
    ];

    final afterDay = after == null ? null : BridgeCalendar.dayNumber(after);

    final result = <_Candidate>[];
    for (var start = first; start <= last; start++) {
      if (!calendar.kindOf(start).needsLeave) continue;
      final breakStart = calendar.breakStartFor(start);
      if (afterDay != null && breakStart <= afterDay) continue;
      // A working day that is not a holiday costs a full day under 4857
      // (1.9) and 657 (2.5), so this count is a lower bound of the cost.
      var fullDays = 0;
      for (var end = start; end <= last; end++) {
        final kind = calendar.kindOf(end);
        if (kind == BridgeDayKind.workday) fullDays++;
        if (fullDays > maxCost) break;
        if (!kind.needsLeave) continue;
        final breakEnd = calendar.breakEndFor(end);
        if (!calendar.hasTimeOffIn(breakStart, breakEnd)) continue;
        final used = _counter
            .count(
              DateRange(
                start: BridgeCalendar.dateOf(start),
                end: BridgeCalendar.dateOf(end),
              ),
              profile,
              yearHolidays,
            )
            .total;
        if (used > maxCost) continue;
        result.add(
          _Candidate(
            suggestion: BridgeSuggestion(
              leaveDays: [
                for (var day = start; day <= end; day++)
                  if (calendar.kindOf(day).needsLeave)
                    BridgeCalendar.dateOf(day),
              ],
              vacation: DateRange(
                start: BridgeCalendar.dateOf(breakStart),
                end: BridgeCalendar.dateOf(breakEnd),
              ),
              totalDaysOff: breakEnd - breakStart + 1,
              leaveDaysUsed: used,
              holidayNames: calendar.holidayNamesIn(breakStart, breakEnd),
            ),
            group: calendar.clustersIn(breakStart, breakEnd).join(','),
          ),
        );
      }
    }
    return result;
  }
}

/// A suggestion and the key of the holidays it covers.
final class _Candidate {
  const new({required this.suggestion, required this.group});

  final BridgeSuggestion suggestion;
  final String group;
}
