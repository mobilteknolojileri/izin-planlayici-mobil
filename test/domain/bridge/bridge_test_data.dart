import 'dart:convert';
import 'dart:io';

import 'package:izin_planla/domain/models/models.dart';

// Shared inputs for the bridge planner tests.

/// UTC midnight of a calendar day.
DateTime day(int year, int month, int dayOfMonth) =>
    DateTime.utc(year, month, dayOfMonth);

/// The bundled 2026-2028 holidays from `assets/holidays/`.
List<Holiday> bundledHolidays() {
  final json = jsonDecode(
    File('assets/holidays/tr_2026_2028.json').readAsStringSync(),
  ) as Map<String, dynamic>;
  return [
    for (final item in json['holidays'] as List<dynamic>)
      Holiday.fromJson(item as Map<String, dynamic>),
  ];
}

/// A Labour Law (4857) profile with [schedule].
Profile laborProfile({WorkSchedule schedule = const WorkSchedule()}) => Profile(
  id: 'worker',
  name: 'Worker',
  employmentType: EmploymentType.laborLaw,
  employmentStartDate: day(2015, 1, 5),
  birthDate: day(1990, 6, 1),
  workSchedule: schedule,
);

/// A civil servant (657) profile.
Profile civilServantProfile({
  WorkSchedule schedule = const WorkSchedule(),
  List<DateTime> administrativeLeaveDays = const [],
  bool isTeacher = false,
}) => Profile(
  id: 'officer',
  name: 'Officer',
  employmentType: EmploymentType.civilServant,
  employmentStartDate: day(2015, 1, 5),
  birthDate: day(1990, 6, 1),
  workSchedule: schedule,
  administrativeLeaveDays: administrativeLeaveDays,
  isTeacher: isTeacher,
);
