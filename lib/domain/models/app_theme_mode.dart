/// Theme choice of the user. Kept separate from Flutter's `ThemeMode` so the
/// domain layer stays pure Dart.
enum AppThemeMode {
  /// Follow the system setting.
  system,

  /// Always light.
  light,

  /// Always dark.
  dark,
}
