import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:izin_planla/domain/models/day_breakdown.dart';

part 'day_count.freezed.dart';
part 'day_count.g.dart';

/// Leave days deducted for a range, with the reason for every day.
@freezed
abstract class DayCount with _$DayCount {
  /// Creates a day count.
  const factory({
    required double total,
    @Default(<DayBreakdown>[]) List<DayBreakdown> days,
  }) = _DayCount;

  /// Creates a day count from JSON.
  factory fromJson(Map<String, dynamic> json) => _$DayCountFromJson(json);
}
