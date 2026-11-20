import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:izin_planla/domain/models/date_only_converter.dart';
import 'package:izin_planla/domain/models/date_range.dart';

part 'bridge_suggestion.freezed.dart';
part 'bridge_suggestion.g.dart';

/// Leave days that join holidays and weekends into one long break.
@freezed
abstract class BridgeSuggestion with _$BridgeSuggestion {
  /// Creates a suggestion.
  const factory({
    /// Days to take as leave.
    @DateOnlyConverter() required List<DateTime> leaveDays,

    /// The whole continuous break.
    required DateRange vacation,

    /// Calendar days in [vacation].
    required int totalDaysOff,

    /// Leave days deducted, eves may count as half.
    required double leaveDaysUsed,

    /// Names of the holidays inside the break.
    @Default(<String>[]) List<String> holidayNames,
  }) = _BridgeSuggestion;

  const new _();

  /// Creates a suggestion from JSON.
  factory fromJson(Map<String, dynamic> json) =>
      _$BridgeSuggestionFromJson(json);

  /// Days off gained per leave day.
  double get efficiency => leaveDaysUsed == 0
      ? totalDaysOff.toDouble()
      : totalDaysOff / leaveDaysUsed;
}
