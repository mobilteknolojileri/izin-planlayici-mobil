import 'package:izin_planla/ui/core/theme/app_radius.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/stats/widgets/stats_bar_style.dart';
import 'package:material_ui/material_ui.dart';

/// What the earned and used bars look like. Decorative for screen
/// readers, the rows under the chart say the values in words.
class StatsLegend extends StatelessWidget {
  /// Creates the legend.
  const new({
    required this.earnedLabel,
    required this.usedLabel,
    this.showEarned = true,
    super.key,
  });

  /// Label of the earned swatch.
  final String earnedLabel;

  /// Label of the used swatch.
  final String usedLabel;

  /// Whether the earned swatch is shown.
  final bool showEarned;

  @override
  Widget build(BuildContext context) {
    final style = StatsBarStyle.of(context);
    final text = Theme.of(context).textTheme;
    Widget entry(String label, Color fill, Color? border) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: ShapeDecoration(
            color: fill,
            shape: RoundedSuperellipseBorder(
              borderRadius: AppRadius.small,
              side: border == null
                  ? BorderSide.none
                  : BorderSide(color: border, width: StatsBarStyle.borderWidth),
            ),
          ),
          child: const SizedBox.square(dimension: AppSpacing.mdl),
        ),
        const SizedBox(width: AppSpacing.sm),
        Flexible(child: Text(label, style: text.bodyMedium)),
      ],
    );
    return ExcludeSemantics(
      child: Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.sm,
        children: [
          if (showEarned)
            entry(earnedLabel, style.earnedFill, style.earnedBorder),
          entry(usedLabel, style.used, null),
        ],
      ),
    );
  }
}
