import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/domain/bridge/bridge_plan_optimizer.dart';
import 'package:izin_planla/domain/models/models.dart';

void main() {
  const optimizer = BridgePlanOptimizer();

  BridgeSuggestion break_(int startDay, int length, double cost) {
    final start = DateTime.utc(2027, 1, startDay);
    return BridgeSuggestion(
      leaveDays: [start],
      vacation: DateRange(
        start: start,
        end: DateTime.utc(2027, 1, startDay + length - 1),
      ),
      totalDaysOff: length,
      leaveDaysUsed: cost,
    );
  }

  int daysOff(List<BridgeSuggestion> plan) =>
      plan.fold(0, (sum, s) => sum + s.totalDaysOff);

  double used(List<BridgeSuggestion> plan) =>
      plan.fold(0, (sum, s) => sum + s.leaveDaysUsed);

  test('nothing to pick gives an empty plan', () {
    expect(optimizer.solve(const [], budget: 10), isEmpty);
    expect(optimizer.solve([break_(1, 4, 1)], budget: -1), isEmpty);
    expect(optimizer.solve([break_(1, 4, 1)], budget: double.nan), isEmpty);
    expect(optimizer.solve([break_(1, 4, 1)], budget: 0.5), isEmpty);
  });

  test('breaks that share a day are never both picked', () {
    final a = break_(1, 5, 1);
    final b = break_(5, 4, 1);
    final c = break_(10, 3, 1);
    expect(optimizer.solve([a, b, c], budget: 3), [a, c]);
  });

  test('back to back breaks can both be picked', () {
    final a = break_(1, 4, 1);
    final b = break_(5, 4, 1);
    expect(optimizer.solve([b, a], budget: 2), [a, b]);
  });

  test('equal days off keep the cheaper plan', () {
    final cheap = break_(1, 6, 0.5);
    final dear = break_(10, 6, 1);
    expect(optimizer.solve([dear, cheap], budget: 1), [cheap]);
  });

  test('the budget is rounded down to half days', () {
    final half = break_(1, 6, 0.5);
    final whole = break_(10, 9, 1);
    expect(optimizer.solve([half, whole], budget: 0.9), [half]);
  });

  test('an infinite budget takes every compatible break', () {
    final all = [break_(1, 4, 1), break_(6, 4, 2), break_(12, 9, 5)];
    expect(optimizer.solve(all, budget: double.infinity), all);
  });

  test('free breaks fit in budget 0', () {
    final free = break_(3, 4, 0);
    expect(optimizer.solve([free, break_(10, 9, 1)], budget: 0), [free]);
  });

  test('matches brute force on generated cases', () {
    // Fixed linear congruential generator, so the cases never change.
    var seed = 20270309;
    int next(int bound) {
      seed = (seed * 1103515245 + 12345) & 0x7fffffff;
      return seed % bound;
    }

    for (var round = 0; round < 60; round++) {
      final candidates = [
        for (var i = 0; i < 11; i++)
          break_(1 + next(25), 1 + next(9), next(7) / 2),
      ];
      final budget = next(9) / 2;
      final plan = optimizer.solve(candidates, budget: budget);

      var bestDays = 0;
      var bestCost = 0.0;
      for (var mask = 0; mask < 1 << candidates.length; mask++) {
        final picked = [
          for (var i = 0; i < candidates.length; i++)
            if (mask & (1 << i) != 0) candidates[i],
        ]..sort((a, b) => a.vacation.start.compareTo(b.vacation.start));
        var valid = used(picked) <= budget;
        for (var i = 1; valid && i < picked.length; i++) {
          valid = picked[i].vacation.start.isAfter(picked[i - 1].vacation.end);
        }
        if (!valid) continue;
        final days = daysOff(picked);
        final cost = used(picked);
        if (days > bestDays || (days == bestDays && cost < bestCost)) {
          bestDays = days;
          bestCost = cost;
        }
      }

      expect((daysOff(plan), used(plan)), (bestDays, bestCost));
      for (var i = 1; i < plan.length; i++) {
        expect(plan[i].vacation.start.isAfter(plan[i - 1].vacation.end), true);
      }
    }
  });
}
