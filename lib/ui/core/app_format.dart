import 'package:intl/intl.dart';
import 'package:izin_planla/domain/models/models.dart';

/// Number and date formats shown to the user, in the app locale.
///
/// Turkish date data must be loaded with `initializeDateFormatting` first,
/// `main.dart` does this before `runApp`.
abstract final class AppFormat {
  /// A day count without needless decimals: `18`, `4,5`.
  static String days(double value, String locale) =>
      NumberFormat.decimalPattern(locale).format(value);

  /// Full date with weekday: `20 Kasım 2026, Cuma`.
  static String longDate(DateTime date, String locale) =>
      DateFormat('d MMMM y, EEEE', locale).format(date);

  /// Short weekday name: `Cum`.
  static String weekdayShort(DateTime date, String locale) =>
      DateFormat.E(locale).format(date);

  /// Day of the month: `20`.
  static String dayOfMonth(DateTime date, String locale) =>
      DateFormat.d(locale).format(date);

  /// [range] in the short form of `docs/tasarim.md`: `6-10 Temmuz 2026`,
  /// `29 Ekim-1 Kasım 2026`, `28 Aralık 2026-3 Ocak 2027`. A single day is
  /// written in full: `6 Temmuz 2026, Pazartesi`.
  static String dayRange(DateRange range, String locale) {
    final start = range.start;
    final end = range.end;
    if (start == end) return longDate(start, locale);
    final full = DateFormat('d MMMM y', locale).format(end);
    final String from;
    if (start.year != end.year) {
      from = DateFormat('d MMMM y', locale).format(start);
    } else if (start.month != end.month) {
      from = DateFormat('d MMMM', locale).format(start);
    } else {
      from = dayOfMonth(start, locale);
    }
    return '$from-$full';
  }
}
