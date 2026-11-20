import 'package:izin_planla/domain/bridge/bridge_planner.dart';
import 'package:izin_planla/domain/models/models.dart';

/// Implementation of [BridgePlanner]. Written by task 09.
class DefaultBridgePlanner implements BridgePlanner {
  /// Creates the calculator.
  const new();

  @override
  List<BridgeSuggestion> suggestions({
    required int year,
    required Profile profile,
    required List<Holiday> holidays,
    double? budget,
    int maxLeaveDays = 5,
  }) => throw UnimplementedError();

  @override
  List<BridgeSuggestion> optimalPlan({
    required int year,
    required Profile profile,
    required List<Holiday> holidays,
    required double budget,
  }) => throw UnimplementedError();
}
