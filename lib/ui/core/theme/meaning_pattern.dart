/// Fill pattern that tells meanings apart without colour, for colour-blind
/// users and greyscale screens.
enum MeaningPattern {
  /// Fill colour and border only.
  none,

  /// Fully filled with the accent colour.
  solid,

  /// Diagonal lines, bottom left to top right.
  stripes,

  /// A grid of dots.
  dots,

  /// Diagonal lines in both directions.
  crosshatch,

  /// The bottom right half filled, like a half day.
  half,

  /// Horizontal lines.
  horizontalLines,

  /// Vertical lines.
  verticalLines,
}
