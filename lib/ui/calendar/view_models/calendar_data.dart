import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/ui/calendar/view_models/calendar_day.dart';
import 'package:izin_planla/ui/calendar/view_models/calendar_leave_entry.dart';
import 'package:izin_planla/ui/calendar/view_models/calendar_month_summary.dart';
import 'package:izin_planla/ui/core/theme/meaning.dart';
import 'package:material_ui/material_ui.dart';

/// The stored data behind the calendar, indexed by day.
@immutable
class CalendarData {
  /// Indexes [leaves], [holidays] and [bridges] by day.
  new({
    required this.today,
    required this.profiles,
    required this.activeProfile,
    required Map<String, List<LeaveRecord>> leaves,
    required List<Holiday> holidays,
    required List<BridgeSuggestion> bridges,
  }) : _holidays = {for (final holiday in holidays) holiday.date: holiday},
       _bridges = {
         for (final bridge in bridges)
           for (final day in bridge.leaveDays) day: bridge,
       },
       _leaves = _byDay(leaves, profiles, today);

  /// Today, UTC midnight.
  final DateTime today;

  /// Every stored person.
  final List<Profile> profiles;

  /// The person shown when the everyone view is off, null before setup.
  final Profile? activeProfile;

  final Map<DateTime, Holiday> _holidays;
  final Map<DateTime, BridgeSuggestion> _bridges;
  final Map<DateTime, List<(String, CalendarLeaveEntry)>> _leaves;

  /// Whether more than one person is stored, so the everyone view helps.
  bool get hasManyPeople => profiles.length > 1;

  static Map<DateTime, List<(String, CalendarLeaveEntry)>> _byDay(
    Map<String, List<LeaveRecord>> leaves,
    List<Profile> profiles,
    DateTime today,
  ) {
    final names = {for (final profile in profiles) profile.id: profile.name};
    final result = <DateTime, List<(String, CalendarLeaveEntry)>>{};
    for (final MapEntry(key: profileId, value: records) in leaves.entries) {
      for (final record in records) {
        final entry = CalendarLeaveEntry(
          record: record,
          planned: record.range.start.isAfter(today),
          personName: names[profileId],
        );
        for (var i = 0; i < record.range.dayCount; i++) {
          final day = record.range.start.add(Duration(days: i));
          (result[_dateOnly(day)] ??= []).add((profileId, entry));
        }
      }
    }
    return result;
  }

  static DateTime _dateOnly(DateTime date) =>
      DateTime.utc(date.year, date.month, date.day);

  /// The calendar day [date]. With [everyone], leave of every person is
  /// included and named, otherwise only the active person's leave.
  CalendarDay dayAt(DateTime date, {required bool everyone}) {
    final day = _dateOnly(date);
    final holiday = _holidays[day];
    final activeId = activeProfile?.id;
    final leaves = <CalendarLeaveEntry>[
      for (final (profileId, entry)
          in _leaves[day] ?? const <(String, CalendarLeaveEntry)>[])
        if (everyone)
          entry
        else if (profileId == activeId)
          CalendarLeaveEntry(record: entry.record, planned: entry.planned),
    ];
    final bridge = everyone ? null : _bridges[day];
    final workDays =
        activeProfile?.workSchedule.workDays ?? const WorkSchedule().workDays;
    final Meaning meaning;
    if (holiday != null && !holiday.halfDay) {
      meaning = Meaning.holiday;
    } else if (holiday != null) {
      meaning = Meaning.eve;
    } else if (leaves.isNotEmpty) {
      meaning = leaves.every((entry) => entry.planned)
          ? Meaning.planned
          : Meaning.used;
    } else if (bridge != null) {
      meaning = Meaning.bridge;
    } else if (!workDays.contains(day.weekday)) {
      meaning = Meaning.weekend;
    } else {
      meaning = Meaning.workday;
    }
    return CalendarDay(
      date: day,
      meaning: meaning,
      isToday: day == today,
      holiday: holiday,
      leaves: leaves,
      bridge: bridge,
    );
  }

  /// Counts of [month] for the year view.
  CalendarMonthSummary summaryOf(DateTime month, {required bool everyone}) {
    final first = DateTime.utc(month.year, month.month);
    final length = DateTime.utc(month.year, month.month + 1, 0).day;
    var holidays = 0;
    var leaves = 0;
    var bridges = 0;
    for (var i = 0; i < length; i++) {
      final day = dayAt(first.add(Duration(days: i)), everyone: everyone);
      if (day.holiday != null) holidays++;
      if (day.leaves.isNotEmpty) leaves++;
      if (day.bridge != null && day.leaves.isEmpty) bridges++;
    }
    return CalendarMonthSummary(
      month: first,
      holidayDays: holidays,
      leaveDays: leaves,
      bridgeDays: bridges,
    );
  }
}
