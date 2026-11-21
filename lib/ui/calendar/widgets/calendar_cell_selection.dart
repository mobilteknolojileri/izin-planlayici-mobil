/// How a day tile relates to the user's selection.
enum CalendarCellSelection {
  /// Not selected.
  none,

  /// The selected day, or the first or last day of the selected range.
  edge,

  /// A day inside the selected range.
  inside,
}
