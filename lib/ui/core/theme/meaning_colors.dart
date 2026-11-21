import 'package:material_ui/material_ui.dart';

/// The two colours of one `Meaning`.
@immutable
class MeaningColors {
  /// Creates the colours of a meaning.
  const new({required this.fill, required this.accent});

  /// Interpolates between [a] and [b] for theme animations.
  new lerp(MeaningColors a, MeaningColors b, double t)
    : fill = Color.lerp(a.fill, b.fill, t)!,
      accent = Color.lerp(a.accent, b.accent, t)!;

  /// Background of a mark, such as a day tile.
  final Color fill;

  /// Text, icon, pattern and border on [fill], at least 4.5:1 against it.
  /// The mark stays visible on a card because [fill] or [accent] has at
  /// least 3:1 against the card.
  final Color accent;

  @override
  bool operator ==(Object other) =>
      other is MeaningColors && other.fill == fill && other.accent == accent;

  @override
  int get hashCode => Object.hash(fill, accent);
}
