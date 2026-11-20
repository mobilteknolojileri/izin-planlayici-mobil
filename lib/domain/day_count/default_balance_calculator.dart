import 'package:izin_planla/domain/day_count/balance_calculator.dart';
import 'package:izin_planla/domain/models/models.dart';

/// Implementation of [BalanceCalculator]. Written by task 08.
class DefaultBalanceCalculator implements BalanceCalculator {
  /// Creates the calculator.
  const new();

  @override
  LeaveBalance balance({
    required Profile profile,
    required List<EntitlementPeriod> periods,
    required List<LeaveRecord> leaves,
    required List<Holiday> holidays,
    required DateTime today,
  }) => throw UnimplementedError();
}
