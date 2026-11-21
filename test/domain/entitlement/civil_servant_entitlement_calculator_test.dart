import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/domain/entitlement/civil_servant_entitlement_calculator.dart';
import 'package:izin_planla/domain/entitlement/entitlement_rule.dart';
import 'package:izin_planla/domain/models/models.dart';

// Fixed vectors from `docs/mevzuat.md` section 2 (657), including the
// examples of the ÇŞB-2025 opinion. Section numbers in the group names point
// to that file.

const _calculator = CivilServantEntitlementCalculator();

Profile _civilServant({
  required DateTime start,
  ServiceDuration priorService = const ServiceDuration(),
  bool isTeacher = false,
  DateTime? birth,
  bool isUnderground = false,
  int contractExtraDays = 0,
  List<DateRange> absences = const [],
}) => Profile(
  id: 'c1',
  name: 'Civil servant',
  employmentType: EmploymentType.civilServant,
  employmentStartDate: start,
  birthDate: birth ?? DateTime.utc(1990, 6, 15),
  priorService: priorService,
  isTeacher: isTeacher,
  isUnderground: isUnderground,
  contractExtraDays: contractExtraDays,
  absencePeriods: absences,
);

/// Accrual date, calendar year and days of each period.
List<(DateTime, int?, int)> _summary(List<EntitlementPeriod> periods) => [
  for (final period in periods)
    (period.accrualDate, period.calendarYear, period.days),
];

List<String> _codes(EntitlementPeriod period) => [
  for (final rule in period.rules) rule.code,
];

AppliedRule? _rule(EntitlementPeriod period, EntitlementRule rule) =>
    period.rules.where((applied) => applied.code == rule.code).firstOrNull;

void main() {
  group('first right and calendar year (2.2)', () {
    test('ÇŞB-2025: start 31.12.2021 earns 2022 and 2023, not 2021', () {
      final periods = _calculator.periods(
        _civilServant(start: DateTime.utc(2021, 12, 31)),
        until: DateTime.utc(2023, 6, 30),
      );

      expect(_summary(periods), [
        (DateTime.utc(2022, 12, 31), 2022, 20),
        (DateTime.utc(2023), 2023, 20),
      ]);
      expect(_rule(periods.first, EntitlementRule.civilFirstRight)?.params, {
        'serviceStart': '2021-12-31',
        'firstRightDate': '2022-12-31',
        'calendarYear': '2022',
      });
      expect(_rule(periods.last, EntitlementRule.civilCalendarYear)?.params, {
        'calendarYear': '2023',
      });
    });

    test('ÇŞB-2025: start 16.11.2020 earns on 16.11.2021', () {
      final profile = _civilServant(start: DateTime.utc(2020, 11, 16));

      expect(
        _calculator.periods(profile, until: DateTime.utc(2021, 11, 15)),
        isEmpty,
      );
      expect(
        _summary(
          _calculator.periods(profile, until: DateTime.utc(2021, 11, 16)),
        ),
        [(DateTime.utc(2021, 11, 16), 2021, 20)],
      );
    });

    test('a 29 February start earns on 28 February', () {
      final periods = _calculator.periods(
        _civilServant(start: DateTime.utc(2020, 2, 29)),
        until: DateTime.utc(2021, 12, 31),
      );

      expect(periods.single.accrualDate, DateTime.utc(2021, 2, 28));
    });
  });

  group('counted prior service (2.1)', () {
    final dutyStart = DateTime.utc(2024, 4, 15);

    test('over one year: the first right comes on the start of duty', () {
      final periods = _calculator.periods(
        _civilServant(
          start: dutyStart,
          priorService: const ServiceDuration(years: 3),
        ),
        until: DateTime.utc(2025),
      );

      expect(_summary(periods), [
        (dutyStart, 2024, 20),
        (DateTime.utc(2025), 2025, 20),
      ]);
      expect(
        _rule(
          periods.first,
          EntitlementRule.civilFirstRightOnDutyStart,
        )?.params,
        {'firstRightDate': '2024-04-15', 'calendarYear': '2024'},
      );
      expect(_rule(periods.first, EntitlementRule.civilPriorService)?.params, {
        'years': '3',
        'months': '0',
        'days': '0',
        'serviceStart': '2021-04-15',
      });
    });

    test('exactly one year: the first right comes on the start of duty', () {
      final periods = _calculator.periods(
        _civilServant(
          start: dutyStart,
          priorService: const ServiceDuration(years: 1),
        ),
        until: DateTime.utc(2024, 12, 31),
      );

      expect(_summary(periods), [(dutyStart, 2024, 20)]);
    });

    test('under one year: the first right comes when one year is full', () {
      final periods = _calculator.periods(
        _civilServant(
          start: dutyStart,
          priorService: const ServiceDuration(months: 6),
        ),
        until: DateTime.utc(2024, 12, 31),
      );

      expect(_summary(periods), [(DateTime.utc(2024, 10, 15), 2024, 20)]);
    });

    test('10 years or more of prior service gives 30 from the start', () {
      final periods = _calculator.periods(
        _civilServant(
          start: dutyStart,
          priorService: const ServiceDuration(years: 12),
        ),
        until: DateTime.utc(2025, 12, 31),
      );

      expect(_summary(periods), [
        (dutyStart, 2024, 30),
        (DateTime.utc(2025), 2025, 30),
      ]);
    });

    test('no prior service adds no prior service rule', () {
      final periods = _calculator.periods(
        _civilServant(start: DateTime.utc(2020, 11, 16)),
        until: DateTime.utc(2021, 11, 16),
      );

      expect(_rule(periods.single, EntitlementRule.civilPriorService), isNull);
    });
  });

  group('ten-year transition (2.3)', () {
    test('ÇŞB-2025: start 30.12.2010 earns 10 more days on 30.12.2020', () {
      final periods = _calculator.periods(
        _civilServant(start: DateTime.utc(2010, 12, 30)),
        until: DateTime.utc(2021),
      );

      expect(_summary(periods), [
        (DateTime.utc(2011, 12, 30), 2011, 20),
        for (var year = 2012; year <= 2020; year++)
          (DateTime.utc(year), year, 20),
        (DateTime.utc(2020, 12, 30), 2020, 10),
        (DateTime.utc(2021), 2021, 30),
      ]);

      final lastUpToTen = periods[periods.length - 3];
      final transition = periods[periods.length - 2];
      final firstOverTen = periods.last;
      expect(_rule(lastUpToTen, EntitlementRule.civilUpToTenYears)?.params, {
        'serviceYears': '9',
        'days': '20',
      });
      expect(
        _rule(transition, EntitlementRule.civilTenYearTransition)?.params,
        {'transitionDate': '2020-12-30', 'calendarYear': '2020', 'days': '10'},
      );
      expect(_rule(firstOverTen, EntitlementRule.civilOverTenYears)?.params, {
        'serviceYears': '10',
        'days': '30',
      });
    });

    test('a 10th anniversary on 1 January gives 30 with no extra', () {
      final periods = _calculator.periods(
        _civilServant(start: DateTime.utc(2011)),
        until: DateTime.utc(2021, 12, 31),
      );

      expect(periods, hasLength(10));
      expect(_summary(periods).first, (DateTime.utc(2012), 2012, 20));
      expect(_summary(periods)[8], (DateTime.utc(2020), 2020, 20));
      expect(_summary(periods).last, (DateTime.utc(2021), 2021, 30));
      for (final period in periods) {
        expect(_rule(period, EntitlementRule.civilTenYearTransition), isNull);
      }
    });

    test('a 10th anniversary on 2 January adds 10 days that day', () {
      final periods = _calculator.periods(
        _civilServant(start: DateTime.utc(2011, 1, 2)),
        until: DateTime.utc(2022),
      );

      expect(_summary(periods).sublist(periods.length - 3), [
        (DateTime.utc(2021), 2021, 20),
        (DateTime.utc(2021, 1, 2), 2021, 10),
        (DateTime.utc(2022), 2022, 30),
      ]);
    });

    test('prior service can bring the transition into the first year', () {
      final periods = _calculator.periods(
        _civilServant(
          start: DateTime.utc(2020, 3),
          priorService: const ServiceDuration(years: 9, months: 6),
        ),
        until: DateTime.utc(2021),
      );

      // Service start 2010-09-01, 10th anniversary 2020-09-01.
      expect(_summary(periods), [
        (DateTime.utc(2020, 3), 2020, 20),
        (DateTime.utc(2020, 9), 2020, 10),
        (DateTime.utc(2021), 2021, 30),
      ]);
    });

    test('a 29 February service start passes 10 years on 28 February', () {
      final periods = _calculator.periods(
        _civilServant(start: DateTime.utc(2020, 2, 29)),
        until: DateTime.utc(2030, 12, 31),
      );

      expect(_summary(periods).last, (DateTime.utc(2030, 2, 28), 2030, 10));
    });
  });

  group('carry-over and expiry (2.4)', () {
    test('a year is dropped on 1 January two years later', () {
      final periods = _calculator.periods(
        _civilServant(start: DateTime.utc(2021, 12, 31)),
        until: DateTime.utc(2023, 6, 30),
      );

      expect(periods.first.expiresOn, DateTime.utc(2024));
      expect(periods.last.expiresOn, DateTime.utc(2025));
      expect(_rule(periods.first, EntitlementRule.civilCarryOver)?.params, {
        'calendarYear': '2022',
        'expiresOn': '2024-01-01',
      });
    });

    test('the transition days expire with their calendar year', () {
      final periods = _calculator.periods(
        _civilServant(start: DateTime.utc(2010, 12, 30)),
        until: DateTime.utc(2020, 12, 30),
      );

      expect(periods.last.days, 10);
      expect(periods.last.expiresOn, DateTime.utc(2022));
    });
  });

  group('teachers (2.2)', () {
    test('earn no annual leave', () {
      final teacher = _civilServant(
        start: DateTime.utc(2015, 9),
        isTeacher: true,
      );

      expect(
        _calculator.periods(teacher, until: DateTime.utc(2026, 11, 21)),
        isEmpty,
      );
      expect(
        _calculator.nextAccrual(teacher, DateTime.utc(2026, 11, 21)),
        isNull,
      );
    });
  });

  group('4857 fields', () {
    test('age, underground, contract days and absences are ignored', () {
      final periods = _calculator.periods(
        _civilServant(
          start: DateTime.utc(2020, 11, 16),
          birth: DateTime.utc(1960),
          isUnderground: true,
          contractExtraDays: 5,
          absences: [
            DateRange(start: DateTime.utc(2021), end: DateTime.utc(2021, 3)),
          ],
        ),
        until: DateTime.utc(2021, 11, 16),
      );

      expect(_summary(periods), [(DateTime.utc(2021, 11, 16), 2021, 20)]);
    });
  });

  group('next accrual', () {
    final profile = _civilServant(start: DateTime.utc(2021, 12, 31));

    test('gives the date, the days and a countdown', () {
      final today = DateTime.utc(2022, 6);
      final next = _calculator.nextAccrual(profile, today);

      expect(next, NextAccrual(date: DateTime.utc(2022, 12, 31), days: 20));
      expect(next!.date.difference(today).inDays, 213);
    });

    test('after the first right the next one is on 1 January', () {
      expect(
        _calculator.nextAccrual(profile, DateTime.utc(2022, 12, 31)),
        NextAccrual(date: DateTime.utc(2023), days: 20),
      );
    });

    test('the ten-year difference is the next accrual in that year', () {
      final senior = _civilServant(start: DateTime.utc(2010, 12, 30));

      expect(
        _calculator.nextAccrual(senior, DateTime.utc(2020, 6)),
        NextAccrual(date: DateTime.utc(2020, 12, 30), days: 10),
      );
      expect(
        _calculator.nextAccrual(senior, DateTime.utc(2020, 12, 30)),
        NextAccrual(date: DateTime.utc(2021), days: 30),
      );
    });

    test('a future start gives the first right', () {
      expect(
        _calculator.nextAccrual(
          _civilServant(start: DateTime.utc(2027)),
          DateTime.utc(2026, 11, 21),
        ),
        NextAccrual(date: DateTime.utc(2028), days: 20),
      );
    });
  });

  group('applied rules', () {
    test('keep a fixed order and cite 657', () {
      final periods = _calculator.periods(
        _civilServant(
          start: DateTime.utc(2020, 3),
          priorService: const ServiceDuration(years: 9, months: 6),
        ),
        until: DateTime.utc(2021),
      );

      expect(_codes(periods[0]), [
        'civilFirstRightOnDutyStart',
        'civilPriorService',
        'civilUpToTenYears',
        'civilCarryOver',
      ]);
      expect(_codes(periods[1]), [
        'civilTenYearTransition',
        'civilPriorService',
        'civilCarryOver',
      ]);
      expect(_codes(periods[2]), [
        'civilCalendarYear',
        'civilPriorService',
        'civilOverTenYears',
        'civilCarryOver',
      ]);
      for (final rule in periods.expand((period) => period.rules)) {
        expect(rule.legalReference, startsWith('657 md. '));
      }
    });
  });
}
