import 'package:izin_planla/domain/bridge/bridge_planner.dart';
import 'package:izin_planla/domain/day_count/balance_calculator.dart';
import 'package:izin_planla/domain/entitlement/entitlement_calculator.dart';
import 'package:izin_planla/domain/models/models.dart';

/// Configurable domain calculators for the reminder tests.
///
/// Records the days the balance was asked for and the bridge budgets, so
/// tests can check what the planner asked.
class StubCalculators
    implements EntitlementCalculator, BalanceCalculator, BridgePlanner {
  /// Accrual dates and days per profile id, in date order.
  final Map<String, List<NextAccrual>> accruals = {};

  /// Balance returned for a profile on a day. Defaults to zero.
  LeaveBalance Function(Profile profile, DateTime today) balanceOf = (_, _) =>
      const LeaveBalance(earned: 0, used: 0, planned: 0, remaining: 0);

  /// Bridge suggestions per year, best first.
  final Map<int, List<BridgeSuggestion>> bridges = {};

  /// Days passed to [balance].
  final List<DateTime> balanceDays = [];

  /// Budgets passed to [suggestions].
  final List<double?> bridgeBudgets = [];

  @override
  List<EntitlementPeriod> periods(Profile profile, {required DateTime until}) =>
      const [];

  @override
  NextAccrual? nextAccrual(Profile profile, DateTime today) =>
      (accruals[profile.id] ?? const <NextAccrual>[])
          .where((accrual) => accrual.date.isAfter(today))
          .firstOrNull;

  @override
  LeaveBalance balance({
    required Profile profile,
    required List<EntitlementPeriod> periods,
    required List<LeaveRecord> leaves,
    required List<Holiday> holidays,
    required DateTime today,
  }) {
    balanceDays.add(today);
    return balanceOf(profile, today);
  }

  @override
  List<BridgeSuggestion> suggestions({
    required int year,
    required Profile profile,
    required List<Holiday> holidays,
    double? budget,
    int maxLeaveDays = 5,
  }) {
    bridgeBudgets.add(budget);
    return bridges[year] ?? const [];
  }

  @override
  List<BridgeSuggestion> optimalPlan({
    required int year,
    required Profile profile,
    required List<Holiday> holidays,
    required double budget,
  }) => const [];
}
