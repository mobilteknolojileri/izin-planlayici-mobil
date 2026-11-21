import 'package:intl/intl.dart';

/// Date formats the calendar needs beyond `AppFormat`.
abstract final class CalendarDateFormat {
  /// Month and year: `Kasım 2026`.
  static String monthYear(DateTime date, String locale) =>
      DateFormat.yMMMM(locale).format(date);

  /// Month name: `Kasım`.
  static String month(DateTime date, String locale) =>
      DateFormat.MMMM(locale).format(date);

  /// Short weekday name for the grid header: `Pzt`.
  static String weekdayShort(DateTime date, String locale) =>
      DateFormat.E(locale).format(date);

  /// One letter weekday name, when the short name does not fit: `P`.
  static String weekdayNarrow(DateTime date, String locale) =>
      DateFormat('EEEEE', locale).format(date);
}
