import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/calendar/view_models/calendar_day.dart';
import 'package:izin_planla/ui/calendar/widgets/calendar_day_item.dart';
import 'package:izin_planla/ui/core/app_format.dart';
import 'package:izin_planla/ui/core/theme/meaning.dart';
import 'package:izin_planla/ui/leave_form/widgets/leave_texts.dart';

/// Words for a calendar day, shared by the day tile and the day details so
/// a screen reader hears what the details show.
abstract final class CalendarDayText {
  /// What happens on [day], most important first.
  static List<CalendarDayItem> items(
    AppLocalizations l10n,
    String locale,
    CalendarDay day,
  ) {
    final holiday = day.holiday;
    final bridge = day.bridge;
    final result = <CalendarDayItem>[
      if (holiday != null && !holiday.halfDay)
        CalendarDayItem(
          meaning: Meaning.holiday,
          title: l10n.coreDayReasonHolidayNamed(holiday.name),
        ),
      if (holiday != null && holiday.halfDay)
        CalendarDayItem(
          meaning: Meaning.eve,
          title: l10n.coreDayReasonHalfDayNamed(holiday.name),
        ),
      for (final entry in day.leaves)
        () {
          final type = LeaveTexts.recordLabel(l10n, entry.record);
          final range = AppFormat.dayRange(entry.record.range, locale);
          final person = entry.personName;
          final meaning = entry.planned ? Meaning.planned : Meaning.used;
          return CalendarDayItem(
            meaning: meaning,
            title: person == null
                ? l10n.calendarLeaveItem(type, range)
                : l10n.calendarPersonLeaveItem(person, type, range),
            subtitle: meaning.label(l10n),
          );
        }(),
      if (bridge != null && day.leaves.isEmpty)
        CalendarDayItem(
          meaning: Meaning.bridge,
          title: l10n.calendarBridgeItem(
            bridge.leaveDaysUsed,
            bridge.totalDaysOff,
            AppFormat.dayRange(bridge.vacation, locale),
          ),
          subtitle: Meaning.bridge.label(l10n),
        ),
    ];
    if (result.isEmpty) {
      final meaning = day.meaning == Meaning.weekend
          ? Meaning.weekend
          : Meaning.workday;
      result.add(CalendarDayItem(meaning: meaning, title: meaning.label(l10n)));
    }
    return result;
  }

  /// What a screen reader hears after the date of a day tile: today, then
  /// every item.
  static String details(
    AppLocalizations l10n,
    String locale,
    CalendarDay day,
  ) => [
    if (day.isToday) l10n.calendarToday,
    for (final item in items(l10n, locale, day)) item.title,
  ].join(', ');

  /// Short date range of the days the user selected, with the day count.
  static String rangeSelected(
    AppLocalizations l10n,
    String locale,
    DateTime start,
    DateTime end,
  ) {
    final range = DateRange(start: start, end: end);
    return l10n.calendarRangeSelected(
      range.dayCount,
      AppFormat.dayRange(range, locale),
    );
  }
}
