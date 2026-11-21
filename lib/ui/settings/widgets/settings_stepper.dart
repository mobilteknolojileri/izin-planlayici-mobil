import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

/// A value with minus and plus buttons, such as "8 saat". The buttons move
/// under the value when the text is large.
class SettingsStepper extends StatelessWidget {
  /// Creates the stepper. A null callback disables its button.
  const new({
    required this.value,
    required this.decreaseTooltip,
    required this.increaseTooltip,
    required this.onDecrease,
    required this.onIncrease,
    super.key,
  });

  /// The current value, already formatted.
  final String value;

  /// Tooltip of the minus button.
  final String decreaseTooltip;

  /// Tooltip of the plus button.
  final String increaseTooltip;

  /// Called by the minus button.
  final VoidCallback? onDecrease;

  /// Called by the plus button.
  final VoidCallback? onIncrease;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      children: [
        Semantics(
          liveRegion: true,
          child: Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton.filledTonal(
              onPressed: onDecrease,
              tooltip: decreaseTooltip,
              color: color,
              icon: const Icon(LucideIcons.minus),
            ),
            const SizedBox(width: AppSpacing.sm),
            IconButton.filledTonal(
              onPressed: onIncrease,
              tooltip: increaseTooltip,
              color: color,
              icon: const Icon(LucideIcons.plus),
            ),
          ],
        ),
      ],
    );
  }
}
