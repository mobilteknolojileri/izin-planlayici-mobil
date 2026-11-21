import 'dart:math' as math;

import 'package:izin_planla/domain/bridge/bridge_calendar.dart';
import 'package:izin_planla/domain/models/models.dart';

/// Picks the suggestions that give the most days off for a leave budget.
///
/// Weighted interval scheduling with a knapsack dimension, solved by
/// dynamic programming over the days of the year and the budget in half
/// days. Deterministic and fast enough to run on every screen build.
final class BridgePlanOptimizer {
  /// Creates the optimizer.
  const new();

  /// The best plan from [candidates] that fits in [budget] leave days, in
  /// date order.
  ///
  /// Breaks in the plan never share a day. The plan with the most days off
  /// wins, between equal plans the one that uses fewer leave days. Costs are
  /// counted in half days: a cost is rounded up and [budget] down to the
  /// nearest half day. A negative or NaN [budget] gives an empty plan.
  List<BridgeSuggestion> solve(
    List<BridgeSuggestion> candidates, {
    required double budget,
  }) {
    if (candidates.isEmpty || budget.isNaN || budget < 0) return const [];

    final starts = [
      for (final c in candidates) BridgeCalendar.dayNumber(c.vacation.start),
    ];
    final ends = [
      for (final c in candidates) BridgeCalendar.dayNumber(c.vacation.end),
    ];
    final costs = [
      for (final c in candidates) math.max(0, (c.leaveDaysUsed * 2).ceil()),
    ];
    final first = starts.reduce(math.min);
    final span = ends.reduce(math.max) - first + 1;
    final byEnd = List.generate(span, (_) => <int>[]);
    for (var i = 0; i < candidates.length; i++) {
      byEnd[ends[i] - first].add(i);
    }

    // The most half days any plan can spend bounds the budget dimension, so
    // a huge or infinite budget stays cheap.
    final reach = List<int>.filled(span + 1, 0);
    for (var t = 0; t < span; t++) {
      var best = reach[t];
      for (final i in byEnd[t]) {
        best = math.max(best, reach[starts[i] - first] + costs[i]);
      }
      reach[t + 1] = best;
    }
    final units = budget * 2 >= reach[span]
        ? reach[span]
        : (budget * 2).floor();

    // score = days off * width - half days used: more days always wins,
    // fewer leave days breaks the tie because the cost stays below width.
    final width = units + 1;
    final score = List<int>.filled((span + 1) * width, 0);
    final choice = List<int>.filled((span + 1) * width, -1);
    for (var t = 0; t < span; t++) {
      final row = (t + 1) * width;
      final previousRow = t * width;
      for (var w = 0; w < width; w++) {
        score[row + w] = score[previousRow + w];
      }
      for (final i in byEnd[t]) {
        final cost = costs[i];
        if (cost > units) continue;
        final value = candidates[i].totalDaysOff * width - cost;
        final startRow = (starts[i] - first) * width;
        for (var w = cost; w < width; w++) {
          final candidate = score[startRow + w - cost] + value;
          if (candidate > score[row + w]) {
            score[row + w] = candidate;
            choice[row + w] = i;
          }
        }
      }
    }

    final plan = <BridgeSuggestion>[];
    var t = span;
    var w = units;
    while (t > 0) {
      final i = choice[t * width + w];
      if (i < 0) {
        t--;
      } else {
        plan.add(candidates[i]);
        w -= costs[i];
        t = starts[i] - first;
      }
    }
    return plan.reversed.toList(growable: false);
  }
}
