import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/services/export/leave_report_builder.dart';
import 'package:izin_planla/domain/models/models.dart';

import 'support/hostile_fixture.dart';
import 'support/report_factory.dart';
import 'support/stub_balance_calculator.dart';
import 'support/stub_entitlement_calculator.dart';
import 'support/stub_holiday_repository.dart';
import 'support/stub_leave_repository.dart';
import 'support/stub_profile_repository.dart';

void main() {
  final worker = Profile(
    id: 'p1',
    name: 'Ali',
    employmentType: EmploymentType.laborLaw,
    employmentStartDate: DateTime.utc(2020, 1, 15),
    birthDate: DateTime.utc(1990),
    leaveUsedBeforeTracking: 3.5,
  );

  LeaveRecord leave(
    String id,
    DateTime start,
    DateTime end, {
    LeaveType type = LeaveType.annual,
    LeaveUnit unit = LeaveUnit.days,
    double? hours,
    bool deductsFromAnnual = false,
    String profileId = 'p1',
  }) => LeaveRecord(
    id: id,
    profileId: profileId,
    type: type,
    range: DateRange(start: start, end: end),
    unit: unit,
    hours: hours,
    deductsFromAnnual: deductsFromAnnual,
  );

  test('returns null for an unknown profile', () async {
    final builder = LeaveReportBuilder(
      profiles: StubProfileRepository([]),
      leaves: StubLeaveRepository([]),
      holidays: const StubHolidayRepository(),
      entitlementCalculator: const StubEntitlementCalculator(),
      balanceCalculator: const StubBalanceCalculator(),
    );
    expect(await builder.build('yok', date: HostileFixture.date), isNull);
  });

  test('costs each record by how much it moves the balance', () async {
    final report = await buildReport(
      profile: worker,
      leaves: [
        // Friday to Tuesday: 3 weekdays.
        leave('b', DateTime.utc(2026, 3, 6), DateTime.utc(2026, 3, 10)),
        leave(
          'a',
          DateTime.utc(2026, 2, 2),
          DateTime.utc(2026, 2, 2),
          unit: LeaveUnit.halfDay,
        ),
        leave(
          'c',
          DateTime.utc(2026, 4),
          DateTime.utc(2026, 4),
          unit: LeaveUnit.hours,
          hours: 2,
        ),
        leave(
          'd',
          DateTime.utc(2026, 5, 4),
          DateTime.utc(2026, 5, 8),
          type: LeaveType.sick,
        ),
        leave(
          'e',
          DateTime.utc(2026, 6),
          DateTime.utc(2026, 6, 2),
          type: LeaveType.excuse,
          deductsFromAnnual: true,
        ),
        leave('f', DateTime.utc(2026, 12, 28), DateTime.utc(2026, 12, 31)),
        leave(
          'other-person',
          DateTime.utc(2026, 1, 5),
          DateTime.utc(2026, 1, 9),
          profileId: 'p2',
        ),
      ],
    );

    expect(report.entries.map((e) => e.record.id), [
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
    ]);
    expect(report.entries.map((e) => e.annualDays), [0.5, 3, 0.25, 0, 2, 4]);
    expect(report.entries.map((e) => e.planned), [
      false,
      false,
      false,
      false,
      false,
      true,
    ]);
    expect(report.balance.used, 3.5 + 0.5 + 3 + 0.25 + 2);
    expect(report.balance.planned, 4);
  });

  test('orders periods from oldest and passes the next accrual', () async {
    final next = NextAccrual(date: DateTime.utc(2027), days: 20);
    final report = await buildReport(
      profile: worker,
      periods: civilServantPeriods(),
      next: next,
    );
    expect(report.periods.map((p) => p.calendarYear), [2025, 2026]);
    expect(report.nextAccrual, next);
    expect(report.balance.earned, 40);
    expect(report.date, HostileFixture.date);
  });

  test('reduces the report date to its calendar day', () async {
    final report = await buildReport(
      profile: worker,
      date: DateTime(2026, 11, 21, 23, 59),
    );
    expect(report.date, DateTime.utc(2026, 11, 21));
  });

  test('sums absence days', () async {
    final report = await buildReport(profile: HostileFixture.profile());
    expect(report.absenceDays, 10);
  });

  group('serviceDuration', () {
    ServiceDuration service(
      DateTime start,
      DateTime date, {
      ServiceDuration prior = const ServiceDuration(),
    }) => LeaveReportBuilder.serviceDuration(
      worker.copyWith(employmentStartDate: start, priorService: prior),
      date,
    );

    test('counts whole years on the anniversary', () {
      expect(
        service(DateTime.utc(2020, 1, 15), DateTime.utc(2026, 1, 15)),
        const ServiceDuration(years: 6),
      );
      expect(
        service(DateTime.utc(2020, 1, 15), DateTime.utc(2026, 1, 14)),
        const ServiceDuration(years: 5, months: 11, days: 30),
      );
    });

    test('takes 28 February as the anniversary of 29 February', () {
      expect(
        service(DateTime.utc(2024, 2, 29), DateTime.utc(2025, 2, 28)),
        const ServiceDuration(years: 1),
      );
    });

    test('subtracts prior service with calendar arithmetic', () {
      // 31.03.2019 - 1 year 1 month = 28.02.2018, - 3 days = 25.02.2018.
      expect(
        service(
          DateTime.utc(2019, 3, 31),
          DateTime.utc(2026, 11, 21),
          prior: const ServiceDuration(years: 1, months: 1, days: 3),
        ),
        const ServiceDuration(years: 8, months: 8, days: 27),
      );
    });

    test('is zero before the start date', () {
      expect(
        service(DateTime.utc(2027), DateTime.utc(2026, 11, 21)),
        const ServiceDuration(),
      );
    });
  });
}
