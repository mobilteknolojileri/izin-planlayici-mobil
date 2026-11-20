import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:izin_planla/domain/models/date_only_converter.dart';
import 'package:izin_planla/domain/models/holiday_type.dart';

part 'holiday.freezed.dart';
part 'holiday.g.dart';

/// One official holiday day. Multi-day holidays have one entry per day.
@freezed
abstract class Holiday with _$Holiday {
  /// Creates a holiday day.
  const factory({
    @DateOnlyConverter() required DateTime date,
    required String name,
    required HolidayType type,

    /// Whether only the afternoon (from 13.00) is off.
    required bool halfDay,
  }) = _Holiday;

  /// Creates a holiday from the asset JSON.
  factory fromJson(Map<String, dynamic> json) => _$HolidayFromJson(json);
}
