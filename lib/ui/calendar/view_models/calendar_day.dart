import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/ui/calendar/view_models/calendar_leave_entry.dart';
import 'package:izin_planla/ui/core/theme/meaning.dart';
import 'package:material_ui/material_ui.dart';

/// Everything the calendar shows for one day.
@immutable
class CalendarDay {
  /// Creates a day.
  const new({
    required this.date,
    required this.meaning,
    required this.isToday,
    this.holiday,
    this.leaves = const [],
    this.bridge,
  });

  /// UTC midnight date.
  final DateTime date;

  /// The mark of the day tile: holiday, eve, leave, bridge, weekend or
  /// workday, in this order of importance.
  final Meaning meaning;

  /// Whether this is today.
  final bool isToday;

  /// Official holiday on this day, if any.
  final Holiday? holiday;

  /// Leave records that contain this day.
  final List<CalendarLeaveEntry> leaves;

  /// Bridge suggestion that asks for leave on this day, if any.
  final BridgeSuggestion? bridge;
}
