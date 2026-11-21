import 'dart:math' as math;

import 'package:izin_planla/data/services/notifications/reminder.dart';
import 'package:izin_planla/data/services/notifications/scheduled_reminder.dart';
import 'package:izin_planla/data/services/notifications/stable_notification_id.dart';
import 'package:izin_planla/domain/bridge/bridge_planner.dart';
import 'package:izin_planla/domain/day_count/balance_calculator.dart';
import 'package:izin_planla/domain/entitlement/entitlement_calculator.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:timezone/timezone.dart' as tz;

typedef _Candidate = ({tz.TZDateTime fireAt, Reminder reminder});

/// Decides which reminders fire and when, from the current data.
///
/// Pure: no IO and no clock, the caller passes `now`. Every time is a wall
/// clock time in [location]. Rules for the year-end reminder come from
/// `docs/mevzuat.md` 1.8 (4857) and 2.4 (657).
class ReminderPlanner {
  /// Creates a planner that keeps at most [maxReminders] reminders.
  const new({
    required this.location,
    required this.entitlementCalculator,
    required this.balanceCalculator,
    required this.bridgePlanner,
    this.maxReminders = defaultMaxReminders,
  });

  /// Default for [maxReminders]. Keeps the nearest reminders well below the
  /// platform limits. Every reschedule refills the list.
  static const defaultMaxReminders = 50;

  /// Hour of the day for holiday, bridge, accrual, leave start and year-end
  /// reminders.
  static const morningHour = 9;

  /// Hour of the evening before the return day.
  static const eveningHour = 18;

  // How far to look for the next or previous working day.
  static const _searchDays = 60;

  /// Time zone of every reminder, `Europe/Istanbul`.
  final tz.Location location;

  /// Gives the next accrual of each profile.
  final EntitlementCalculator entitlementCalculator;

  /// Gives the remaining and expiring days of each profile.
  final BalanceCalculator balanceCalculator;

  /// Gives the bridge suggestions of the active profile.
  final BridgePlanner bridgePlanner;

  /// Upper limit of the returned reminders, the nearest ones are kept.
  final int maxReminders;

  /// Reminders that fire after [now], ordered by fire time.
  ///
  /// Only the reminders turned on in `settings.notifications` are planned.
  /// Holiday and bridge reminders use the active profile. Accrual, leave and
  /// year-end reminders are planned for every profile.
  List<ScheduledReminder> plan({
    required DateTime now,
    required AppSettings settings,
    required List<Profile> profiles,
    required Map<String, List<LeaveRecord>> leavesByProfile,
    required List<Holiday> holidays,
  }) {
    final localNow = tz.TZDateTime.from(now, location);
    final today = DateTime.utc(localNow.year, localNow.month, localNow.day);
    final preferences = settings.notifications;
    final candidates = <String, _Candidate>{};

    void add(String key, tz.TZDateTime fireAt, Reminder reminder) {
      if (!fireAt.isAfter(localNow)) return;
      candidates.putIfAbsent(key, () => (fireAt: fireAt, reminder: reminder));
    }

    if (preferences.holidayReminder) {
      final active =
          profiles.where((p) => p.id == settings.activeProfileId).firstOrNull ??
          profiles.firstOrNull;
      _planHolidays(
        add: add,
        localNow: localNow,
        today: today,
        daysBefore: math.max(0, preferences.holidayDaysBefore),
        holidays: holidays,
        activeProfile: active,
        activeLeaves: active == null
            ? const []
            : leavesByProfile[active.id] ?? const [],
      );
    }

    for (final profile in profiles) {
      final leaves = leavesByProfile[profile.id] ?? const <LeaveRecord>[];
      if (preferences.accrualReminder) {
        _planAccrual(add: add, today: today, profile: profile);
      }
      if (preferences.plannedLeaveReminder) {
        _planLeaves(
          add: add,
          daysBefore: math.max(0, preferences.plannedLeaveDaysBefore),
          profile: profile,
          leaves: leaves,
          holidays: holidays,
        );
      }
      if (preferences.yearEndReminder) {
        _planYearEnd(
          add: add,
          localNow: localNow,
          profile: profile,
          leaves: leaves,
          holidays: holidays,
        );
      }
    }

    return _finish(candidates);
  }

  void _planHolidays({
    required void Function(String, tz.TZDateTime, Reminder) add,
    required tz.TZDateTime localNow,
    required DateTime today,
    required int daysBefore,
    required List<Holiday> holidays,
    required Profile? activeProfile,
    required List<LeaveRecord> activeLeaves,
  }) {
    final blocks = _holidayBlocks(holidays);
    final bridges = activeProfile == null
        ? const <DateTime, BridgeSuggestion>{}
        : _bestBridges(
            today: today,
            profile: activeProfile,
            leaves: activeLeaves,
            holidays: holidays,
            blocks: blocks,
          );

    for (final block in blocks) {
      final anchor = _day(block.anchor.date);
      final key = _dateKey(anchor);
      final bridge = bridges[anchor];
      if (bridge != null) {
        final fireDay = _addDays(_day(bridge.vacation.start), -daysBefore);
        final fireAt = _at(fireDay, morningHour);
        // A bridge reminder that is already late falls back to the holiday
        // reminder below.
        if (fireAt.isAfter(localNow)) {
          add(
            'bridge:$key',
            fireAt,
            BridgeReminder(
              holidayName: block.anchor.name,
              daysUntil: _daysBetween(fireDay, anchor),
              leaveDays: bridge.leaveDaysUsed,
              totalDaysOff: bridge.totalDaysOff,
            ),
          );
          continue;
        }
      }
      add(
        'holiday:$key',
        _at(_addDays(anchor, -daysBefore), morningHour),
        HolidayReminder(holidayName: block.anchor.name, daysUntil: daysBefore),
      );
    }
  }

  Map<DateTime, BridgeSuggestion> _bestBridges({
    required DateTime today,
    required Profile profile,
    required List<LeaveRecord> leaves,
    required List<Holiday> holidays,
    required List<_HolidayBlock> blocks,
  }) {
    final remaining = _balanceOn(profile, leaves, holidays, today).remaining;
    if (remaining <= 0) return const {};
    final calendar = _WorkCalendar(profile, leaves, holidays);
    final result = <DateTime, BridgeSuggestion>{};
    for (final year in [today.year, today.year + 1]) {
      final suggestions = bridgePlanner.suggestions(
        year: year,
        profile: profile,
        holidays: holidays,
        budget: remaining,
      );
      for (final suggestion in suggestions) {
        if (suggestion.leaveDaysUsed <= 0) continue;
        if (suggestion.leaveDays.map(_day).any(calendar.isAway)) continue;
        final start = _day(suggestion.vacation.start);
        final end = _day(suggestion.vacation.end);
        final block = blocks.where((b) {
          final anchor = _day(b.anchor.date);
          return !anchor.isBefore(start) && !anchor.isAfter(end);
        }).firstOrNull;
        if (block == null) continue;
        result.putIfAbsent(_day(block.anchor.date), () => suggestion);
      }
    }
    return result;
  }

  void _planAccrual({
    required void Function(String, tz.TZDateTime, Reminder) add,
    required DateTime today,
    required Profile profile,
  }) {
    // `nextAccrual` returns accruals after the given day. Asking from
    // yesterday keeps a reminder for an accrual later today.
    final accruals = {
      entitlementCalculator.nextAccrual(profile, _addDays(today, -1)),
      entitlementCalculator.nextAccrual(profile, today),
    };
    for (final accrual in accruals.nonNulls) {
      if (accrual.days <= 0) continue;
      final day = _day(accrual.date);
      add(
        'accrual:${profile.id}:${_dateKey(day)}',
        _at(day, morningHour),
        AccrualReminder(profileName: profile.name, days: accrual.days),
      );
    }
  }

  void _planLeaves({
    required void Function(String, tz.TZDateTime, Reminder) add,
    required int daysBefore,
    required Profile profile,
    required List<LeaveRecord> leaves,
    required List<Holiday> holidays,
  }) {
    final calendar = _WorkCalendar(profile, leaves, holidays);
    for (final leave in leaves) {
      if (!calendar.continuesAnotherLeave(leave)) {
        add(
          'leave-start:${leave.id}',
          _at(_addDays(_day(leave.range.start), -daysBefore), morningHour),
          LeaveStartReminder(profileName: profile.name, daysUntil: daysBefore),
        );
      }
      if (leave.unit != LeaveUnit.days) continue;
      final returnDay = calendar.returnDay(leave);
      if (returnDay == null) continue;
      // Keyed by the return day, so back-to-back leaves share one reminder.
      add(
        'leave-return:${profile.id}:${_dateKey(returnDay)}',
        _at(_addDays(returnDay, -1), eveningHour),
        LeaveReturnReminder(profileName: profile.name),
      );
    }
  }

  void _planYearEnd({
    required void Function(String, tz.TZDateTime, Reminder) add,
    required tz.TZDateTime localNow,
    required Profile profile,
    required List<LeaveRecord> leaves,
    required List<Holiday> holidays,
  }) {
    if (profile.isTeacher) return;
    // Fires on 1 December, a month before 657 leave is dropped.
    var year = localNow.year;
    var fireAt = _at(DateTime.utc(year, DateTime.december), morningHour);
    if (!fireAt.isAfter(localNow)) {
      year++;
      fireAt = _at(DateTime.utc(year, DateTime.december), morningHour);
    }
    // The balance on 31 December counts every leave of the year as used, so
    // the days match what is really left at year end.
    final balance = _balanceOn(
      profile,
      leaves,
      holidays,
      DateTime.utc(year, 12, 31),
    );
    final key = 'year-end:${profile.id}:$year';
    switch (profile.employmentType) {
      case EmploymentType.civilServant:
        if (balance.expiringAtYearEnd > 0) {
          add(
            key,
            fireAt,
            YearEndExpiringReminder(
              profileName: profile.name,
              days: balance.expiringAtYearEnd,
            ),
          );
        }
      case EmploymentType.laborLaw:
        if (balance.remaining > 0) {
          add(
            key,
            fireAt,
            YearEndUnusedReminder(
              profileName: profile.name,
              days: balance.remaining,
            ),
          );
        }
    }
  }

  LeaveBalance _balanceOn(
    Profile profile,
    List<LeaveRecord> leaves,
    List<Holiday> holidays,
    DateTime day,
  ) => balanceCalculator.balance(
    profile: profile,
    periods: entitlementCalculator.periods(profile, until: day),
    leaves: leaves,
    holidays: holidays,
    today: day,
  );

  List<ScheduledReminder> _finish(Map<String, _Candidate> candidates) {
    final nearest = candidates.entries.toList()
      ..sort((a, b) {
        final byTime = a.value.fireAt.compareTo(b.value.fireAt);
        return byTime != 0 ? byTime : a.key.compareTo(b.key);
      });
    final kept = nearest.take(math.max(0, maxReminders)).toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    // Ids come from the key. A rare hash collision moves to the next free
    // id, in key order, so the result does not depend on the input order.
    final usedIds = <int>{};
    final result = <ScheduledReminder>[];
    for (final MapEntry(:key, :value) in kept) {
      var id = stableNotificationId(key);
      while (!usedIds.add(id)) {
        id = id >= maxNotificationId ? 1 : id + 1;
      }
      result.add(
        ScheduledReminder(
          id: id,
          fireAt: value.fireAt,
          reminder: value.reminder,
        ),
      );
    }
    return result..sort((a, b) {
      final byTime = a.fireAt.compareTo(b.fireAt);
      return byTime != 0 ? byTime : a.id.compareTo(b.id);
    });
  }

  tz.TZDateTime _at(DateTime day, int hour) =>
      tz.TZDateTime(location, day.year, day.month, day.day, hour);
}

/// Consecutive official holiday days, eves included.
class _HolidayBlock {
  new(this.days)
    : anchor = days.where((d) => !d.halfDay).firstOrNull ?? days.first;

  final List<Holiday> days;

  /// First full day off, the day the reminder talks about.
  final Holiday anchor;
}

List<_HolidayBlock> _holidayBlocks(List<Holiday> holidays) {
  final sorted = [...holidays]..sort((a, b) => a.date.compareTo(b.date));
  final groups = <List<Holiday>>[];
  for (final holiday in sorted) {
    final previous = groups.lastOrNull?.last;
    if (previous != null &&
        _daysBetween(_day(previous.date), _day(holiday.date)) <= 1) {
      groups.last.add(holiday);
    } else {
      groups.add([holiday]);
    }
  }
  return [for (final group in groups) _HolidayBlock(group)];
}

/// Working days of one profile, used to find the return day.
class _WorkCalendar {
  new(Profile profile, this.leaves, List<Holiday> holidays)
    : _workDays = profile.workSchedule.workDays.toSet(),
      _holidays = {
        for (final holiday in holidays)
          if (!holiday.halfDay) _day(holiday.date),
      };

  final List<LeaveRecord> leaves;
  final Set<int> _workDays;
  final Set<DateTime> _holidays;

  bool isWorkday(DateTime day) =>
      _workDays.contains(day.weekday) && !_holidays.contains(day);

  /// Whether [day] is inside a whole-day leave other than [except].
  bool isAway(DateTime day, [LeaveRecord? except]) => leaves.any(
    (leave) =>
        leave.id != except?.id &&
        leave.unit == LeaveUnit.days &&
        !day.isBefore(_day(leave.range.start)) &&
        !day.isAfter(_day(leave.range.end)),
  );

  /// First working day after [leave] that is not inside another leave.
  DateTime? returnDay(LeaveRecord leave) {
    var day = _addDays(_day(leave.range.end), 1);
    for (var i = 0; i < ReminderPlanner._searchDays; i++) {
      if (isWorkday(day) && !isAway(day)) return day;
      day = _addDays(day, 1);
    }
    return null;
  }

  /// Whether [leave] follows another leave with no working day between, so
  /// the person is already away when it starts.
  bool continuesAnotherLeave(LeaveRecord leave) {
    var day = _addDays(_day(leave.range.start), -1);
    for (var i = 0; i < ReminderPlanner._searchDays; i++) {
      if (isAway(day, leave)) return true;
      if (isWorkday(day)) return false;
      day = _addDays(day, -1);
    }
    return false;
  }
}

DateTime _day(DateTime date) => DateTime.utc(date.year, date.month, date.day);

DateTime _addDays(DateTime day, int days) =>
    DateTime.utc(day.year, day.month, day.day + days);

int _daysBetween(DateTime from, DateTime to) => to.difference(from).inDays;

String _dateKey(DateTime day) =>
    '${day.year.toString().padLeft(4, '0')}-'
    '${day.month.toString().padLeft(2, '0')}-'
    '${day.day.toString().padLeft(2, '0')}';
