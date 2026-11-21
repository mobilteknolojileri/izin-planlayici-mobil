import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:izin_planla/ui/core/theme/app_motion.dart';
import 'package:izin_planla/ui/core/theme/app_radius.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/stats/widgets/stats_bar_group.dart';
import 'package:izin_planla/ui/stats/widgets/stats_bar_style.dart';
import 'package:material_ui/material_ui.dart';

/// A bar chart of earned and used days, drawn by fl_chart in the theme's
/// colours.
///
/// Screen readers hear [semanticsLabel] instead of the bars, so the caller
/// shows the values as text next to the chart. Column labels that do not
/// fit at the current text size are thinned out, the text rows keep every
/// value.
class StatsBarChart extends StatelessWidget {
  /// Creates the chart.
  const new({required this.groups, required this.semanticsLabel, super.key});

  /// Columns from left to right.
  final List<StatsBarGroup> groups;

  /// What the chart shows, in one sentence.
  final String semanticsLabel;

  static const double _plotHeight = 160;
  static const double _barWidth = 12;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final style = StatsBarStyle.of(context);
    final labelStyle = theme.textTheme.bodySmall?.copyWith(
      color: scheme.onSurfaceVariant,
    );
    final scaler = MediaQuery.textScalerOf(context);
    final top = groups.fold<double>(
      1,
      (top, group) => math.max(top, math.max(group.used, group.earned ?? 0)),
    );
    final labelSize = _measure(
      [for (final group in groups) group.label],
      labelStyle,
      scaler,
    );
    final reserved = labelSize.height + AppSpacing.sm;
    return Semantics(
      container: true,
      image: true,
      label: semanticsLabel,
      child: ExcludeSemantics(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final slot = constraints.maxWidth / math.max(groups.length, 1);
            final step = math.max(
              1,
              ((labelSize.width + AppSpacing.xs) / slot).ceil(),
            );
            return SizedBox(
              height: _plotHeight + reserved,
              child: BarChart(
                duration: AppMotion.resolve(context, AppMotion.medium),
                curve: AppMotion.standard,
                BarChartData(
                  maxY: top * 1.15,
                  alignment: BarChartAlignment.spaceAround,
                  barTouchData: const BarTouchData(enabled: false),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) =>
                        FlLine(color: scheme.outlineVariant, strokeWidth: 1),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(),
                    rightTitles: const AxisTitles(),
                    topTitles: const AxisTitles(),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: reserved,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index % step != 0 ||
                              index < 0 ||
                              index >= groups.length) {
                            return const SizedBox.shrink();
                          }
                          return SideTitleWidget(
                            meta: meta,
                            space: AppSpacing.xs,
                            child: Text(
                              groups[index].label,
                              softWrap: false,
                              style: labelStyle,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: [
                    for (final (index, group) in groups.indexed)
                      BarChartGroupData(
                        x: index,
                        barsSpace: AppSpacing.xs,
                        barRods: [
                          if (group.earned case final earned?)
                            BarChartRodData(
                              toY: earned,
                              width: _barWidth,
                              color: style.earnedFill,
                              borderSide: BorderSide(
                                color: style.earnedBorder,
                                width: StatsBarStyle.borderWidth,
                              ),
                              borderRadius: BorderRadius.vertical(
                                top: AppRadius.small.topLeft,
                              ),
                            ),
                          BarChartRodData(
                            toY: group.used,
                            width: _barWidth,
                            color: style.used,
                            borderRadius: BorderRadius.vertical(
                              top: AppRadius.small.topLeft,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static Size _measure(
    List<String> labels,
    TextStyle? style,
    TextScaler scaler,
  ) {
    var width = 0.0;
    var height = 0.0;
    for (final label in labels) {
      final painter = TextPainter(
        text: TextSpan(text: label, style: style),
        textDirection: TextDirection.ltr,
        textScaler: scaler,
      )..layout();
      width = math.max(width, painter.width);
      height = math.max(height, painter.height);
      painter.dispose();
    }
    return Size(width, height);
  }
}
