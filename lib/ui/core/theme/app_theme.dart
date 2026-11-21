import 'package:izin_planla/ui/core/theme/app_colors.dart';
import 'package:izin_planla/ui/core/theme/app_palette.dart';
import 'package:izin_planla/ui/core/theme/app_radius.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/core/theme/app_typography.dart';
import 'package:material_ui/material_ui.dart';

/// Light and dark themes of the app: iOS style grouped surfaces with a royal
/// blue accent, built on Material components.
///
/// Both colour schemes are written by hand instead of `ColorScheme.fromSeed`,
/// so every role is a known colour and the contrast tests cover it.
abstract final class AppTheme {
  /// Light theme.
  static final ThemeData light = _build(_lightScheme, AppColors.light);

  /// Dark theme.
  static final ThemeData dark = _build(_darkScheme, AppColors.dark);

  static const _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppPalette.blue37,
    onPrimary: AppPalette.grey100,
    primaryContainer: AppPalette.blue91,
    onPrimaryContainer: AppPalette.blue20,
    secondary: AppPalette.grey31,
    onSecondary: AppPalette.grey100,
    secondaryContainer: AppPalette.grey92,
    onSecondaryContainer: AppPalette.blue37,
    tertiary: AppPalette.purple42,
    onTertiary: AppPalette.grey100,
    tertiaryContainer: AppPalette.purple93,
    onTertiaryContainer: AppPalette.purple21,
    error: AppPalette.red45,
    onError: AppPalette.grey100,
    errorContainer: AppPalette.red93,
    onErrorContainer: AppPalette.red30,
    surface: AppPalette.grey96,
    onSurface: AppPalette.grey00,
    onSurfaceVariant: AppPalette.grey39,
    surfaceDim: AppPalette.grey91,
    surfaceBright: AppPalette.grey100,
    surfaceContainerLowest: AppPalette.grey100,
    surfaceContainerLow: AppPalette.grey100,
    surfaceContainer: AppPalette.grey100,
    surfaceContainerHigh: AppPalette.grey100,
    surfaceContainerHighest: AppPalette.grey92,
    outline: AppPalette.grey52,
    outlineVariant: AppPalette.grey91,
    shadow: AppPalette.grey00,
    scrim: AppPalette.grey00,
    inverseSurface: AppPalette.grey10,
    onInverseSurface: AppPalette.grey96,
    inversePrimary: AppPalette.blue73,
    surfaceTint: AppPalette.blue37,
  );

  static const _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppPalette.blue64,
    onPrimary: AppPalette.grey00,
    primaryContainer: AppPalette.blue21,
    onPrimaryContainer: AppPalette.blue91,
    secondary: AppPalette.grey80,
    onSecondary: AppPalette.grey00,
    secondaryContainer: AppPalette.grey18,
    onSecondaryContainer: AppPalette.blue73,
    tertiary: AppPalette.purple57,
    onTertiary: AppPalette.grey00,
    tertiaryContainer: AppPalette.purple18,
    onTertiaryContainer: AppPalette.purple93,
    error: AppPalette.red58,
    onError: AppPalette.grey00,
    errorContainer: AppPalette.red15,
    onErrorContainer: AppPalette.red80,
    surface: AppPalette.grey00,
    onSurface: AppPalette.grey100,
    onSurfaceVariant: AppPalette.grey66,
    surfaceDim: AppPalette.grey00,
    surfaceBright: AppPalette.grey18,
    surfaceContainerLowest: AppPalette.grey00,
    surfaceContainerLow: AppPalette.grey10,
    surfaceContainer: AppPalette.grey10,
    surfaceContainerHigh: AppPalette.grey18,
    surfaceContainerHighest: AppPalette.grey21,
    outline: AppPalette.grey59,
    outlineVariant: AppPalette.grey24,
    shadow: AppPalette.grey00,
    scrim: AppPalette.grey00,
    inverseSurface: AppPalette.grey96,
    onInverseSurface: AppPalette.grey10,
    inversePrimary: AppPalette.blue37,
    surfaceTint: AppPalette.blue64,
  );

  /// Minimum size of the main buttons, above the 48 dp touch target.
  static const _buttonMinSize = Size(64, 56);

  static ThemeData _build(ColorScheme scheme, AppColors colors) {
    final base = ThemeData(
      colorScheme: scheme,
      fontFamily: AppTypography.fontFamily,
      textTheme: AppTypography.textTheme,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
    );
    final text = base.textTheme;
    const buttonPadding = EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.smd,
    );
    final buttonText = text.titleMedium?.copyWith(fontWeight: FontWeight.w700);
    // Cards sit on the grouped background: white in the light theme, the
    // raised grey in the dark theme.
    final cardColor = scheme.brightness == Brightness.light
        ? scheme.surfaceContainerLowest
        : scheme.surfaceContainerLow;
    return base.copyWith(
      extensions: [colors],
      scaffoldBackgroundColor: scheme.surface,
      cardColor: cardColor,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: scheme.surface,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: cardColor,
        surfaceTintColor: cardColor,
        shape: AppShapes.card,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: _buttonMinSize,
          padding: buttonPadding,
          textStyle: buttonText,
          shape: const StadiumBorder(),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: _buttonMinSize,
          padding: buttonPadding,
          textStyle: buttonText,
          shape: const StadiumBorder(),
          side: BorderSide(color: scheme.outline),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size.square(AppSpacing.xxl),
          textStyle: text.labelLarge,
          shape: const StadiumBorder(),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        surfaceTintColor: scheme.surfaceContainerHigh,
        shape: AppShapes.extraLarge,
        titleTextStyle: text.headlineSmall?.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: text.bodyLarge?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: text.bodyLarge?.copyWith(
          color: scheme.onInverseSurface,
        ),
        actionTextColor: scheme.inversePrimary,
        shape: AppShapes.large,
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        space: 1,
        thickness: 1,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.onSurfaceVariant,
        titleTextStyle: text.bodyLarge?.copyWith(color: scheme.onSurface),
        subtitleTextStyle: text.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        border: const OutlineInputBorder(
          borderRadius: AppRadius.medium,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.medium,
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.surfaceContainerHighest,
        linearMinHeight: 6,
        borderRadius: const BorderRadius.all(Radius.circular(3)),
      ),
    );
  }
}
