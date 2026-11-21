import 'package:izin_planla/domain/models/models.dart';

/// Rules the entitlement calculators apply, with their legal citation.
///
/// [code] is stored in `AppliedRule.code`. The "how was it calculated"
/// screen maps it back with [fromCode] and shows a localized sentence built
/// from `AppliedRule.params`. Every rule comes from `docs/mevzuat.md`.
/// Dates in params use `yyyy-MM-dd`, numbers are plain integers.
enum EntitlementRule {
  /// 4857: the right is earned on each service anniversary, section 1.1.
  ///
  /// Params: `serviceYears`.
  laborAnniversary('4857 md. 53/1, md. 54/3'),

  /// 4857: prior service with the same employer moves the start back,
  /// section 1.6.
  ///
  /// Params: `years`, `months`, `days`, `serviceStart`.
  laborPriorService('4857 md. 54/1'),

  /// 4857: absences outside art. 55 moved the accrual date, section 1.2.
  ///
  /// Params: `shiftDays`.
  laborAbsenceShift('4857 md. 54/2'),

  /// 4857: no absence was entered, so continuous work is assumed,
  /// section 1.2.
  laborContinuousService('4857 md. 54/2'),

  /// 4857: 1 to 5 years of service, 5 included, section 1.3.
  ///
  /// Params: `serviceYears`, `days`.
  laborSeniorityUpToFive('4857 md. 53/4'),

  /// 4857: more than 5 and less than 15 years of service, section 1.3.
  ///
  /// Params: `serviceYears`, `days`.
  laborSeniorityFiveToFifteen('4857 md. 53/4'),

  /// 4857: 15 years of service or more, section 1.3.
  ///
  /// Params: `serviceYears`, `days`.
  laborSeniorityFifteenOrMore('4857 md. 53/4'),

  /// 4857: aged 18 or younger on the accrual date raised the days to the
  /// age minimum, section 1.4.
  ///
  /// Params: `age`, `days`.
  laborAgeEighteenOrYounger('4857 md. 53/5'),

  /// 4857: aged 50 or older on the accrual date raised the days to the age
  /// minimum, section 1.4.
  ///
  /// Params: `age`, `days`.
  laborAgeFiftyOrOlder('4857 md. 53/5'),

  /// 4857: underground work adds days, section 1.5.
  ///
  /// Params: `extraDays`.
  laborUnderground('4857 md. 53/4'),

  /// 4857: extra days from the employment or collective agreement,
  /// section 1.7.
  ///
  /// Params: `extraDays`.
  laborContractExtra('4857 md. 53 son fıkra'),

  /// 4857: unused days never expire, section 1.8.
  laborNoExpiry('4857 md. 53/2, md. 54/4, md. 59'),

  /// 657: the first right is earned when service reaches one year,
  /// section 2.2.
  ///
  /// Params: `serviceStart`, `firstRightDate`, `calendarYear`.
  civilFirstRight('657 md. 102'),

  /// 657: counted prior service is over one year, so the first right is
  /// earned on the start of duty, section 2.2.
  ///
  /// Params: `firstRightDate`, `calendarYear`.
  civilFirstRightOnDutyStart('657 md. 102'),

  /// 657: later rights are earned on 1 January for that calendar year,
  /// section 2.2.
  ///
  /// Params: `calendarYear`.
  civilCalendarYear('657 md. 103'),

  /// 657: counted prior public service moves the service start back,
  /// section 2.1. The definition of counted service is from Tebliğ-154.
  ///
  /// Params: `years`, `months`, `days`, `serviceStart`.
  civilPriorService('657 md. 102'),

  /// 657: service of 1 to 10 years, 10 included, section 2.1.
  ///
  /// Params: `serviceYears`, `days`.
  civilUpToTenYears('657 md. 102'),

  /// 657: service over 10 years, section 2.1.
  ///
  /// Params: `serviceYears`, `days`.
  civilOverTenYears('657 md. 102'),

  /// 657: service passed 10 years during the year, so the difference is
  /// earned for that year on the 10th anniversary, section 2.3.
  ///
  /// Params: `transitionDate`, `calendarYear`, `days`.
  civilTenYearTransition('657 md. 102'),

  /// 657: unused days carry over one year and are dropped after that,
  /// section 2.4.
  ///
  /// Params: `calendarYear`, `expiresOn`.
  civilCarryOver('657 md. 103/1');

  new(this.legalReference);

  /// Legal citation shown next to the rule, e.g. `4857 md. 53/4`.
  final String legalReference;

  /// Stable identifier stored in `AppliedRule.code`.
  String get code => name;

  /// The rule whose [code] is [code], or null for an unknown code.
  static EntitlementRule? fromCode(String code) => values.asNameMap()[code];

  /// Builds the [AppliedRule] stored in an `EntitlementPeriod`.
  AppliedRule apply([Map<String, String> params = const <String, String>{}]) =>
      AppliedRule(code: code, legalReference: legalReference, params: params);
}
