import 'package:izin_planla/domain/models/models.dart';

/// Calculates earned, used, planned and remaining annual leave.
abstract interface class BalanceCalculator {
  /// Annual leave balance of [profile] on [today].
  LeaveBalance balance({
    required Profile profile,
    required List<EntitlementPeriod> periods,
    required List<LeaveRecord> leaves,
    required List<Holiday> holidays,
    required DateTime today,
  });
}
