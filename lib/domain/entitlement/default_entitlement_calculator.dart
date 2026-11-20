import 'package:izin_planla/domain/entitlement/entitlement_calculator.dart';
import 'package:izin_planla/domain/models/models.dart';

/// Implementation of [EntitlementCalculator]. Written by task 07.
class DefaultEntitlementCalculator implements EntitlementCalculator {
  /// Creates the calculator.
  const new();

  @override
  List<EntitlementPeriod> periods(Profile profile, {required DateTime until}) =>
      throw UnimplementedError();

  @override
  NextAccrual? nextAccrual(Profile profile, DateTime today) =>
      throw UnimplementedError();
}
