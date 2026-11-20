/// How much annual leave an eve (arife) or 28 October morning costs.
///
/// The law is unclear, see `docs/mevzuat.md` section 4. Default is [half].
enum HalfDayDeduction {
  /// The morning does not reduce the balance.
  zero(0),

  /// Half a day.
  half(0.5),

  /// A full day.
  full(1);

  new(this.days);

  /// Days deducted from the balance.
  final double days;
}
