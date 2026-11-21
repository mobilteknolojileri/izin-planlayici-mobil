import 'package:izin_planla/ui/core/theme/meaning.dart';
import 'package:material_ui/material_ui.dart';

/// One day in a `WeekStrip`.
@immutable
class WeekStripDay {
  /// Creates a day. [date] is a UTC midnight date.
  const new({required this.date, required this.meaning});

  /// The calendar day.
  final DateTime date;

  /// What kind of day it is: workday, leave, holiday, eve or weekend.
  final Meaning meaning;

  @override
  bool operator ==(Object other) =>
      other is WeekStripDay && other.date == date && other.meaning == meaning;

  @override
  int get hashCode => Object.hash(date, meaning);
}
