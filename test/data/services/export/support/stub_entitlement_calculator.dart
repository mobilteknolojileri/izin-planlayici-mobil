import 'package:izin_planla/domain/entitlement/entitlement_calculator.dart';
import 'package:izin_planla/domain/models/models.dart';

/// [EntitlementCalculator] that returns fixed results.
class StubEntitlementCalculator implements EntitlementCalculator {
  /// Creates a calculator returning [result] and [next].
  const new({this.result = const [], this.next});

  /// Periods returned by [periods], in any order.
  final List<EntitlementPeriod> result;

  /// Value returned by [nextAccrual].
  final NextAccrual? next;

  @override
  List<EntitlementPeriod> periods(Profile profile, {required DateTime until}) =>
      result;

  @override
  NextAccrual? nextAccrual(Profile profile, DateTime today) => next;
}
