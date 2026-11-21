import 'package:izin_planla/ui/core/theme/meaning.dart';
import 'package:material_ui/material_ui.dart';

/// One line of the day details: a mark, a title and an optional second
/// line.
@immutable
class CalendarDayItem {
  /// Creates an item.
  const new({required this.meaning, required this.title, this.subtitle});

  /// The mark shown before the text.
  final Meaning meaning;

  /// Main text.
  final String title;

  /// Optional second line.
  final String? subtitle;
}
