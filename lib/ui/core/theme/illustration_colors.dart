import 'package:izin_planla/ui/core/theme/app_palette.dart';
import 'package:material_ui/material_ui.dart';

/// The colours used in `assets/illustrations/*.svg` and their dark theme
/// replacements.
///
/// The SVG files are drawn with the light colours only. In the dark theme
/// each one is swapped while the SVG is parsed.
abstract final class IllustrationColors {
  /// Outlines and small details.
  static const Color ink = AppPalette.ink14;

  /// Main shapes.
  static const Color primary = AppPalette.blue40;

  /// Soft background shapes.
  static const Color primarySoft = AppPalette.blue91;

  /// Warm accents such as the sun.
  static const Color warm = AppPalette.amber86;

  /// Holiday accents such as flags.
  static const Color coral = AppPalette.red70;

  /// Paper, cards and calendar sheets.
  static const Color paper = AppPalette.grey100;

  /// The background blob.
  static const Color mist = AppPalette.mist93;

  static final Map<int, Color> _dark = {
    ink.toARGB32(): AppPalette.grey91,
    primary.toARGB32(): AppPalette.blue64,
    primarySoft.toARGB32(): AppPalette.blue21,
    warm.toARGB32(): AppPalette.orange78,
    coral.toARGB32(): AppPalette.red58,
    paper.toARGB32(): AppPalette.grey18,
    mist.toARGB32(): AppPalette.grey10,
  };

  /// The dark theme colour for [color]. Unknown colours stay the same.
  static Color toDark(Color color) => _dark[color.toARGB32()] ?? color;
}
