import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:izin_planla/domain/models/leave_warning_type.dart';

part 'leave_warning.freezed.dart';
part 'leave_warning.g.dart';

/// A warning about a profile's leave records.
@freezed
abstract class LeaveWarning with _$LeaveWarning {
  /// Creates a warning.
  const factory({
    required LeaveWarningType type,

    /// Values used in the sentence, e.g. `{'days': '3'}`.
    @Default(<String, String>{}) Map<String, String> params,
  }) = _LeaveWarning;

  /// Creates a warning from JSON.
  factory fromJson(Map<String, dynamic> json) => _$LeaveWarningFromJson(json);
}
