import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:izin_planla/domain/models/date_only_converter.dart';
import 'package:izin_planla/domain/models/date_range.dart';
import 'package:izin_planla/domain/models/employment_type.dart';
import 'package:izin_planla/domain/models/service_duration.dart';
import 'package:izin_planla/domain/models/work_schedule.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

/// A person whose leave is tracked. Fields cover `docs/kapsam.md` section 1.
@freezed
abstract class Profile with _$Profile {
  /// Creates a profile.
  const factory({
    required String id,
    required String name,
    required EmploymentType employmentType,

    /// Hire date (4857) or start of duty (657).
    @DateOnlyConverter() required DateTime employmentStartDate,

    /// Needed for the age rules of 4857 art. 53.
    @DateOnlyConverter() required DateTime birthDate,
    @Default(WorkSchedule()) WorkSchedule workSchedule,

    /// Prior service with the same employer (4857) or counted public
    /// service (657).
    @Default(ServiceDuration()) ServiceDuration priorService,

    /// Underground work adds days (4857 art. 53/4).
    @Default(false) bool isUnderground,

    /// Extra days granted above the law by contract or union agreement.
    @Default(0) int contractExtraDays,

    /// Annual leave days used before the app started tracking.
    @Default(0) double leaveUsedBeforeTracking,

    /// Teachers get no annual leave (657 art. 103/2).
    @Default(false) bool isTeacher,

    /// Administrative leave days marked by a civil servant (657).
    @DateOnlyConverter()
    @Default(<DateTime>[])
    List<DateTime> administrativeLeaveDays,

    /// Absences that shift accrual dates (4857 art. 54/2).
    @Default(<DateRange>[]) List<DateRange> absencePeriods,
  }) = _Profile;

  /// Creates a profile from JSON.
  factory fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
}
