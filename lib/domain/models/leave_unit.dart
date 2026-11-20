/// How a leave record is measured.
enum LeaveUnit {
  /// Whole days within the record's date range.
  days,

  /// A single half day.
  halfDay,

  /// A number of hours on a single day.
  hours,
}
