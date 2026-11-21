import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_planla/ui/calendar/view_models/calendar_data.dart';
import 'package:izin_planla/ui/calendar/view_models/calendar_view_mode.dart';
import 'package:material_ui/material_ui.dart';

/// What the calendar screen shows: the stored data and the user's choices.
@immutable
class CalendarState {
  /// Creates the state.
  const new({
    required this.data,
    required this.focusedMonth,
    required this.firstDay,
    required this.lastDay,
    this.mode = CalendarViewMode.month,
    this.everyone = false,
    this.rangeMode = false,
    this.selectedDay,
    this.rangeStart,
    this.rangeEnd,
  });

  /// Leave, holidays and bridges, loading or failed.
  final AsyncValue<CalendarData> data;

  /// First day of the month or year on screen, UTC midnight.
  final DateTime focusedMonth;

  /// Earliest day the calendar can show.
  final DateTime firstDay;

  /// Latest day the calendar can show.
  final DateTime lastDay;

  /// Month or year layout.
  final CalendarViewMode mode;

  /// Whether the leave of every person is shown.
  final bool everyone;

  /// Whether taps select a range for a new leave.
  final bool rangeMode;

  /// Day whose details are shown, when [rangeMode] is off.
  final DateTime? selectedDay;

  /// First day of the selected range.
  final DateTime? rangeStart;

  /// Last day of the selected range, null while the user picks it.
  final DateTime? rangeEnd;

  /// Whether an earlier month or year exists.
  bool get canGoBack => mode == CalendarViewMode.month
      ? focusedMonth.isAfter(firstDay)
      : focusedMonth.year > firstDay.year;

  /// Whether a later month or year exists.
  bool get canGoForward => mode == CalendarViewMode.month
      ? DateTime.utc(
          focusedMonth.year,
          focusedMonth.month + 1,
        ).isBefore(lastDay)
      : focusedMonth.year < lastDay.year;
}
