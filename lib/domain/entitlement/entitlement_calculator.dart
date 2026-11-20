import 'package:izin_planla/domain/models/models.dart';

/// Calculates annual leave rights from a profile.
///
/// Rules come only from `docs/mevzuat.md` sections 1 and 2.
abstract interface class EntitlementCalculator {
  /// Entitlement periods earned up to and including [until].
  List<EntitlementPeriod> periods(Profile profile, {required DateTime until});

  /// The next accrual after [today], or null when the profile earns none,
  /// e.g. a teacher (657 art. 103/2).
  NextAccrual? nextAccrual(Profile profile, DateTime today);
}
