import 'dart:math' as math;

import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/core/app_format.dart';
import 'package:izin_planla/ui/core/theme/app_colors.dart';
import 'package:izin_planla/ui/core/theme/app_radius.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/core/widgets/week_strip_day.dart';
import 'package:material_ui/material_ui.dart';

/// A row of day tiles, for example a bridge suggestion: workdays, leave
/// days, holidays and weekend each have their own colour and icon.
///
/// The tile width comes from the widest measured weekday name and day
/// number at the current text size. When the tiles do not fit in one row,
/// the strip continues on the next line, so no word is ever split.
class WeekStrip extends StatelessWidget {
  /// Creates a strip of [days] in the given order.
  const new({required this.days, super.key});

  /// Days to show, usually consecutive.
  final List<WeekStripDay> days;

  static const double _gap = AppSpacing.xs;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final minTile = _DayTile.minWidth(context, days);
      final count = math.max(days.length, 1);
      final perRow = math.max(
        1,
        math.min(
          count,
          ((constraints.maxWidth + _gap) / (minTile + _gap)).floor(),
        ),
      );
      final tileWidth = (constraints.maxWidth - _gap * (perRow - 1)) / perRow;
      return Wrap(
        spacing: _gap,
        runSpacing: _gap,
        children: [
          for (final day in days)
            SizedBox(
              width: tileWidth,
              child: _DayTile(day: day),
            ),
        ],
      );
    },
  );
}

class _DayTile extends StatelessWidget {
  const new({required this.day});

  final WeekStripDay day;

  /// Space between the tile edge and its text.
  static const double _horizontalPadding = AppSpacing.xs;

  static TextStyle? _weekdayStyle(TextTheme text) =>
      text.labelMedium?.copyWith(fontWeight: FontWeight.w600);

  static TextStyle? _dayStyle(TextTheme text) =>
      text.titleMedium?.copyWith(fontWeight: FontWeight.w700);

  /// Smallest tile width that keeps every weekday name and day number of
  /// [days] on one line at the current text size.
  static double minWidth(BuildContext context, List<WeekStripDay> days) {
    final locale = Localizations.localeOf(context).toString();
    final text = Theme.of(context).textTheme;
    final textScaler = MediaQuery.textScalerOf(context);
    var widest = 0.0;
    for (final day in days) {
      for (final (label, style) in [
        (AppFormat.weekdayShort(day.date, locale), _weekdayStyle(text)),
        (AppFormat.dayOfMonth(day.date, locale), _dayStyle(text)),
      ]) {
        final painter = TextPainter(
          text: TextSpan(text: label, style: style),
          textDirection: TextDirection.ltr,
          textScaler: textScaler,
        )..layout();
        widest = math.max(widest, painter.width);
        painter.dispose();
      }
    }
    return widest.ceilToDouble() + _horizontalPadding * 2;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final text = Theme.of(context).textTheme;
    final colors = AppColors.of(context).forMeaning(day.meaning);
    return Semantics(
      container: true,
      label: l10n.coreWeekStripDaySemantics(
        AppFormat.longDate(day.date, locale),
        day.meaning.label(l10n),
      ),
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: ShapeDecoration(color: colors.fill, shape: AppShapes.tile),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sm,
            horizontal: _horizontalPadding,
          ),
          child: Column(
            children: [
              Text(
                AppFormat.weekdayShort(day.date, locale),
                style: _weekdayStyle(text)?.copyWith(color: colors.accent),
              ),
              Text(
                AppFormat.dayOfMonth(day.date, locale),
                style: _dayStyle(text)?.copyWith(color: colors.accent),
              ),
              const SizedBox(height: AppSpacing.xs),
              Icon(day.meaning.icon, size: 16, color: colors.accent),
            ],
          ),
        ),
      ),
    );
  }
}
