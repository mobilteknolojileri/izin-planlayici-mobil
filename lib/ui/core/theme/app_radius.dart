import 'package:material_ui/material_ui.dart';

/// Corner radii.
abstract final class AppRadius {
  /// 8, small marks such as legend swatches and card header icons.
  static const small = BorderRadius.all(Radius.circular(8));

  /// 12, inputs and list tiles.
  static const medium = BorderRadius.all(Radius.circular(12));

  /// 14, day tiles of the week strip.
  static const tile = BorderRadius.all(Radius.circular(14));

  /// 16, snack bars.
  static const large = BorderRadius.all(Radius.circular(16));

  /// 26, cards, the iOS inset grouped card radius.
  static const card = BorderRadius.all(Radius.circular(26));

  /// 28, dialogs and bottom sheets.
  static const extraLarge = BorderRadius.all(Radius.circular(28));
}

/// Shapes drawn with continuous (superellipse) corners, as on iOS, so a
/// corner flows into the edge instead of meeting it at a visible joint.
abstract final class AppShapes {
  /// Cards.
  static const card = RoundedSuperellipseBorder(borderRadius: AppRadius.card);

  /// Day tiles.
  static const tile = RoundedSuperellipseBorder(borderRadius: AppRadius.tile);

  /// Card header icon squares and legend swatches.
  static const small = RoundedSuperellipseBorder(borderRadius: AppRadius.small);

  /// Snack bars.
  static const large = RoundedSuperellipseBorder(borderRadius: AppRadius.large);

  /// Dialogs and bottom sheets.
  static const extraLarge = RoundedSuperellipseBorder(
    borderRadius: AppRadius.extraLarge,
  );
}
