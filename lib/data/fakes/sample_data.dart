import 'package:izin_planla/domain/models/models.dart';

/// Deterministic sample data for screens under development and tests.
abstract final class SampleData {
  /// Id of [profile].
  static const profileId = 'sample-profile';

  /// A worker under Labour Law 4857 hired in March 2019.
  static final profile = Profile(
    id: profileId,
    name: 'Örnek Kişi',
    employmentType: EmploymentType.laborLaw,
    employmentStartDate: DateTime.utc(2019, 3, 15),
    birthDate: DateTime.utc(1990, 6),
  );

  /// One used and one planned annual leave.
  static final leaves = [
    LeaveRecord(
      id: 'sample-leave-1',
      profileId: profileId,
      type: LeaveType.annual,
      range: DateRange(
        start: DateTime.utc(2026, 7, 6),
        end: DateTime.utc(2026, 7, 10),
      ),
    ),
    LeaveRecord(
      id: 'sample-leave-2',
      profileId: profileId,
      type: LeaveType.annual,
      range: DateRange(
        start: DateTime.utc(2026, 12, 28),
        end: DateTime.utc(2026, 12, 31),
      ),
    ),
  ];

  /// A few 2026 holidays. The real list comes from `assets/holidays/`.
  static final holidays = [
    Holiday(
      date: DateTime.utc(2026, 10, 28),
      name: 'Cumhuriyet Bayramı Arifesi',
      type: HolidayType.eve,
      halfDay: true,
    ),
    Holiday(
      date: DateTime.utc(2026, 10, 29),
      name: 'Cumhuriyet Bayramı',
      type: HolidayType.national,
      halfDay: false,
    ),
    Holiday(
      date: DateTime.utc(2027),
      name: 'Yılbaşı',
      type: HolidayType.national,
      halfDay: false,
    ),
  ];
}
