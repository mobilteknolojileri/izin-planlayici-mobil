import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/domain/models/models.dart';

void main() {
  test('JSON round trip keeps every field', () {
    final profile = Profile(
      id: 'p1',
      name: 'Ayşe',
      employmentType: EmploymentType.civilServant,
      employmentStartDate: DateTime.utc(2015, 2, 28),
      birthDate: DateTime.utc(1988, 2, 29),
      workSchedule: const WorkSchedule(
        workDays: [1, 2, 3, 4, 5, 6],
        saturdayCountsAsLeave: false,
        halfDayDeduction: HalfDayDeduction.full,
        dailyWorkingHours: 7.5,
      ),
      priorService: const ServiceDuration(years: 2, months: 3, days: 4),
      isUnderground: true,
      contractExtraDays: 2,
      leaveUsedBeforeTracking: 3.5,
      isTeacher: true,
      administrativeLeaveDays: [DateTime.utc(2026, 3, 19)],
      absencePeriods: [
        DateRange(start: DateTime.utc(2020), end: DateTime.utc(2020, 1, 10)),
      ],
    );

    expect(Profile.fromJson(profile.toJson()), profile);
  });

  test('defaults match a Monday-Friday worker under 4857', () {
    final profile = Profile(
      id: 'p2',
      name: 'Ali',
      employmentType: EmploymentType.laborLaw,
      employmentStartDate: DateTime.utc(2020),
      birthDate: DateTime.utc(1995),
    );

    expect(profile.workSchedule.workDays, [1, 2, 3, 4, 5]);
    expect(profile.workSchedule.weeklyRestDay, DateTime.sunday);
    expect(profile.workSchedule.saturdayCountsAsLeave, isTrue);
    expect(profile.workSchedule.halfDayDeduction, HalfDayDeduction.half);
    expect(profile.administrativeLeaveDays, isEmpty);
  });
}
