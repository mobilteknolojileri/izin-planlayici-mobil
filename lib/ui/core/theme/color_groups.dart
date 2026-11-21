import 'package:material_ui/material_ui.dart';

/// Colours of the hero card: the gradient card that carries a screen's main
/// number and the balance ring.
@immutable
class HeroColors {
  /// Creates the hero colours.
  const new({
    required this.top,
    required this.bottom,
    required this.onHero,
    required this.muted,
    required this.ringRemaining,
    required this.ringUsed,
    required this.ringPlanned,
    required this.ringTrack,
    required this.wave,
  });

  /// Interpolates between [a] and [b] for theme animations.
  new lerp(HeroColors a, HeroColors b, double t)
    : top = Color.lerp(a.top, b.top, t)!,
      bottom = Color.lerp(a.bottom, b.bottom, t)!,
      onHero = Color.lerp(a.onHero, b.onHero, t)!,
      muted = Color.lerp(a.muted, b.muted, t)!,
      ringRemaining = Color.lerp(a.ringRemaining, b.ringRemaining, t)!,
      ringUsed = Color.lerp(a.ringUsed, b.ringUsed, t)!,
      ringPlanned = Color.lerp(a.ringPlanned, b.ringPlanned, t)!,
      ringTrack = Color.lerp(a.ringTrack, b.ringTrack, t)!,
      wave = Color.lerp(a.wave, b.wave, t)!;

  /// Gradient start, top left.
  final Color top;

  /// Gradient end, bottom right. Also the ink of the ring patterns.
  final Color bottom;

  /// Text and icons, at least 4.5:1 on both gradient ends.
  final Color onHero;

  /// Secondary text, at least 4.5:1 on both gradient ends.
  final Color muted;

  /// Remaining segment of the ring, at least 3:1 on both gradient ends.
  final Color ringRemaining;

  /// Used segment of the ring, at least 3:1 on both gradient ends.
  final Color ringUsed;

  /// Planned segment of the ring, at least 3:1 on both gradient ends.
  final Color ringPlanned;

  /// Translucent track under the ring segments. Faint enough that every
  /// segment keeps 3:1 against it.
  final Color ringTrack;

  /// Translucent light wave behind the content. Faint enough that the
  /// text keeps 4.5:1 even where it crosses the lighter gradient end.
  final Color wave;

  @override
  bool operator ==(Object other) =>
      other is HeroColors &&
      other.top == top &&
      other.bottom == bottom &&
      other.onHero == onHero &&
      other.muted == muted &&
      other.ringRemaining == ringRemaining &&
      other.ringUsed == ringUsed &&
      other.ringPlanned == ringPlanned &&
      other.ringTrack == ringTrack &&
      other.wave == wave;

  @override
  int get hashCode => Object.hash(
    top,
    bottom,
    onHero,
    muted,
    ringRemaining,
    ringUsed,
    ringPlanned,
    ringTrack,
    wave,
  );
}

/// The accent colours of card headers. Each card category has one, so the
/// small icon square and the title tell cards apart at a glance.
enum AppTint {
  /// The brand colour, for bridge and general cards.
  blue,

  /// Accrual and positive news.
  green,

  /// Holidays and dates to watch.
  orange,

  /// Statistics and guides.
  purple,
}

/// Colours of one [AppTint].
@immutable
class TintColors {
  /// Creates the colours of a tint.
  const new({required this.icon, required this.onIcon, required this.title});

  /// Interpolates between [a] and [b] for theme animations.
  new lerp(TintColors a, TintColors b, double t)
    : icon = Color.lerp(a.icon, b.icon, t)!,
      onIcon = Color.lerp(a.onIcon, b.onIcon, t)!,
      title = Color.lerp(a.title, b.title, t)!;

  /// Pale fill of the icon square. Decorative, the glyph carries the
  /// meaning.
  final Color icon;

  /// The glyph inside the square, at least 4.5:1 on [icon] and 3:1 on
  /// the card.
  final Color onIcon;

  /// Card title, at least 4.5:1 on the card.
  final Color title;

  @override
  bool operator ==(Object other) =>
      other is TintColors &&
      other.icon == icon &&
      other.onIcon == onIcon &&
      other.title == title;

  @override
  int get hashCode => Object.hash(icon, onIcon, title);
}

/// Colours of the floating glass tab bar.
@immutable
class TabBarColors {
  /// Creates the tab bar colours.
  const new({
    required this.glass,
    required this.selected,
    required this.unselected,
  });

  /// Interpolates between [a] and [b] for theme animations.
  new lerp(TabBarColors a, TabBarColors b, double t)
    : glass = Color.lerp(a.glass, b.glass, t)!,
      selected = Color.lerp(a.selected, b.selected, t)!,
      unselected = Color.lerp(a.unselected, b.unselected, t)!;

  /// Translucent tint of the glass. Opaque enough that the labels keep
  /// 4.5:1 over anything that scrolls behind the bar.
  final Color glass;

  /// Icon and label of the current tab.
  final Color selected;

  /// Icons and labels of the other tabs.
  final Color unselected;

  @override
  bool operator ==(Object other) =>
      other is TabBarColors &&
      other.glass == glass &&
      other.selected == selected &&
      other.unselected == unselected;

  @override
  int get hashCode => Object.hash(glass, selected, unselected);
}

/// Colours of the main button: a vertical gradient with a soft glow.
@immutable
class ActionColors {
  /// Creates the button colours.
  const new({required this.top, required this.bottom});

  /// Interpolates between [a] and [b] for theme animations.
  new lerp(ActionColors a, ActionColors b, double t)
    : top = Color.lerp(a.top, b.top, t)!,
      bottom = Color.lerp(a.bottom, b.bottom, t)!;

  /// Gradient start. The label keeps 4.5:1 on it.
  final Color top;

  /// Gradient end, also the colour of the glow under the button.
  final Color bottom;

  @override
  bool operator ==(Object other) =>
      other is ActionColors && other.top == top && other.bottom == bottom;

  @override
  int get hashCode => Object.hash(top, bottom);
}
