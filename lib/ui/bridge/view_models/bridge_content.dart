import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/ui/bridge/view_models/bridge_item.dart';
import 'package:material_ui/material_ui.dart';

/// The loaded bridge screen for the chosen year and budget.
@immutable
class BridgeContent {
  /// Creates the content.
  const new({
    required this.profile,
    required this.years,
    required this.year,
    required this.budget,
    required this.remaining,
    required this.planTotalDays,
    required this.planLeaveDays,
    required this.planCount,
    required this.items,
  });

  /// The active person, null before setup.
  final Profile? profile;

  /// Years with holiday data, from this year on.
  final List<int> years;

  /// The chosen year.
  final int year;

  /// Leave days the user wants to spend.
  final int budget;

  /// Annual leave days left today.
  final double remaining;

  /// Days off in the yearly best plan.
  final int planTotalDays;

  /// Leave days the yearly best plan costs.
  final double planLeaveDays;

  /// Number of breaks in the yearly best plan.
  final int planCount;

  /// Suggestions in the chosen order.
  final List<BridgeItem> items;

  /// Lowest budget the stepper allows.
  static const minBudget = 1;

  /// Highest budget the stepper allows.
  int get maxBudget => remaining.ceil() > 30 ? remaining.ceil() : 30;
}
