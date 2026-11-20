import 'package:izin_planla/domain/day_count/year_summary_calculator.dart';
import 'package:izin_planla/domain/models/models.dart';

/// Implementation of [YearSummaryCalculator]. Written by task 08.
class DefaultYearSummaryCalculator implements YearSummaryCalculator {
  /// Creates the calculator.
  const new();

  @override
  YearSummary summary({
    required int year,
    required Profile profile,
    required List<EntitlementPeriod> periods,
    required List<LeaveRecord> leaves,
    required List<Holiday> holidays,
  }) => throw UnimplementedError();
}
