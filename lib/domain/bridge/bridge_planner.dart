import 'package:izin_planla/domain/models/models.dart';

/// Finds leave days that join holidays and weekends into long breaks.
abstract interface class BridgePlanner {
  /// Bridge suggestions for [year], best first.
  ///
  /// [budget] limits the leave days per suggestion when given.
  List<BridgeSuggestion> suggestions({
    required int year,
    required Profile profile,
    required List<Holiday> holidays,
    double? budget,
    int maxLeaveDays = 5,
  });

  /// Non-overlapping suggestions that give the most days off for [budget].
  List<BridgeSuggestion> optimalPlan({
    required int year,
    required Profile profile,
    required List<Holiday> holidays,
    required double budget,
  });
}
