import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/domain/entitlement/entitlement_rule.dart';
import 'package:izin_planla/domain/entitlement/labor_law_entitlement_calculator.dart';
import 'package:izin_planla/domain/models/models.dart';

// Fixed vectors from `docs/mevzuat.md` section 1 (4857). Section numbers in
// the group names point to that file.

const _calculator = LaborLawEntitlementCalculator();

Profile _worker({
  required DateTime start,
  DateTime? birth,
  ServiceDuration priorService = const ServiceDuration(),
  bool isUnderground = false,
  int contractExtraDays = 0,
  List<DateRange> absences = const [],
  bool isTeacher = false,
}) => Profile(
  id: 'w1',
  name: 'Worker',
  employmentType: EmploymentType.laborLaw,
  employmentStartDate: start,
  // Aged 25 to 45 in the tested years, so no age minimum applies.
  birthDate: birth ?? DateTime.utc(1995, 6, 15),
  priorService: priorService,
  isUnderground: isUnderground,
  contractExtraDays: contractExtraDays,
  absencePeriods: absences,
  isTeacher: isTeacher,
);

List<DateTime> _dates(List<EntitlementPeriod> periods) => [
  for (final period in periods) period.accrualDate,
];

List<int> _days(List<EntitlementPeriod> periods) => [
  for (final period in periods) period.days,
];

List<String> _codes(EntitlementPeriod period) => [
  for (final rule in period.rules) rule.code,
];

AppliedRule? _rule(EntitlementPeriod period, EntitlementRule rule) =>
    period.rules.where((applied) => applied.code == rule.code).firstOrNull;

/// The single period earned on [accrual] by [profile].
EntitlementPeriod _periodOn(Profile profile, DateTime accrual) =>
    _calculator.periods(profile, until: accrual).last;

void main() {
  group('accrual dates (1.1)', () {
    final profile = _worker(start: DateTime.utc(2025, 3, 10));

    test('no right before one full year', () {
      expect(
        _calculator.periods(profile, until: DateTime.utc(2026, 3, 9)),
        isEmpty,
      );
    });

    test('the right is earned on the anniversary day', () {
      final periods = _calculator.periods(
        profile,
        until: DateTime.utc(2026, 3, 10),
      );

      expect(_dates(periods), [DateTime.utc(2026, 3, 10)]);
      expect(_days(periods), [14]);
    });

    test('lists every anniversary up to and including the given day', () {
      final periods = _calculator.periods(
        _worker(start: DateTime.utc(2020, 3, 10)),
        until: DateTime.utc(2026, 11, 21),
      );

      expect(_dates(periods), [
        for (var year = 2021; year <= 2026; year++) DateTime.utc(year, 3, 10),
      ]);
      expect(_days(periods), [14, 14, 14, 14, 14, 20]);
    });

    test('a 29 February hire earns on 28 February in non-leap years', () {
      final periods = _calculator.periods(
        _worker(start: DateTime.utc(2020, 2, 29)),
        until: DateTime.utc(2024, 12, 31),
      );

      expect(_dates(periods), [
        DateTime.utc(2021, 2, 28),
        DateTime.utc(2022, 2, 28),
        DateTime.utc(2023, 2, 28),
        DateTime.utc(2024, 2, 29),
      ]);
    });

    test('time of day is ignored', () {
      final periods = _calculator.periods(
        _worker(start: DateTime(2020, 3, 10, 15)),
        until: DateTime(2021, 3, 10, 1),
      );

      expect(_dates(periods), [DateTime.utc(2021, 3, 10)]);
    });

    test('a future hire has no periods yet', () {
      final future = _worker(start: DateTime.utc(2027));

      expect(
        _calculator.periods(future, until: DateTime.utc(2026, 11, 21)),
        isEmpty,
      );
      expect(
        _calculator.nextAccrual(future, DateTime.utc(2026, 11, 21)),
        NextAccrual(date: DateTime.utc(2028), days: 14),
      );
    });
  });

  group('seniority (1.3)', () {
    // Aged 21 to 40 over the first 20 anniversaries.
    final profile = _worker(
      start: DateTime.utc(2001, 4, 2),
      birth: DateTime.utc(1980, 6, 15),
    );

    test('14 days up to 5 years, 20 up to 14, 26 from 15', () {
      final periods = _calculator.periods(
        profile,
        until: DateTime.utc(2021, 4, 2),
      );

      expect(_days(periods), [
        ...List.filled(5, 14),
        ...List.filled(9, 20),
        ...List.filled(6, 26),
      ]);
    });

    test('the 5th anniversary gives 14 days, 5 years included', () {
      final fifth = _periodOn(profile, DateTime.utc(2006, 4, 2));

      expect(fifth.days, 14);
      expect(_rule(fifth, EntitlementRule.laborSeniorityUpToFive)?.params, {
        'serviceYears': '5',
        'days': '14',
      });
    });

    test('20 days first come on the 6th anniversary', () {
      final sixth = _periodOn(profile, DateTime.utc(2007, 4, 2));

      expect(sixth.days, 20);
      expect(
        _rule(sixth, EntitlementRule.laborSeniorityFiveToFifteen)?.params,
        {'serviceYears': '6', 'days': '20'},
      );
    });

    test('the 14th anniversary still gives 20 days', () {
      expect(_periodOn(profile, DateTime.utc(2015, 4, 2)).days, 20);
    });

    test('26 days first come on the 15th anniversary, 15 years included', () {
      final fifteenth = _periodOn(profile, DateTime.utc(2016, 4, 2));

      expect(fifteenth.days, 26);
      expect(
        _rule(fifteenth, EntitlementRule.laborSeniorityFifteenOrMore)?.params,
        {'serviceYears': '15', 'days': '26'},
      );
    });

    test('one day before the 5th anniversary the next right is 14', () {
      expect(
        _calculator.periods(profile, until: DateTime.utc(2006, 4)),
        hasLength(4),
      );
      expect(
        _calculator.nextAccrual(profile, DateTime.utc(2006, 4)),
        NextAccrual(date: DateTime.utc(2006, 4, 2), days: 14),
      );
    });

    test('on the 5th anniversary the next right is the 6th with 20', () {
      expect(
        _calculator.nextAccrual(profile, DateTime.utc(2006, 4, 2)),
        NextAccrual(date: DateTime.utc(2007, 4, 2), days: 20),
      );
    });

    test('one day before the 15th anniversary the next right is 26', () {
      expect(
        _calculator.nextAccrual(profile, DateTime.utc(2016, 4)),
        NextAccrual(date: DateTime.utc(2016, 4, 2), days: 26),
      );
    });
  });

  group('age minimum (1.4)', () {
    // The only right of the first year, by default on 2025-05-20.
    EntitlementPeriod firstRight(DateTime birth, {DateTime? start}) {
      final hire = start ?? DateTime.utc(2024, 5, 20);
      return _calculator
          .periods(
            _worker(start: hire, birth: birth),
            until: DateTime.utc(hire.year + 1, hire.month, hire.day),
          )
          .single;
    }

    test('aged 18 on the accrual date gets 20 days', () {
      final period = firstRight(DateTime.utc(2007, 5, 20));

      expect(period.days, 20);
      expect(_rule(period, EntitlementRule.laborAgeEighteenOrYounger)?.params, {
        'age': '18',
        'days': '20',
      });
    });

    test('without a birth date no age minimum applies', () {
      final hire = DateTime.utc(2024, 5, 20);
      final period = _calculator
          .periods(
            _worker(start: hire).copyWith(birthDate: null),
            until: DateTime.utc(2025, 5, 20),
          )
          .single;

      expect(period.days, 14);
      expect(_rule(period, EntitlementRule.laborAgeEighteenOrYounger), isNull);
      expect(_rule(period, EntitlementRule.laborAgeFiftyOrOlder), isNull);
    });

    test('turning 19 one day after the accrual date still gets 20', () {
      expect(firstRight(DateTime.utc(2006, 5, 21)).days, 20);
    });

    test('turning 19 on the accrual date gets 14', () {
      final period = firstRight(DateTime.utc(2006, 5, 20));

      expect(period.days, 14);
      expect(_rule(period, EntitlementRule.laborAgeEighteenOrYounger), isNull);
    });

    test('a 50th birthday on the accrual date gives 20 days', () {
      final period = firstRight(DateTime.utc(1975, 5, 20));

      expect(period.days, 20);
      expect(_rule(period, EntitlementRule.laborAgeFiftyOrOlder)?.params, {
        'age': '50',
        'days': '20',
      });
    });

    test('a 50th birthday one day after the accrual date gives 14', () {
      final period = firstRight(DateTime.utc(1975, 5, 21));

      expect(period.days, 14);
      expect(_rule(period, EntitlementRule.laborAgeFiftyOrOlder), isNull);
    });

    test('born 29 February: 50 on 28 February of a non-leap year', () {
      final birth = DateTime.utc(1976, 2, 29);

      // Accrual 2026-02-28 is the 50th birthday.
      expect(firstRight(birth, start: DateTime.utc(2025, 2, 28)).days, 20);
      // Accrual 2026-02-27 is still 49.
      expect(firstRight(birth, start: DateTime.utc(2025, 2, 27)).days, 14);
    });

    test('born 29 February: 19 on 28 February of a non-leap year', () {
      final birth = DateTime.utc(2004, 2, 29);

      // Accrual 2023-02-28 is the 19th birthday.
      expect(firstRight(birth, start: DateTime.utc(2022, 2, 28)).days, 14);
      // Accrual 2023-02-27 is still 18.
      expect(firstRight(birth, start: DateTime.utc(2022, 2, 27)).days, 20);
    });

    test('age is checked again on every accrual date', () {
      final periods = _calculator.periods(
        _worker(start: DateTime.utc(2022, 3), birth: DateTime.utc(1975, 8)),
        until: DateTime.utc(2026, 3),
      );

      // Ages 47, 48, 49 and 50.
      expect(_days(periods), [14, 14, 14, 20]);
    });

    test('the minimum never lowers the seniority days', () {
      final profile = _worker(
        start: DateTime.utc(2000, 1, 10),
        birth: DateTime.utc(1960),
      );
      final tenth = _periodOn(profile, DateTime.utc(2010, 1, 10));
      final fifteenth = _periodOn(profile, DateTime.utc(2015, 1, 10));

      expect(tenth.days, 20);
      expect(fifteenth.days, 26);
      expect(_rule(fifteenth, EntitlementRule.laborAgeFiftyOrOlder), isNull);
    });
  });

  group('underground work (1.5)', () {
    test('adds 4 days to every seniority level', () {
      final periods = _calculator.periods(
        _worker(
          start: DateTime.utc(2001, 4, 2),
          birth: DateTime.utc(1980, 6, 15),
          isUnderground: true,
        ),
        until: DateTime.utc(2016, 4, 2),
      );

      expect(periods[0].days, 18);
      expect(periods[4].days, 18);
      expect(periods[5].days, 24);
      expect(periods[13].days, 24);
      expect(periods[14].days, 30);
      expect(_rule(periods[0], EntitlementRule.laborUnderground)?.params, {
        'extraDays': '4',
      });
    });

    test('mevzuat example: aged 50 with 3 years underground gets 24', () {
      final period = _periodOn(
        _worker(
          start: DateTime.utc(2020, 3, 10),
          birth: DateTime.utc(1973, 1, 15),
          isUnderground: true,
        ),
        DateTime.utc(2023, 3, 10),
      );

      expect(period.days, 24);
      expect(_codes(period), [
        'laborAnniversary',
        'laborContinuousService',
        'laborSeniorityUpToFive',
        'laborAgeFiftyOrOlder',
        'laborUnderground',
        'laborNoExpiry',
      ]);
    });
  });

  group('prior service with the same employer (1.6)', () {
    final profile = _worker(
      start: DateTime.utc(2022, 5),
      priorService: const ServiceDuration(years: 4, months: 6),
    );

    test('moves the start back and skips anniversaries before hire', () {
      final periods = _calculator.periods(
        profile,
        until: DateTime.utc(2023, 12, 31),
      );

      // Service start 2017-11-01: the 4th anniversary (2021-11-01) belongs
      // to the earlier employment.
      expect(_dates(periods), [DateTime.utc(2022, 11), DateTime.utc(2023, 11)]);
      expect(_days(periods), [14, 20]);
      expect(_rule(periods.first, EntitlementRule.laborAnniversary)?.params, {
        'serviceYears': '5',
      });
      expect(_rule(periods.first, EntitlementRule.laborPriorService)?.params, {
        'years': '4',
        'months': '6',
        'days': '0',
        'serviceStart': '2017-11-01',
      });
    });

    test('exactly one year of prior service earns on the hire date', () {
      final periods = _calculator.periods(
        _worker(
          start: DateTime.utc(2023, 3),
          priorService: const ServiceDuration(years: 1),
        ),
        until: DateTime.utc(2023, 3),
      );

      expect(_dates(periods), [DateTime.utc(2023, 3)]);
      expect(_days(periods), [14]);
    });

    test('prior service can reach the 15-year level', () {
      final long = _worker(
        start: DateTime.utc(2024, 1, 15),
        priorService: const ServiceDuration(years: 14, days: 10),
      );

      // Service start 2010-01-05.
      expect(
        _calculator.periods(long, until: DateTime.utc(2024, 12, 31)),
        isEmpty,
      );
      expect(
        _calculator.nextAccrual(long, DateTime.utc(2024, 6)),
        NextAccrual(date: DateTime.utc(2025, 1, 5), days: 26),
      );
    });

    test('no prior service adds no prior service rule', () {
      final period = _periodOn(
        _worker(start: DateTime.utc(2020, 3, 10)),
        DateTime.utc(2021, 3, 10),
      );

      expect(_rule(period, EntitlementRule.laborPriorService), isNull);
    });
  });

  group('absences (1.2)', () {
    final start = DateTime.utc(2020);

    test('no absence entered states the continuous work assumption', () {
      final period = _periodOn(_worker(start: start), DateTime.utc(2021));

      expect(
        _rule(period, EntitlementRule.laborContinuousService)?.legalReference,
        '4857 md. 54/2',
      );
      expect(_rule(period, EntitlementRule.laborAbsenceShift), isNull);
    });

    test('moves this and every later accrual date', () {
      final periods = _calculator.periods(
        _worker(
          start: start,
          absences: [
            DateRange(
              start: DateTime.utc(2020, 6),
              end: DateTime.utc(2020, 6, 10),
            ),
          ],
        ),
        until: DateTime.utc(2022, 12, 31),
      );

      expect(_dates(periods), [
        DateTime.utc(2021, 1, 11),
        DateTime.utc(2022, 1, 11),
      ]);
      for (final period in periods) {
        expect(_rule(period, EntitlementRule.laborAbsenceShift)?.params, {
          'shiftDays': '10',
        });
        expect(_rule(period, EntitlementRule.laborContinuousService), isNull);
      }
    });

    test('an absence over the anniversary counts in full', () {
      final periods = _calculator.periods(
        _worker(
          start: start,
          absences: [
            DateRange(
              start: DateTime.utc(2020, 12, 25),
              end: DateTime.utc(2021, 1, 10),
            ),
          ],
        ),
        until: DateTime.utc(2021, 12, 31),
      );

      expect(_dates(periods), [DateTime.utc(2021, 1, 18)]);
    });

    test('an absence from the accrual day on moves only later dates', () {
      final periods = _calculator.periods(
        _worker(
          start: start,
          absences: [
            DateRange(start: DateTime.utc(2021), end: DateTime.utc(2021, 1, 5)),
          ],
        ),
        until: DateTime.utc(2022, 12, 31),
      );

      expect(_dates(periods), [DateTime.utc(2021), DateTime.utc(2022, 1, 6)]);
      expect(_rule(periods.first, EntitlementRule.laborAbsenceShift), isNull);
    });

    test('overlapping absences count each day once', () {
      final periods = _calculator.periods(
        _worker(
          start: start,
          absences: [
            DateRange(
              start: DateTime.utc(2020, 6),
              end: DateTime.utc(2020, 6, 10),
            ),
            DateRange(
              start: DateTime.utc(2020, 6, 5),
              end: DateTime.utc(2020, 6, 15),
            ),
          ],
        ),
        until: DateTime.utc(2021, 12, 31),
      );

      expect(_dates(periods), [DateTime.utc(2021, 1, 16)]);
    });

    test('the shifted year keeps its seniority level', () {
      final periods = _calculator.periods(
        _worker(
          start: start,
          absences: [
            DateRange(
              start: DateTime.utc(2020, 6),
              end: DateTime.utc(2020, 6, 10),
            ),
          ],
        ),
        until: DateTime.utc(2026, 1, 11),
      );

      expect(periods.last.accrualDate, DateTime.utc(2026, 1, 11));
      expect(periods.last.days, 20);
    });

    test('absences move the next accrual and its countdown', () {
      final profile = _worker(
        start: DateTime.utc(2025),
        absences: [
          DateRange(
            start: DateTime.utc(2025, 3),
            end: DateTime.utc(2025, 3, 20),
          ),
        ],
      );
      final today = DateTime.utc(2025, 12, 31);
      final next = _calculator.nextAccrual(profile, today);

      expect(next, NextAccrual(date: DateTime.utc(2026, 1, 21), days: 14));
      expect(next!.date.difference(today).inDays, 21);
    });
  });

  group('contract extra days (1.7)', () {
    test('are added to every right as a separate rule', () {
      final period = _periodOn(
        _worker(start: DateTime.utc(2020, 3, 10), contractExtraDays: 2),
        DateTime.utc(2021, 3, 10),
      );

      expect(period.days, 16);
      expect(_rule(period, EntitlementRule.laborContractExtra)?.params, {
        'extraDays': '2',
      });
    });

    test('add up with the age minimum and underground days', () {
      final period = _periodOn(
        _worker(
          start: DateTime.utc(2020, 3, 10),
          birth: DateTime.utc(1973, 1, 15),
          isUnderground: true,
          contractExtraDays: 3,
        ),
        DateTime.utc(2023, 3, 10),
      );

      // max(14, 20) + 4 + 3.
      expect(period.days, 27);
    });

    test('a negative value is ignored, agreements may only add days', () {
      final period = _periodOn(
        _worker(start: DateTime.utc(2020, 3, 10), contractExtraDays: -5),
        DateTime.utc(2021, 3, 10),
      );

      expect(period.days, 14);
      expect(_rule(period, EntitlementRule.laborContractExtra), isNull);
    });
  });

  group('carry-over (1.8)', () {
    test('unused days never expire', () {
      final periods = _calculator.periods(
        _worker(start: DateTime.utc(2015, 3, 10)),
        until: DateTime.utc(2026, 11, 21),
      );

      expect(periods, hasLength(11));
      for (final period in periods) {
        expect(period.calendarYear, isNull);
        expect(period.expiresOn, isNull);
        expect(period.rules.last.code, EntitlementRule.laborNoExpiry.code);
      }
    });
  });

  group('next accrual', () {
    final profile = _worker(start: DateTime.utc(2025, 3, 10));

    test('gives the date, the days and a countdown', () {
      final today = DateTime.utc(2026, 1, 15);
      final next = _calculator.nextAccrual(profile, today);

      expect(next, NextAccrual(date: DateTime.utc(2026, 3, 10), days: 14));
      expect(next!.date.difference(today).inDays, 54);
    });

    test('on the accrual day the next one is a year later', () {
      expect(
        _calculator.nextAccrual(profile, DateTime.utc(2026, 3, 10)),
        NextAccrual(date: DateTime.utc(2027, 3, 10), days: 14),
      );
    });

    test('the teacher flag is a 657 rule and is ignored', () {
      final teacher = _worker(
        start: DateTime.utc(2020, 3, 10),
        isTeacher: true,
      );

      expect(
        _calculator.periods(teacher, until: DateTime.utc(2021, 3, 10)),
        hasLength(1),
      );
      expect(_calculator.nextAccrual(teacher, DateTime.utc(2021)), isNotNull);
    });
  });

  group('applied rules', () {
    test('keep a fixed order and cite 4857', () {
      final period = _periodOn(
        _worker(
          start: DateTime.utc(2020),
          birth: DateTime.utc(1970),
          priorService: const ServiceDuration(months: 2),
          isUnderground: true,
          contractExtraDays: 1,
          absences: [
            DateRange(start: DateTime.utc(2020, 6), end: DateTime.utc(2020, 6)),
          ],
        ),
        DateTime.utc(2020, 11, 2),
      );

      expect(period.accrualDate, DateTime.utc(2020, 11, 2));
      expect(period.days, 25);
      expect(_codes(period), [
        'laborAnniversary',
        'laborPriorService',
        'laborAbsenceShift',
        'laborSeniorityUpToFive',
        'laborAgeFiftyOrOlder',
        'laborUnderground',
        'laborContractExtra',
        'laborNoExpiry',
      ]);
      for (final rule in period.rules) {
        expect(rule.legalReference, startsWith('4857 md. '));
      }
    });
  });
}
