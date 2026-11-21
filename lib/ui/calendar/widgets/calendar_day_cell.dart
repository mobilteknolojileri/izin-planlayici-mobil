import 'package:izin_planla/ui/calendar/view_models/calendar_day.dart';
import 'package:izin_planla/ui/calendar/widgets/calendar_cell_selection.dart';
import 'package:izin_planla/ui/core/theme/app_colors.dart';
import 'package:izin_planla/ui/core/theme/app_radius.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/core/theme/meaning.dart';
import 'package:material_ui/material_ui.dart';

/// One day of the month grid: the day number in the colour of its meaning
/// and the meaning's icon, so colour never carries the meaning alone.
///
/// Decorative for screen readers: table_calendar labels the tile with its
/// date, and the month card adds the meaning and the selected state.
class CalendarDayCell extends StatelessWidget {
  /// Creates a tile for [day].
  const new({
    required this.day,
    required this.outside,
    this.selection = CalendarCellSelection.none,
    super.key,
  });

  /// The day and its meaning.
  final CalendarDay day;

  /// Whether the day belongs to the previous or next month.
  final bool outside;

  /// Selection state of the tile.
  final CalendarCellSelection selection;

  /// Space between the tile edge and the day number pill.
  static const double pillPadding = AppSpacing.xs;

  /// Space around the tile inside its grid cell.
  static const double margin = AppSpacing.xs / 2;

  /// Space between the day number and the icon.
  static const double iconGap = AppSpacing.xs / 2;

  /// Size of the meaning icon.
  static const double iconSize = 14;

  /// Style of the day number.
  static TextStyle? numberStyle(TextTheme text) =>
      text.titleSmall?.copyWith(fontWeight: FontWeight.w700);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = AppColors.of(context).forMeaning(day.meaning);
    final plain = outside || day.meaning == Meaning.workday;
    final foreground = outside
        ? scheme.onSurfaceVariant
        : plain
        ? scheme.onSurface
        : colors.accent;
    final number = Text(
      '${day.date.day}',
      softWrap: false,
      textAlign: TextAlign.center,
      style: numberStyle(theme.textTheme)
          ?.copyWith(color: day.isToday ? scheme.onPrimary : foreground),
    );
    final side = switch (selection) {
      CalendarCellSelection.none => BorderSide.none,
      CalendarCellSelection.edge => BorderSide(
        color: scheme.onSurface,
        width: 2.5,
      ),
      CalendarCellSelection.inside => BorderSide(
        color: scheme.onSurface,
        width: 1.5,
      ),
    };
    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.all(margin),
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: plain ? null : colors.fill,
            shape: RoundedSuperellipseBorder(
              borderRadius: AppRadius.small,
              side: side,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (day.isToday)
                DecoratedBox(
                  decoration: ShapeDecoration(
                    color: scheme.primary,
                    shape: const StadiumBorder(),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: pillPadding,
                    ),
                    child: number,
                  ),
                )
              else
                number,
              if (!plain) ...[
                const SizedBox(height: iconGap),
                Icon(day.meaning.icon, size: iconSize, color: foreground),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
