import 'package:material_ui/material_ui.dart';

/// Animation durations and curves. Animations are short and only explain a
/// change, see `docs/tasarim.md`.
abstract final class AppMotion {
  /// 150 ms, small state changes such as a selected tile.
  static const short = Duration(milliseconds: 150);

  /// 250 ms, a chart or card appearing.
  static const medium = Duration(milliseconds: 250);

  /// 400 ms, the balance ring filling up.
  static const long = Duration(milliseconds: 400);

  /// Curve for elements entering the screen.
  static const Curve enter = Easing.emphasizedDecelerate;

  /// Curve for elements changing in place.
  static const Curve standard = Easing.standard;

  /// [duration], or zero when the user turned animations off in the system
  /// settings. Reduced motion means no motion, not slower motion.
  static Duration resolve(BuildContext context, Duration duration) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : duration;
}
