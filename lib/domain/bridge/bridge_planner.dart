import 'package:izin_planla/domain/models/models.dart';

/// Finds leave days that join holidays and weekends into long breaks.
abstract interface class BridgePlanner {
  /// Bridge suggestions for [year], best first.
  ///
  /// [budget] limits the leave days per suggestion when given. [after],
  /// when given, keeps only breaks that start after that day, so a past
  /// break is never suggested.
  List<BridgeSuggestion> suggestions({
    required int year,
    required Profile profile,
    required List<Holiday> holidays,
    double? budget,
    int maxLeaveDays = 5,
    DateTime? after,
  });

  /// Non-overlapping suggestions that give the most days off for [budget].
  ///
  /// [after] works as in [suggestions], so the budget is spent only on
  /// breaks that can still be taken.
  List<BridgeSuggestion> optimalPlan({
    required int year,
    required Profile profile,
    required List<Holiday> holidays,
    required double budget,
    DateTime? after,
  });
}
