/// How the bridge planner sees one day of a profile's calendar.
enum BridgeDayKind {
  /// Off without leave: the weekly rest day, another non-working weekday, a
  /// full-day holiday or a civil servant's administrative leave day.
  free,

  /// A working day. Being off on it needs a leave day.
  workday,

  /// An eve or 28 October on a working day. The afternoon is off from 13.00,
  /// the morning needs leave (`docs/mevzuat.md` section 4).
  eve;

  /// Whether the day has to be taken as leave to be part of a break.
  bool get needsLeave => this != free;
}
