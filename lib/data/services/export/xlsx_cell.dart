/// One cell of a worksheet row written by `XlsxWriter`.
///
/// A sealed hierarchy so the writer handles every cell kind exhaustively.
sealed class XlsxCell {
  const new();
}

/// A text cell, stored as a shared string.
final class XlsxText extends XlsxCell {
  /// Creates a text cell.
  const new(this.value, {this.bold = false});

  /// Cell text. Longer than Excel's 32767 characters is cut.
  final String value;

  /// Whether the text is bold, used for header rows.
  final bool bold;
}

/// A numeric cell shown with the General number format.
final class XlsxNumber extends XlsxCell {
  /// Creates a number cell. [value] must be finite.
  const new(this.value);

  /// Cell value.
  final num value;
}

/// A calendar date cell shown as `dd.mm.yyyy`.
final class XlsxDate extends XlsxCell {
  /// Creates a date cell. Only year, month and day of [value] are used.
  const new(this.value);

  /// Cell date.
  final DateTime value;
}

/// An empty cell.
final class XlsxBlank extends XlsxCell {
  /// Creates an empty cell.
  const new();
}
