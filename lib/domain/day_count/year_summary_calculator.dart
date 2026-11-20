import 'package:izin_planla/domain/models/models.dart';

/// Builds the yearly statistics shown on the stats screen.
abstract interface class YearSummaryCalculator {
  /// Statistics of [profile] for [year].
  YearSummary summary({
    required int year,
    required Profile profile,
    required List<EntitlementPeriod> periods,
    required List<LeaveRecord> leaves,
    required List<Holiday> holidays,
  });
}
