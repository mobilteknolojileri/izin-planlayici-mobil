/// Warnings produced while adding or checking leave.
enum LeaveWarningType {
  /// No part of a split annual leave is at least 10 days (4857 art. 56).
  splitRule,

  /// The leave exceeds the remaining balance.
  insufficientBalance,

  /// Travel leave exceeds 4 days in a period.
  travelLeaveLimit,
}
