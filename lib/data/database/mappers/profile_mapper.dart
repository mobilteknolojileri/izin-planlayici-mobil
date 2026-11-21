import 'package:izin_planla/data/database/app_database.dart';
import 'package:izin_planla/domain/models/models.dart';

/// Converts between [Profile] and its [ProfileRow], so drift rows never leave
/// the data layer.
abstract final class ProfileMapper {
  /// The domain model stored in [row].
  static Profile toModel(ProfileRow row) => Profile(
    id: row.id,
    name: row.name,
    employmentType: row.employmentType,
    employmentStartDate: row.employmentStartDate,
    birthDate: row.birthDate,
    workSchedule: WorkSchedule(
      workDays: row.workDays,
      weeklyRestDay: row.weeklyRestDay,
      saturdayCountsAsLeave: row.saturdayCountsAsLeave,
      halfDayDeduction: row.halfDayDeduction,
      dailyWorkingHours: row.dailyWorkingHours,
    ),
    priorService: ServiceDuration(
      years: row.priorServiceYears,
      months: row.priorServiceMonths,
      days: row.priorServiceDays,
    ),
    isUnderground: row.isUnderground,
    contractExtraDays: row.contractExtraDays,
    leaveUsedBeforeTracking: row.leaveUsedBeforeTracking,
    isTeacher: row.isTeacher,
    administrativeLeaveDays: row.administrativeLeaveDays,
    absencePeriods: row.absencePeriods,
  );

  /// The row that stores [profile].
  static ProfileRow toRow(Profile profile) => ProfileRow(
    id: profile.id,
    name: profile.name,
    employmentType: profile.employmentType,
    employmentStartDate: profile.employmentStartDate,
    birthDate: profile.birthDate,
    workDays: profile.workSchedule.workDays,
    weeklyRestDay: profile.workSchedule.weeklyRestDay,
    saturdayCountsAsLeave: profile.workSchedule.saturdayCountsAsLeave,
    halfDayDeduction: profile.workSchedule.halfDayDeduction,
    dailyWorkingHours: profile.workSchedule.dailyWorkingHours,
    priorServiceYears: profile.priorService.years,
    priorServiceMonths: profile.priorService.months,
    priorServiceDays: profile.priorService.days,
    isUnderground: profile.isUnderground,
    contractExtraDays: profile.contractExtraDays,
    leaveUsedBeforeTracking: profile.leaveUsedBeforeTracking,
    isTeacher: profile.isTeacher,
    administrativeLeaveDays: profile.administrativeLeaveDays,
    absencePeriods: profile.absencePeriods,
  );
}
