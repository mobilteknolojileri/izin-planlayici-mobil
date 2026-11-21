import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/calendar/view_models/calendar_data.dart';
import 'package:izin_planla/ui/calendar/view_models/calendar_month_summary.dart';
import 'package:izin_planla/ui/calendar/view_models/calendar_state.dart';
import 'package:izin_planla/ui/calendar/widgets/calendar_date_format.dart';
import 'package:izin_planla/ui/calendar/widgets/calendar_period_header.dart';
import 'package:izin_planla/ui/core/theme/app_colors.dart';
import 'package:izin_planla/ui/core/theme/app_radius.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/core/theme/meaning.dart';
import 'package:izin_planla/ui/core/widgets/meaning_pattern_painter.dart';
import 'package:material_ui/material_ui.dart';

/// The twelve months of the focused year. Each month is a button with a
/// small picture of its days and a sentence that says the same in words.
class CalendarYearCard extends StatelessWidget {
  /// Creates the year view.
  const new({
    required this.state,
    required this.data,
    required this.onOpenMonth,
    required this.onPrevious,
    required this.onNext,
    super.key,
  });

  /// Screen state with the focused year.
  final CalendarState state;

  /// Loaded calendar data.
  final CalendarData data;

  /// Called with the first day of the tapped month.
  final ValueChanged<DateTime> onOpenMonth;

  /// Called by the previous year button.
  final VoidCallback onPrevious;

  /// Called by the next year button.
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final year = state.focusedMonth.year;
    final months = [
      for (var month = 1; month <= 12; month++)
        _MonthTile(
          data: data,
          summary: data.summaryOf(
            DateTime.utc(year, month),
            everyone: state.everyone,
          ),
          everyone: state.everyone,
          onTap: () => onOpenMonth(DateTime.utc(year, month)),
        ),
    ];
    // Two months side by side, one under the other when the text is large.
    final columns = MediaQuery.textScalerOf(context).scale(10) > 13 ? 1 : 2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: CalendarPeriodHeader(
            title: '$year',
            previousLabel: l10n.calendarPreviousYear,
            nextLabel: l10n.calendarNextYear,
            onPrevious: state.canGoBack ? onPrevious : null,
            onNext: state.canGoForward ? onNext : null,
          ),
        ),
        for (var i = 0; i < months.length; i += columns) ...[
          const SizedBox(height: AppSpacing.smd),
          if (columns == 1)
            months[i]
          else
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: months[i]),
                  const SizedBox(width: AppSpacing.smd),
                  Expanded(child: months[i + 1]),
                ],
              ),
            ),
        ],
      ],
    );
  }
}

class _MonthTile extends StatelessWidget {
  const new({
    required this.data,
    required this.summary,
    required this.everyone,
    required this.onTap,
  });

  final CalendarData data;
  final CalendarMonthSummary summary;
  final bool everyone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final theme = Theme.of(context);
    final month = summary.month;
    final parts = [
      if (summary.holidayDays > 0)
        l10n.calendarMonthHolidays(summary.holidayDays),
      if (summary.leaveDays > 0) l10n.calendarMonthLeaves(summary.leaveDays),
      if (summary.bridgeDays > 0) l10n.calendarMonthBridges(summary.bridgeDays),
    ];
    final text = parts.isEmpty ? l10n.calendarMonthNothing : parts.join(', ');
    final name = CalendarDateFormat.month(month, locale);
    final length = DateTime.utc(month.year, month.month + 1, 0).day;
    final meanings = [
      for (var day = 1; day <= length; day++)
        data
            .dayAt(
              DateTime.utc(month.year, month.month, day),
              everyone: everyone,
            )
            .meaning,
    ];
    return Semantics(
      button: true,
      label: l10n.calendarMonthSemantics(
        CalendarDateFormat.monthYear(month, locale),
        text,
      ),
      excludeSemantics: true,
      child: Card(
        child: InkWell(
          onTap: onTap,
          customBorder: AppShapes.card,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                AspectRatio(
                  aspectRatio: 7 / 6,
                  child: CustomPaint(
                    painter: _MiniMonthPainter(
                      offset: month.weekday - DateTime.monday,
                      meanings: meanings,
                      colors: AppColors.of(context),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  text,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Paints a month as a grid of small squares, Monday first. Marked days get
/// their meaning's fill, pattern and border, so the picture reads without
/// colour too.
class _MiniMonthPainter extends CustomPainter {
  const new({
    required this.offset,
    required this.meanings,
    required this.colors,
  });

  /// Empty squares before the first day.
  final int offset;

  /// Meaning of every day of the month, in order.
  final List<Meaning> meanings;

  final AppColors colors;

  static const double _gap = AppSpacing.xs / 2;

  @override
  void paint(Canvas canvas, Size size) {
    final side = (size.width - _gap * 6) / 7;
    final radius = Radius.circular(AppRadius.small.topLeft.x / 3);
    for (final (index, meaning) in meanings.indexed) {
      final slot = index + offset;
      final rect = Rect.fromLTWH(
        (slot % 7) * (side + _gap),
        (slot ~/ 7) * (side + _gap),
        side,
        side,
      );
      final rrect = RRect.fromRectAndRadius(rect, radius);
      final pair = colors.forMeaning(meaning);
      canvas.drawRRect(rrect, Paint()..color = pair.fill);
      if (meaning == Meaning.workday) continue;
      canvas
        ..save()
        ..clipRRect(rrect);
      MeaningPatternPainter.paintPattern(
        canvas,
        rect,
        meaning.pattern,
        pair.accent,
      );
      canvas
        ..restore()
        ..drawRRect(
          rrect.deflate(0.5),
          Paint()
            ..style = PaintingStyle.stroke
            ..color = pair.accent,
        );
    }
  }

  @override
  bool shouldRepaint(_MiniMonthPainter oldDelegate) =>
      oldDelegate.offset != offset ||
      oldDelegate.colors != colors ||
      !_sameMeanings(oldDelegate.meanings, meanings);

  static bool _sameMeanings(List<Meaning> a, List<Meaning> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
