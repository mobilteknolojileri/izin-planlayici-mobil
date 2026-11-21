import 'package:izin_planla/domain/entitlement/calendar_arithmetic.dart';
import 'package:izin_planla/domain/entitlement/entitlement_calculator.dart';
import 'package:izin_planla/domain/entitlement/entitlement_rule.dart';
import 'package:izin_planla/domain/models/models.dart';

/// Annual leave rights of a civil servant under Law 657.
///
/// Implements `docs/mevzuat.md` sections 2.1 to 2.4. The first right is
/// earned when counted service reaches one year and belongs to that calendar
/// year. Later rights are earned on 1 January. When service passes 10 years
/// during a year, the 10-day difference is earned on the 10th anniversary.
/// Each right is dropped on 1 January two years after its calendar year.
///
/// Teachers earn nothing (657 art. 103/2). Age, underground work, contract
/// days and absence periods are 4857 rules and are ignored here.
final class CivilServantEntitlementCalculator implements EntitlementCalculator {
  /// Creates the calculator.
  const new();

  @override
  List<EntitlementPeriod> periods(Profile profile, {required DateTime until}) {
    if (profile.isTeacher) return const [];
    final limit = until.dateOnly;
    return _CivilSchedule(profile)
        .periods()
        .takeWhile((p) => !p.accrualDate.isAfter(limit))
        .toList();
  }

  @override
  NextAccrual? nextAccrual(Profile profile, DateTime today) {
    if (profile.isTeacher) return null;
    final day = today.dateOnly;
    final next = _CivilSchedule(profile)
        .periods()
        .firstWhere((p) => p.accrualDate.isAfter(day));
    return NextAccrual(date: next.accrualDate, days: next.days);
  }
}

/// Accrual dates and day counts of one 657 profile.
final class _CivilSchedule {
  factory(Profile profile) {
    final dutyStart = profile.employmentStartDate.dateOnly;
    final serviceStart = dutyStart.minusService(profile.priorService);
    final oneYear = serviceStart.plusYears(1);
    return _CivilSchedule._(
      profile: profile,
      serviceStart: serviceStart,
      firstRightDate: oneYear.isBefore(dutyStart) ? dutyStart : oneYear,
      onDutyStart: oneYear.isBefore(dutyStart),
      tenYearDate: serviceStart.plusYears(10),
    );
  }

  const new _({
    required this.profile,
    required this.serviceStart,
    required this.firstRightDate,
    required this.onDutyStart,
    required this.tenYearDate,
  });

  /// Days for 1 to 10 years of service, 10 included (657 art. 102).
  static const int _upToTenDays = 20;

  /// Days for more than 10 years of service (657 art. 102).
  static const int _overTenDays = 30;

  final Profile profile;

  /// Start of duty minus counted prior service, `docs/mevzuat.md` 2.1.
  final DateTime serviceStart;

  /// The day the first right is earned, `docs/mevzuat.md` 2.2.
  final DateTime firstRightDate;

  /// Whether prior service over one year moved the first right to the start
  /// of duty.
  final bool onDutyStart;

  /// The 10th anniversary, from which service counts as over 10 years
  /// (`docs/mevzuat.md` 2.3).
  final DateTime tenYearDate;

  /// Every right in date order, without end.
  Iterable<EntitlementPeriod> periods() sync* {
    final firstYear = firstRightDate.year;
    for (var year = firstYear; ; year++) {
      final accrualDate = year == firstYear
          ? firstRightDate
          : DateTime.utc(year);
      yield _yearPeriod(year, accrualDate);
      if (tenYearDate.year == year && tenYearDate.isAfter(accrualDate)) {
        yield _transitionPeriod(year);
      }
    }
  }

  EntitlementPeriod _yearPeriod(int year, DateTime accrualDate) {
    final overTen = !accrualDate.isBefore(tenYearDate);
    final days = overTen ? _overTenDays : _upToTenDays;
    final serviceYears = serviceStart.completedYearsUntil(accrualDate);
    final calendarYear = {'calendarYear': '$year'};
    final rules = <AppliedRule>[
      if (year != firstRightDate.year)
        EntitlementRule.civilCalendarYear.apply(calendarYear)
      else if (onDutyStart)
        EntitlementRule.civilFirstRightOnDutyStart.apply({
          'firstRightDate': firstRightDate.isoDate,
          ...calendarYear,
        })
      else
        EntitlementRule.civilFirstRight.apply({
          'serviceStart': serviceStart.isoDate,
          'firstRightDate': firstRightDate.isoDate,
          ...calendarYear,
        }),
      ?_priorServiceRule,
      (overTen
              ? EntitlementRule.civilOverTenYears
              : EntitlementRule.civilUpToTenYears)
          .apply({'serviceYears': '$serviceYears', 'days': '$days'}),
    ];
    return _period(year, accrualDate, days, rules);
  }

  EntitlementPeriod _transitionPeriod(int year) {
    const days = _overTenDays - _upToTenDays;
    final rules = <AppliedRule>[
      EntitlementRule.civilTenYearTransition.apply({
        'transitionDate': tenYearDate.isoDate,
        'calendarYear': '$year',
        'days': '$days',
      }),
      ?_priorServiceRule,
    ];
    return _period(year, tenYearDate, days, rules);
  }

  /// Adds the carry-over rule: the unused part of year Y is dropped on
  /// 1 January of Y + 2 (657 art. 103/1, `docs/mevzuat.md` 2.4).
  EntitlementPeriod _period(
    int year,
    DateTime accrualDate,
    int days,
    List<AppliedRule> rules,
  ) {
    final expiresOn = DateTime.utc(year + 2);
    return EntitlementPeriod(
      accrualDate: accrualDate,
      days: days,
      calendarYear: year,
      expiresOn: expiresOn,
      rules: [
        ...rules,
        EntitlementRule.civilCarryOver.apply({
          'calendarYear': '$year',
          'expiresOn': expiresOn.isoDate,
        }),
      ],
    );
  }

  AppliedRule? get _priorServiceRule {
    final prior = profile.priorService;
    if (prior.years == 0 && prior.months == 0 && prior.days == 0) return null;
    return EntitlementRule.civilPriorService.apply({
      'years': '${prior.years}',
      'months': '${prior.months}',
      'days': '${prior.days}',
      'serviceStart': serviceStart.isoDate,
    });
  }
}
