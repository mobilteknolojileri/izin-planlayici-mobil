import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_duration.freezed.dart';
part 'service_duration.g.dart';

/// A length of service entered as years, months and days.
///
/// Subtracted from the start date with calendar arithmetic, see
/// `docs/mevzuat.md` section 5.
@freezed
abstract class ServiceDuration with _$ServiceDuration {
  /// Creates a duration. All parts default to zero.
  const factory({
    @Default(0) int years,
    @Default(0) int months,
    @Default(0) int days,
  }) = _ServiceDuration;

  /// Creates a duration from JSON.
  factory fromJson(Map<String, dynamic> json) =>
      _$ServiceDurationFromJson(json);
}
