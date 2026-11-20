import 'package:izin_planla/domain/day_count/split_rule_checker.dart';
import 'package:izin_planla/domain/models/models.dart';

/// Implementation of [SplitRuleChecker]. Written by task 08.
class DefaultSplitRuleChecker implements SplitRuleChecker {
  /// Creates the calculator.
  const new();

  @override
  List<LeaveWarning> check({
    required Profile profile,
    required List<EntitlementPeriod> periods,
    required List<LeaveRecord> leaves,
    required List<Holiday> holidays,
  }) => throw UnimplementedError();
}
