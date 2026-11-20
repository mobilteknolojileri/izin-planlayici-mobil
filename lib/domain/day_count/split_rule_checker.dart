import 'package:izin_planla/domain/models/models.dart';

/// Checks the split rule (4857 art. 56) and travel leave limits.
abstract interface class SplitRuleChecker {
  /// Warnings about split annual leave and travel leave limits.
  List<LeaveWarning> check({
    required Profile profile,
    required List<EntitlementPeriod> periods,
    required List<LeaveRecord> leaves,
    required List<Holiday> holidays,
  });
}
