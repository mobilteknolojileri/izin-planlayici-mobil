import 'package:izin_planla/domain/entitlement/absence_calendar.dart';
import 'package:izin_planla/domain/entitlement/calendar_arithmetic.dart';
import 'package:izin_planla/domain/entitlement/entitlement_calculator.dart';
import 'package:izin_planla/domain/entitlement/entitlement_rule.dart';
import 'package:izin_planla/domain/models/models.dart';

/// Annual leave rights of a worker under Labour Law 4857.
///
/// Implements `docs/mevzuat.md` section 1. The n-th right is earned on the
/// n-th anniversary of the service start, moved later by absences
/// (art. 54/2). Its length depends on the n completed years of service and
/// the completed age on that day (art. 53/4-5), plus underground and
/// contract days. Fields that only apply to civil servants, such as
/// `Profile.isTeacher`, are ignored.
final class LaborLawEntitlementCalculator implements EntitlementCalculator {
  /// Creates the calculator.
  const new();

  @override
  List<EntitlementPeriod> periods(Profile profile, {required DateTime until}) {
    final schedule = _LaborSchedule(profile);
    final limit = until.dateOnly;
    final result = <EntitlementPeriod>[];
    for (var year = schedule.firstListedYear; ; year++) {
      final date = schedule.accrualDate(year);
      if (date.isAfter(limit)) return result;
      result.add(schedule.period(year, date));
    }
  }

  @override
  NextAccrual? nextAccrual(Profile profile, DateTime today) {
    final schedule = _LaborSchedule(profile);
    final day = today.dateOnly;
    for (var year = schedule.firstListedYear; ; year++) {
      final date = schedule.accrualDate(year);
      if (date.isAfter(day)) {
        return NextAccrual(date: date, days: schedule.period(year, date).days);
      }
    }
  }
}

/// Accrual dates and day counts of one 4857 profile.
final class _LaborSchedule {
  factory(Profile profile) {
    final hireDate = profile.employmentStartDate.dateOnly;
    final serviceStart = hireDate.minusService(profile.priorService);
    return _LaborSchedule._(
      profile: profile,
      hireDate: hireDate,
      serviceStart: serviceStart,
      absences: AbsenceCalendar(profile.absencePeriods, from: serviceStart),
    );
  }

  const new _({
    required this.profile,
    required this.hireDate,
    required this.serviceStart,
    required this.absences,
  });

  /// Days for 1 to 5 years of service, 5 included (art. 53/4).
  static const int _upToFiveDays = 14;

  /// Days for more than 5 and less than 15 years of service (art. 53/4).
  static const int _fiveToFifteenDays = 20;

  /// Days for 15 years of service or more (art. 53/4).
  static const int _fifteenOrMoreDays = 26;

  /// Minimum days for workers aged 18 or younger, or 50 or older
  /// (art. 53/5).
  static const int _ageMinimumDays = 20;

  /// Extra days for underground work (art. 53/4).
  static const int _undergroundDays = 4;

  final Profile profile;
  final DateTime hireDate;

  /// Hire date minus prior service with the same employer, the
  /// `adjustedStart` of `docs/mevzuat.md` section 1.1.
  final DateTime serviceStart;
  final AbsenceCalendar absences;

  /// The first anniversary on or after the hire date.
  ///
  /// Earlier anniversaries belong to the earlier employment and are not
  /// listed (`docs/mevzuat.md` section 1.1).
  int get firstListedYear {
    var year = 1;
    while (accrualDate(year).isBefore(hireDate)) {
      year++;
    }
    return year;
  }

  /// The day the right for [year] completed years of service is earned.
  DateTime accrualDate(int year) =>
      absences.shift(serviceStart.plusYears(year));

  /// The right earned on [date] after [year] completed years of service.
  EntitlementPeriod period(int year, DateTime date) {
    final rules = <AppliedRule>[
      EntitlementRule.laborAnniversary.apply({'serviceYears': '$year'}),
      if (_hasPriorService)
        EntitlementRule.laborPriorService.apply({
          'years': '${profile.priorService.years}',
          'months': '${profile.priorService.months}',
          'days': '${profile.priorService.days}',
          'serviceStart': serviceStart.isoDate,
        }),
    ];

    final shiftDays = date.difference(serviceStart.plusYears(year)).inDays;
    if (shiftDays > 0) {
      rules.add(
        EntitlementRule.laborAbsenceShift.apply({'shiftDays': '$shiftDays'}),
      );
    } else if (absences.isEmpty) {
      rules.add(EntitlementRule.laborContinuousService.apply());
    }

    final (tierDays, tierRule) = switch (year) {
      <= 5 => (_upToFiveDays, EntitlementRule.laborSeniorityUpToFive),
      < 15 => (_fiveToFifteenDays, EntitlementRule.laborSeniorityFiveToFifteen),
      _ => (_fifteenOrMoreDays, EntitlementRule.laborSeniorityFifteenOrMore),
    };
    rules.add(tierRule.apply({'serviceYears': '$year', 'days': '$tierDays'}));
    var days = tierDays;

    // Completed age on the accrual date, `docs/mevzuat.md` section 1.4.
    // Without a birth date the age rules cannot apply.
    final age = profile.birthDate?.completedYearsUntil(date);
    final ageRule = age == null
        ? null
        : age <= 18
        ? EntitlementRule.laborAgeEighteenOrYounger
        : age >= 50
        ? EntitlementRule.laborAgeFiftyOrOlder
        : null;
    if (ageRule != null && days < _ageMinimumDays) {
      days = _ageMinimumDays;
      rules.add(ageRule.apply({'age': '$age', 'days': '$days'}));
    }

    // Added after the age minimum: `max(seniority, age minimum) + 4`,
    // `docs/mevzuat.md` section 1.5.
    if (profile.isUnderground) {
      days += _undergroundDays;
      rules.add(
        EntitlementRule.laborUnderground.apply({
          'extraDays': '$_undergroundDays',
        }),
      );
    }

    // Agreements may only increase the days (art. 53, last paragraph), so a
    // negative value is ignored.
    final extraDays = profile.contractExtraDays;
    if (extraDays > 0) {
      days += extraDays;
      rules.add(
        EntitlementRule.laborContractExtra.apply({'extraDays': '$extraDays'}),
      );
    }

    rules.add(EntitlementRule.laborNoExpiry.apply());
    return EntitlementPeriod(accrualDate: date, days: days, rules: rules);
  }

  bool get _hasPriorService {
    final prior = profile.priorService;
    return prior.years != 0 || prior.months != 0 || prior.days != 0;
  }
}
