import 'package:material_ui/material_ui.dart';

/// Counts shown for one month in the year view.
@immutable
class CalendarMonthSummary {
  /// Creates a summary.
  const new({
    required this.month,
    required this.holidayDays,
    required this.leaveDays,
    required this.bridgeDays,
  });

  /// First day of the month, UTC midnight.
  final DateTime month;

  /// Days with an official holiday or eve.
  final int holidayDays;

  /// Days with a leave record.
  final int leaveDays;

  /// Suggested bridge leave days.
  final int bridgeDays;
}
