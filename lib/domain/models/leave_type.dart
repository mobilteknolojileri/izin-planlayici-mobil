/// Leave categories. Only [annual] reduces the annual leave balance, except a
/// civil servant's second excuse block (see `LeaveRecord.deductsFromAnnual`).
enum LeaveType {
  /// Annual paid leave.
  annual,

  /// Sick leave or medical report.
  sick,

  /// Unpaid leave.
  unpaid,

  /// Maternity leave.
  maternity,

  /// Paternity leave.
  paternity,

  /// Marriage leave.
  marriage,

  /// Bereavement leave.
  bereavement,

  /// Adoption leave (4857 additional art. 2).
  adoption,

  /// Care of a child with at least 70% disability or chronic illness.
  disabledChildCare,

  /// Union leave.
  union,

  /// Other excuse leave.
  excuse,

  /// Travel days added to annual leave.
  travel,

  /// User-named leave type, see `LeaveRecord.customTypeName`.
  other,
}
