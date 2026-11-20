/// Why a day inside a leave range counts or not.
///
/// Matches the steps of `docs/mevzuat.md` sections 1.9 and 2.5.
enum DayReason {
  /// A normal working day, counted in full.
  workday,

  /// Legal weekly rest day, not counted (4857).
  weeklyRest,

  /// Full-day official holiday, not counted.
  holiday,

  /// Non-working Saturday or other contractual rest day (4857).
  contractualRest,

  /// Eve or 28 October, counted by `HalfDayDeduction`.
  halfDayHoliday,

  /// Administrative leave day of a civil servant, not counted (657).
  administrativeLeave,

  /// Weekend inside a civil servant's leave, counted (657).
  weekendInsideLeave,

  /// Weekend or holiday at the edge of a civil servant's leave, trimmed.
  trimmedEdge,
}
