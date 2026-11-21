import 'package:material_ui/material_ui.dart';

/// Tier 1 colour primitives. The only file in the app with colour literals.
///
/// Names are the hue family and the measured CIELAB lightness (L*, 0-100), so
/// `blue37` is darker than `blue40` and a new tone fits between them. A
/// trailing `a85` means 85% opacity. Widgets never read these directly, they
/// read the semantic slots of `ColorScheme` and `AppColors`.
abstract final class AppPalette {
  /// Deep navy, hero gradient end in the dark theme.
  static const blue13 = Color(0xFF0D1A5C);

  /// Navy, hero gradient end in the light theme.
  static const blue20 = Color(0xFF13277E);

  /// Dark royal blue, containers in the dark theme.
  static const blue21 = Color(0xFF1E2C6B);

  /// Deep royal blue, bottom of the main button gradient.
  static const blue34 = Color(0xFF1F3FC8);

  /// Royal blue, the brand colour.
  static const blue37 = Color(0xFF2447D6);

  /// Royal blue, a little lighter, hero gradient start.
  static const blue40 = Color(0xFF2B4FD8);

  /// Bright royal blue, top of the main button gradient.
  static const blue47 = Color(0xFF3563EC);

  /// Periwinkle, bottom of the main button gradient in the dark theme.
  static const blue59 = Color(0xFF6A87FA);

  /// Light royal blue, the brand colour on dark surfaces.
  static const blue64 = Color(0xFF7B96FF);

  /// Light periwinkle, top of the main button gradient in the dark theme.
  static const blue71 = Color(0xFF93AAFF);

  /// Pale royal blue, accent text on dark surfaces.
  static const blue73 = Color(0xFF9DB1FF);

  /// Sky blue, the remaining segment of the balance ring.
  static const blue79 = Color(0xFFA9C4FF);

  /// Mist blue, containers and muted text on the hero card.
  static const blue91 = Color(0xFFDDE4FF);

  /// Black.
  static const grey00 = Color(0xFF000000);

  /// Card surface in the dark theme.
  static const grey10 = Color(0xFF1C1C1E);

  /// [grey10] at 85%, tint of the glass tab bar in the dark theme.
  static const grey10a85 = Color(0xD91C1C1E);

  /// Weekend tile in the dark theme.
  static const grey14 = Color(0xFF242426);

  /// Raised surface in the dark theme.
  static const grey18 = Color(0xFF2C2C2E);

  /// Highest surface in the dark theme.
  static const grey21 = Color(0xFF333336);

  /// Separators in the dark theme.
  static const grey24 = Color(0xFF38383A);

  /// Text on light tiles.
  static const grey26 = Color(0xFF3C3C43);

  /// Strong secondary text and icons on light grey.
  static const grey31 = Color(0xFF48484D);

  /// Secondary text in the light theme.
  static const grey39 = Color(0xFF5C5C61);

  /// Control outlines in the light theme.
  static const grey52 = Color(0xFF7C7C80);

  /// Control outlines in the dark theme.
  static const grey59 = Color(0xFF8E8E93);

  /// Secondary text in the dark theme.
  static const grey66 = Color(0xFFA1A1A8);

  /// Light grey text and icons on dark tiles.
  static const grey80 = Color(0xFFC7C7CC);

  /// Separators in the light theme.
  static const grey91 = Color(0xFFE5E5EA);

  /// Tinted grey, inputs and weekend tiles.
  static const grey92 = Color(0xFFE9E9EE);

  /// Light lavender grey, text on dark tiles.
  static const grey93 = Color(0xFFEBEBF5);

  /// Grouped screen background in the light theme.
  static const grey96 = Color(0xFFF2F2F7);

  /// White.
  static const grey100 = Color(0xFFFFFFFF);

  /// [grey100] at 4%, the light wave on the hero card.
  static const grey100a04 = Color(0x0AFFFFFF);

  /// [grey100] at 8%, the track of the balance ring on the hero card.
  static const grey100a08 = Color(0x14FFFFFF);

  /// [grey100] at 85%, tint of the glass tab bar in the light theme.
  static const grey100a85 = Color(0xD9FFFFFF);

  /// Navy ink, outlines of the illustrations.
  static const ink14 = Color(0xFF1F2433);

  /// Blue-tinted mist, background blob of the illustrations.
  static const mist93 = Color(0xFFE9ECF5);

  /// Dark green, used-day tile in the dark theme.
  static const green17 = Color(0xFF15301E);

  /// Forest green, used-day text and icons.
  static const green39 = Color(0xFF186B2D);

  /// Green, accrual tint in the light theme.
  static const green45 = Color(0xFF1E7B34);

  /// Bright green, accrual tint in the dark theme.
  static const green74 = Color(0xFF30D158);

  /// Pale green, used-day tile.
  static const green94 = Color(0xFFDDF3E4);

  /// Dark orange, eve tile in the dark theme.
  static const orange18 = Color(0xFF3A2A12);

  /// Burnt orange, eve text and icons.
  static const orange38 = Color(0xFF9A3A00);

  /// Orange, holiday tint in the light theme.
  static const orange45 = Color(0xFFC93400);

  /// Bright orange, holiday tint in the dark theme.
  static const orange74 = Color(0xFFFF9F0A);

  /// Light orange, eve text and icons in the dark theme.
  static const orange78 = Color(0xFFFFB340);

  /// Pale orange, eve tile.
  static const orange94 = Color(0xFFFFE9D6);

  /// Dark amber, planned-day tile in the dark theme.
  static const amber17 = Color(0xFF33290F);

  /// Brown amber, planned-day text and icons.
  static const amber37 = Color(0xFF6E5200);

  /// Warm amber, the planned segment of the balance ring.
  static const amber86 = Color(0xFFFFD27A);

  /// Yellow, planned-day text and icons in the dark theme.
  static const amber87 = Color(0xFFFFD60A);

  /// Pale amber, planned-day tile.
  static const amber96 = Color(0xFFFFF3CC);

  /// Dark red, holiday tile in the dark theme.
  static const red15 = Color(0xFF3A1D1A);

  /// Deep red, text on error containers.
  static const red30 = Color(0xFF8A1A10);

  /// Brick red, holiday text and icons.
  static const red39 = Color(0xFFB0230F);

  /// Red, errors in the light theme.
  static const red45 = Color(0xFFD70015);

  /// Bright red, errors in the dark theme.
  static const red58 = Color(0xFFFF453A);

  /// Salmon, holiday text and icons in the dark theme.
  static const red70 = Color(0xFFFF8A80);

  /// Light salmon, text on error containers in the dark theme.
  static const red80 = Color(0xFFFFB4AB);

  /// Pale red, holiday tile and error containers.
  static const red93 = Color(0xFFFFE4E1);

  /// Dark purple, tertiary container in the dark theme.
  static const purple18 = Color(0xFF3D1F4D);

  /// Deep purple, text on tertiary containers.
  static const purple21 = Color(0xFF4A1D61);

  /// Purple, tertiary colour in the light theme.
  static const purple42 = Color(0xFF8944AB);

  /// Bright purple, tertiary colour in the dark theme.
  static const purple57 = Color(0xFFBF5AF2);

  /// Pale purple, tertiary container.
  static const purple93 = Color(0xFFF3E5FA);
}
