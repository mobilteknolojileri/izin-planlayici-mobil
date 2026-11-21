import 'package:izin_planla/domain/entitlement/civil_servant_entitlement_calculator.dart';
import 'package:izin_planla/domain/entitlement/entitlement_calculator.dart';
import 'package:izin_planla/domain/entitlement/labor_law_entitlement_calculator.dart';
import 'package:izin_planla/domain/models/models.dart';

/// Implementation of [EntitlementCalculator]. Written by task 07.
///
/// Picks the rules of the profile's law: [LaborLawEntitlementCalculator] for
/// 4857 and [CivilServantEntitlementCalculator] for 657.
class DefaultEntitlementCalculator implements EntitlementCalculator {
  /// Creates the calculator.
  const new();

  @override
  List<EntitlementPeriod> periods(Profile profile, {required DateTime until}) =>
      _calculatorFor(profile).periods(profile, until: until);

  @override
  NextAccrual? nextAccrual(Profile profile, DateTime today) =>
      _calculatorFor(profile).nextAccrual(profile, today);

  static EntitlementCalculator _calculatorFor(Profile profile) =>
      switch (profile.employmentType) {
        EmploymentType.laborLaw => const LaborLawEntitlementCalculator(),
        EmploymentType.civilServant =>
          const CivilServantEntitlementCalculator(),
      };
}
