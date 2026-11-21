import 'package:izin_planla/domain/bridge/bridge_day_kind.dart';
import 'package:izin_planla/domain/models/models.dart';

/// One profile's working days, holidays and administrative leave, as the
/// bridge planner sees them.
///
/// Days are day numbers, whole days since 1970-01-01 in UTC (see
/// [dayNumber]), so the planner walks the calendar with integers.
///
/// - Weekdays outside [WorkSchedule.workDays] and the weekly rest day are
///   free.
/// - A full-day holiday is free (2429, `docs/mevzuat.md` 3.1).
/// - An eve or 28 October on a working day is a half working day: the
///   afternoon is off, the morning needs leave (section 4).
/// - A civil servant's administrative leave day is free (section 3.4).
///   Labour Law profiles have no administrative leave.
///
/// The cost of leave is not decided here, the planner asks the
/// `LeaveDayCounter` for that.
final class BridgeCalendar {
  /// Creates the calendar of [profile] for [holidays].
  factory(Profile profile, List<Holiday> holidays) {
    final schedule = profile.workSchedule;
    final workWeekdays = <int>{
      for (final weekday in schedule.workDays)
        if (weekday != schedule.weeklyRestDay) weekday,
    };

    final holidayByDay = <int, Holiday>{};
    final namesByDay = <int, List<String>>{};
    for (final holiday in holidays) {
      final day = dayNumber(holiday.date);
      final existing = holidayByDay[day];
      // A full-day entry wins over a half-day entry on the same date.
      if (existing == null || (existing.halfDay && !holiday.halfDay)) {
        holidayByDay[day] = holiday;
      }
      final names = namesByDay.putIfAbsent(day, () => <String>[]);
      if (!names.contains(holiday.name)) names.add(holiday.name);
    }

    final administrative = profile.employmentType == EmploymentType.civilServant
        ? {for (final day in profile.administrativeLeaveDays) dayNumber(day)}
        : const <int>{};

    // Consecutive special days form one cluster, named by its first day.
    final special = {...holidayByDay.keys, ...administrative}.toList()..sort();
    final clusterByDay = <int, int>{};
    var clusterStart = 0;
    for (var i = 0; i < special.length; i++) {
      if (i == 0 || special[i - 1] != special[i] - 1) clusterStart = special[i];
      clusterByDay[special[i]] = clusterStart;
    }
    final timeOffDays = List<int>.unmodifiable([
      for (final day in special)
        if (workWeekdays.contains(weekdayOf(day))) day,
    ]);

    return BridgeCalendar._(
      workWeekdays: workWeekdays,
      holidayByDay: holidayByDay,
      namesByDay: namesByDay,
      administrative: administrative,
      clusterByDay: clusterByDay,
      timeOffDays: timeOffDays,
    );
  }

  const new _({
    required this._workWeekdays,
    required this._holidayByDay,
    required this._namesByDay,
    required this._administrative,
    required this._clusterByDay,
    required this._timeOffDays,
  });

  final Set<int> _workWeekdays;
  final Map<int, Holiday> _holidayByDay;
  final Map<int, List<String>> _namesByDay;
  final Set<int> _administrative;
  final Map<int, int> _clusterByDay;

  /// Sorted working days freed fully or partly by a holiday or by
  /// administrative leave.
  final List<int> _timeOffDays;

  /// Day number of [date]: whole days since 1970-01-01, time of day ignored.
  static int dayNumber(DateTime date) =>
      DateTime.utc(date.year, date.month, date.day).millisecondsSinceEpoch ~/
      Duration.millisecondsPerDay;

  /// UTC midnight of day number [day], the inverse of [dayNumber].
  static DateTime dateOf(int day) => DateTime.fromMillisecondsSinceEpoch(
    day * Duration.millisecondsPerDay,
    isUtc: true,
  );

  /// Weekday of day number [day], [DateTime.monday] to [DateTime.sunday].
  static int weekdayOf(int day) => (day + 3) % 7 + 1;

  /// Whether the profile works on at least one weekday.
  bool get hasWorkDays => _workWeekdays.isNotEmpty;

  /// How the planner treats day number [day].
  BridgeDayKind kindOf(int day) {
    if (!_workWeekdays.contains(weekdayOf(day))) return BridgeDayKind.free;
    if (_administrative.contains(day)) return BridgeDayKind.free;
    final holiday = _holidayByDay[day];
    if (holiday == null) return BridgeDayKind.workday;
    return holiday.halfDay ? BridgeDayKind.eve : BridgeDayKind.free;
  }

  /// First day of the break that starts with leave on [firstLeaveDay]: the
  /// free days right before it belong to the break.
  int breakStartFor(int firstLeaveDay) {
    var day = firstLeaveDay;
    while (kindOf(day - 1) == BridgeDayKind.free) {
      day--;
    }
    return day;
  }

  /// Last day of the break that ends with leave on [lastLeaveDay]: the free
  /// days right after it belong to the break.
  int breakEndFor(int lastLeaveDay) {
    var day = lastLeaveDay;
    while (kindOf(day + 1) == BridgeDayKind.free) {
      day++;
    }
    return day;
  }

  /// Whether a holiday or administrative leave frees all or part of a
  /// working day between [from] and [to], both included.
  ///
  /// A break without such a day is an ordinary weekend with leave, not a
  /// bridge.
  bool hasTimeOffIn(int from, int to) {
    final index = _firstTimeOffAtOrAfter(from);
    return index < _timeOffDays.length && _timeOffDays[index] <= to;
  }

  /// Clusters of consecutive holidays that free a working day between
  /// [from] and [to], each named by its first day number, in date order.
  ///
  /// Breaks with the same clusters cover the same holiday.
  List<int> clustersIn(int from, int to) {
    final clusters = <int>[];
    for (
      var index = _firstTimeOffAtOrAfter(from);
      index < _timeOffDays.length && _timeOffDays[index] <= to;
      index++
    ) {
      final cluster = _clusterByDay[_timeOffDays[index]];
      if (cluster != null && (clusters.isEmpty || clusters.last != cluster)) {
        clusters.add(cluster);
      }
    }
    return clusters;
  }

  /// Names of the holidays between [from] and [to], both included, in date
  /// order and without repeats.
  List<String> holidayNamesIn(int from, int to) {
    final names = <String>[];
    for (var day = from; day <= to; day++) {
      for (final name in _namesByDay[day] ?? const <String>[]) {
        if (!names.contains(name)) names.add(name);
      }
    }
    return names;
  }

  int _firstTimeOffAtOrAfter(int day) {
    var low = 0;
    var high = _timeOffDays.length;
    while (low < high) {
      final middle = (low + high) >> 1;
      if (_timeOffDays[middle] < day) {
        low = middle + 1;
      } else {
        high = middle;
      }
    }
    return low;
  }
}
