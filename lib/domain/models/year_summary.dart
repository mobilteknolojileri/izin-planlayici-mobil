import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:izin_planla/domain/models/leave_type.dart';

part 'year_summary.freezed.dart';
part 'year_summary.g.dart';

/// Leave statistics of one profile for one calendar year.
@freezed
abstract class YearSummary with _$YearSummary {
  /// Creates a year summary.
  const factory({
    required int year,

    /// Annual leave days earned in [year].
    required double earned,

    /// Annual leave days used in [year].
    required double used,

    /// Leave, holidays and weekends together, in calendar days.
    required int totalDaysOff,

    /// Days used per leave type.
    @Default(<LeaveType, double>{}) Map<LeaveType, double> usedByType,

    /// Annual leave days used per month, keys 1-12.
    @Default(<int, double>{}) Map<int, double> usedByMonth,
  }) = _YearSummary;

  /// Creates a year summary from JSON.
  factory fromJson(Map<String, dynamic> json) => _$YearSummaryFromJson(json);
}
