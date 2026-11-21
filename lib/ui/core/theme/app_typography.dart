import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

/// Text styles of the app, in the bundled Inter font.
///
/// Sizes follow the iOS text styles, with body and title sizes one or two
/// points larger because many users read without glasses. Large numbers use
/// tabular figures so balances line up.
abstract final class AppTypography {
  /// The only font family. One variable font file, `FontWeight` drives its
  /// weight axis.
  static const fontFamily = 'Inter';

  static const _tabular = [FontFeature.tabularFigures()];

  /// Sizes, line heights and weights. Colours come from the theme.
  static const textTheme = TextTheme(
    // The hero number, such as the remaining days.
    displayLarge: TextStyle(
      fontSize: 76,
      height: 1,
      fontWeight: FontWeight.w700,
      letterSpacing: -3,
      fontFeatures: _tabular,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      height: 52 / 45,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      fontFeatures: _tabular,
    ),
    // Numbers on stat cards.
    displaySmall: TextStyle(
      fontSize: 40,
      height: 1,
      fontWeight: FontWeight.w700,
      letterSpacing: -1.5,
      fontFeatures: _tabular,
    ),
    // The large screen title, as in iOS.
    headlineLarge: TextStyle(
      fontSize: 34,
      height: 41 / 34,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.8,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      height: 36 / 28,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      height: 32 / 24,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      height: 28 / 22,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    ),
    titleMedium: TextStyle(
      fontSize: 17,
      height: 24 / 17,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    ),
    titleSmall: TextStyle(
      fontSize: 15,
      height: 20 / 15,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    ),
    bodyLarge: TextStyle(
      fontSize: 17,
      height: 24 / 17,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    ),
    bodyMedium: TextStyle(
      fontSize: 15,
      height: 22 / 15,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    ),
    bodySmall: TextStyle(
      fontSize: 13,
      height: 18 / 13,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    ),
    labelLarge: TextStyle(
      fontSize: 15,
      height: 20 / 15,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    ),
    labelMedium: TextStyle(
      fontSize: 13,
      height: 16 / 13,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
    ),
    labelSmall: TextStyle(
      fontSize: 12,
      height: 16 / 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
    ),
  );

  /// Adds the font licence to the licence page. Call once before `runApp`.
  static void registerLicense() {
    LicenseRegistry.addLicense(() async* {
      final text = await rootBundle.loadString('assets/fonts/OFL.txt');
      yield LicenseEntryWithLineBreaks(const [fontFamily], text);
    });
  }
}
