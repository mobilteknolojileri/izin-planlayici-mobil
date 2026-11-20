import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:izin_planla/domain/models/date_only_converter.dart';
import 'package:izin_planla/domain/models/day_reason.dart';

part 'day_breakdown.freezed.dart';
part 'day_breakdown.g.dart';

/// How one day of a leave range is counted.
@freezed
abstract class DayBreakdown with _$DayBreakdown {
  /// Creates a day breakdown.
  const factory({
    @DateOnlyConverter() required DateTime date,

    /// Days deducted for this date: 0, 0.5 or 1.
    required double value,
    required DayReason reason,

    /// Holiday name when [reason] relates to a holiday.
    String? holidayName,
  }) = _DayBreakdown;

  /// Creates a day breakdown from JSON.
  factory fromJson(Map<String, dynamic> json) => _$DayBreakdownFromJson(json);
}
