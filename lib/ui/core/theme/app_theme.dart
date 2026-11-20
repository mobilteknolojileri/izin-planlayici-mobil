import 'package:material_ui/material_ui.dart';

/// Temporary light and dark themes. Task 06 replaces this file with the
/// project's own colour tokens.
abstract final class AppTheme {
  static const _seed = Color(0xFF2F6F62);

  /// Light theme.
  static ThemeData get light => ThemeData(colorSchemeSeed: _seed);

  /// Dark theme.
  static ThemeData get dark =>
      ThemeData(colorSchemeSeed: _seed, brightness: Brightness.dark);
}
