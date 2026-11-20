import 'package:freezed_annotation/freezed_annotation.dart';

part 'leave_balance.freezed.dart';
part 'leave_balance.g.dart';

/// Annual leave balance of a profile on a given day.
@freezed
abstract class LeaveBalance with _$LeaveBalance {
  /// Creates a balance. [remaining] may be negative.
  const factory({
    required double earned,
    required double used,
    required double planned,
    required double remaining,

    /// Days dropped at year end if unused (657 only, otherwise 0).
    @Default(0) double expiringAtYearEnd,
  }) = _LeaveBalance;

  /// Creates a balance from JSON.
  factory fromJson(Map<String, dynamic> json) => _$LeaveBalanceFromJson(json);
}
