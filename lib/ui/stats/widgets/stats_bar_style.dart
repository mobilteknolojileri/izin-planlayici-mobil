import 'package:izin_planla/ui/core/theme/app_colors.dart';
import 'package:material_ui/material_ui.dart';

/// How the two bar kinds look. Earned is an outlined bar, used a solid
/// bar, so they differ without colour too.
@immutable
class StatsBarStyle {
  /// Creates the style from the theme colours.
  new of(BuildContext context)
    : earnedFill = AppColors.of(context).remaining.fill,
      earnedBorder = AppColors.of(context).remaining.accent,
      used = AppColors.of(context).used.accent;

  /// Fill of an earned bar.
  final Color earnedFill;

  /// Outline of an earned bar, at least 3:1 against the card.
  final Color earnedBorder;

  /// Fill of a used bar, at least 3:1 against the card.
  final Color used;

  /// Outline width of an earned bar.
  static const double borderWidth = 2;
}
