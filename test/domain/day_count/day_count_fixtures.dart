import 'dart:convert';
import 'dart:io';

import 'package:izin_planla/domain/models/models.dart';

/// Official holidays 2026-2028 read from the app asset, so the tests use the
/// same fixed dates as the app.
final List<Holiday> holidays = _loadHolidays();

List<Holiday> _loadHolidays() {
  final json = jsonDecode(
    File('assets/holidays/tr_2026_2028.json').readAsStringSync(),
  ) as Map<String, dynamic>;
  return [
    for (final item in json['holidays'] as List<dynamic>)
      Holiday.fromJson(item as Map<String, dynamic>),
  ];
}

/// A UTC date-only value.
DateTime day(int year, int month, int dayOfMonth) =>
    DateTime.utc(year, month, dayOfMonth);

/// An inclusive range from [start] to [end].
DateRange range(DateTime start, DateTime end) =>
    DateRange(start: start, end: end);

/// A Labour Law (4857) profile, Monday to Friday by default.
Profile laborLaw({
  WorkSchedule workSchedule = const WorkSchedule(),
  double leaveUsedBeforeTracking = 0,
  List<DateTime> administrativeLeaveDays = const [],
}) => Profile(
  id: 'worker',
  name: 'Worker',
  employmentType: EmploymentType.laborLaw,
  employmentStartDate: day(2020, 3, 1),
  birthDate: day(1990, 1, 1),
  workSchedule: workSchedule,
  leaveUsedBeforeTracking: leaveUsedBeforeTracking,
  administrativeLeaveDays: administrativeLeaveDays,
);

/// A civil servant (657) profile.
Profile civilServant({
  WorkSchedule workSchedule = const WorkSchedule(),
  double leaveUsedBeforeTracking = 0,
  List<DateTime> administrativeLeaveDays = const [],
}) => Profile(
  id: 'servant',
  name: 'Servant',
  employmentType: EmploymentType.civilServant,
  employmentStartDate: day(2015, 1, 1),
  birthDate: day(1985, 1, 1),
  workSchedule: workSchedule,
  leaveUsedBeforeTracking: leaveUsedBeforeTracking,
  administrativeLeaveDays: administrativeLeaveDays,
);

var _nextId = 0;

/// A whole-day leave record of [type] from [start] to [end].
LeaveRecord leave(
  DateTime start,
  DateTime end, {
  LeaveType type = LeaveType.annual,
  LeaveUnit unit = LeaveUnit.days,
  double? hours,
  bool deductsFromAnnual = false,
}) => LeaveRecord(
  id: 'leave-${_nextId++}',
  profileId: 'profile',
  type: type,
  range: range(start, end),
  unit: unit,
  hours: hours,
  deductsFromAnnual: deductsFromAnnual,
);
