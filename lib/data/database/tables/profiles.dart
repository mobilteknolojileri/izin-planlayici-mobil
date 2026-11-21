import 'package:drift/drift.dart';
import 'package:izin_planla/data/database/converters/date_range_list_converter.dart';
import 'package:izin_planla/data/database/converters/day_converter.dart';
import 'package:izin_planla/data/database/converters/day_list_converter.dart';
import 'package:izin_planla/data/database/converters/int_list_converter.dart';
import 'package:izin_planla/domain/models/models.dart';

/// One row per `Profile`, with its work schedule and prior service flattened
/// into columns.
///
/// List fields are JSON arrays because they are always read and written with
/// their profile. Enum and range rules are CHECK constraints, so a corrupt row
/// cannot be written even by a buggy caller.
@DataClassName('ProfileRow')
class Profiles extends Table {
  /// Stable id chosen by the app.
  TextColumn get id => text()();

  /// Display name.
  TextColumn get name => text()();

  /// Law that defines the leave rights, stored by enum name.
  TextColumn get employmentType => textEnum<EmploymentType>()();

  /// Hire date (4857) or start of duty (657).
  TextColumn get employmentStartDate => text().map(const DayConverter())();

  /// Birth date for the age rules of 4857, null for civil servants.
  TextColumn get birthDate => text().map(const DayConverter()).nullable()();

  /// Working weekdays, `WorkSchedule.workDays`.
  TextColumn get workDays => text().map(const IntListConverter())();

  /// Weekly rest day, `WorkSchedule.weeklyRestDay`.
  IntColumn get weeklyRestDay => integer()();

  /// `WorkSchedule.saturdayCountsAsLeave`.
  BoolColumn get saturdayCountsAsLeave => boolean()();

  /// `WorkSchedule.halfDayDeduction`, stored by enum name.
  TextColumn get halfDayDeduction => textEnum<HalfDayDeduction>()();

  /// `WorkSchedule.dailyWorkingHours`.
  RealColumn get dailyWorkingHours => real()();

  /// Years of `Profile.priorService`.
  IntColumn get priorServiceYears => integer()();

  /// Months of `Profile.priorService`.
  IntColumn get priorServiceMonths => integer()();

  /// Days of `Profile.priorService`.
  IntColumn get priorServiceDays => integer()();

  /// Whether the person works underground (4857 art. 53/4).
  BoolColumn get isUnderground => boolean()();

  /// Extra days granted by contract or union agreement.
  IntColumn get contractExtraDays => integer()();

  /// Annual leave days used before tracking started.
  RealColumn get leaveUsedBeforeTracking => real()();

  /// Whether the person is a teacher (657 art. 103/2).
  BoolColumn get isTeacher => boolean()();

  /// Administrative leave days of a civil servant.
  TextColumn get administrativeLeaveDays =>
      text().map(const DayListConverter())();

  /// Absences that shift accrual dates (4857 art. 54/2).
  TextColumn get absencePeriods => text().map(const DateRangeListConverter())();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  bool get isStrict => true;

  @override
  List<String> get customConstraints => [
    'CHECK (length(id) > 0)',
    "CHECK (employment_type IN ('laborLaw', 'civilServant'))",
    'CHECK (date(employment_start_date) IS employment_start_date)',
    'CHECK (date(birth_date) IS birth_date)',
    "CHECK (json_type(work_days) = 'array')",
    'CHECK (weekly_rest_day BETWEEN 1 AND 7)',
    "CHECK (half_day_deduction IN ('zero', 'half', 'full'))",
    'CHECK (daily_working_hours > 0)',
    'CHECK (prior_service_years >= 0)',
    'CHECK (prior_service_months >= 0)',
    'CHECK (prior_service_days >= 0)',
    'CHECK (contract_extra_days >= 0)',
    'CHECK (leave_used_before_tracking >= 0)',
    "CHECK (json_type(administrative_leave_days) = 'array')",
    "CHECK (json_type(absence_periods) = 'array')",
  ];
}
