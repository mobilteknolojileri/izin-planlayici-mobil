import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/ui/core/widgets/week_strip_day.dart';
import 'package:material_ui/material_ui.dart';

/// One suggestion card: the suggestion, its days as week strip tiles and
/// whether it is already planned.
@immutable
class BridgeItem {
  /// Creates an item.
  const new({
    required this.suggestion,
    required this.days,
    required this.holidayNames,
    required this.inPlan,
    required this.planned,
  });

  /// The suggestion from the bridge planner.
  final BridgeSuggestion suggestion;

  /// Every day of the break with its meaning.
  final List<WeekStripDay> days;

  /// Holiday names inside the break, without day numbers and repeats.
  final List<String> holidayNames;

  /// Whether the yearly best plan contains this suggestion.
  final bool inPlan;

  /// Whether a stored leave already covers every leave day.
  final bool planned;
}
