import 'dart:math' as math;

import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/calendar/view_models/calendar_data.dart';
import 'package:izin_planla/ui/calendar/view_models/calendar_state.dart';
import 'package:izin_planla/ui/calendar/widgets/calendar_cell_selection.dart';
import 'package:izin_planla/ui/calendar/widgets/calendar_date_format.dart';
import 'package:izin_planla/ui/calendar/widgets/calendar_day_cell.dart';
import 'package:izin_planla/ui/calendar/widgets/calendar_day_text.dart';
import 'package:izin_planla/ui/calendar/widgets/calendar_period_header.dart';
import 'package:izin_planla/ui/core/theme/app_motion.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:table_calendar/table_calendar.dart';

/// The month grid with its header. Taps select a day or, in range mode, the
/// first and last day of a new leave.
///
/// Day numbers and weekday names grow with the system text until they no
/// longer fit their column. Above that they stop growing, and the day
/// details below the grid show the same words at full size.
class CalendarMonthCard extends StatelessWidget {
  /// Creates the card.
  const new({
    required this.state,
    required this.data,
    required this.onDaySelected,
    required this.onRangeSelected,
    required this.onMonthChanged,
    required this.onPrevious,
    required this.onNext,
    super.key,
  });

  /// Screen state with the focused month and the selection.
  final CalendarState state;

  /// Loaded calendar data.
  final CalendarData data;

  /// Called with the tapped day outside range mode.
  final ValueChanged<DateTime> onDaySelected;

  /// Called with the range picked so far.
  final void Function(DateTime? start, DateTime? end) onRangeSelected;

  /// Called after a swipe to another month.
  final ValueChanged<DateTime> onMonthChanged;

  /// Called by the previous month button.
  final VoidCallback onPrevious;

  /// Called by the next month button.
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CalendarPeriodHeader(
              title: CalendarDateFormat.monthYear(state.focusedMonth, locale),
              previousLabel: l10n.calendarPreviousMonth,
              nextLabel: l10n.calendarNextMonth,
              onPrevious: state.canGoBack ? onPrevious : null,
              onNext: state.canGoForward ? onNext : null,
            ),
            LayoutBuilder(
              builder: (context, constraints) =>
                  _grid(context, constraints.maxWidth),
            ),
          ],
        ),
      ),
    );
  }

  Widget _grid(BuildContext context, double width) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final userScaler = MediaQuery.textScalerOf(context);
    final cellWidth = width / DateTime.daysPerWeek;
    final weekdayStyle = text.labelMedium?.copyWith(
      color: scheme.onSurfaceVariant,
      fontWeight: FontWeight.w600,
    );
    final numberStyle = CalendarDayCell.numberStyle(text);
    // A week of dates, Monday first, to measure the weekday names.
    final monday = DateTime.utc(2024);
    final week = [for (var i = 0; i < 7; i++) monday.add(Duration(days: i))];
    final labelRoom = cellWidth - CalendarDayCell.margin * 2;
    final shortWidth = _widest([
      for (final day in week) CalendarDateFormat.weekdayShort(day, locale),
    ], weekdayStyle);
    final useShort = shortWidth <= labelRoom;
    String weekdayName(DateTime day) => useShort
        ? CalendarDateFormat.weekdayShort(day, locale)
        : CalendarDateFormat.weekdayNarrow(day, locale);
    final labelWidth = useShort
        ? shortWidth
        : _widest([for (final day in week) weekdayName(day)], weekdayStyle);
    final numberRoom =
        cellWidth - (CalendarDayCell.margin + CalendarDayCell.pillPadding) * 2;
    final numberWidth = _widest([
      for (var day = 10; day <= 31; day++) '$day',
    ], numberStyle);
    final weekdayScaler = userScaler.clamp(
      maxScaleFactor: math.max(1, labelRoom / labelWidth),
    );
    final cellScaler = userScaler.clamp(
      maxScaleFactor: math.max(1, numberRoom / numberWidth),
    );
    final numberHeight = _height(numberStyle, cellScaler);
    final rowHeight = math.max(
      AppSpacing.xxl + CalendarDayCell.margin * 2,
      numberHeight +
          CalendarDayCell.iconGap +
          CalendarDayCell.iconSize +
          (CalendarDayCell.margin + AppSpacing.xs) * 2,
    );
    final weekdayHeight = _height(weekdayStyle, weekdayScaler) + AppSpacing.sm;
    final today = data.today;
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    Widget cell(DateTime date, DateTime focused) {
      final day = data.dayAt(date, everyone: state.everyone);
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: cellScaler),
        child: CalendarDayCell(
          day: day,
          outside: date.month != focused.month,
          selection: _selectionOf(day.date),
        ),
      );
    }

    // table_calendar labels each tile with its date only and hides the
    // tile's own semantics. This empty marker adds what the day holds, so
    // the screen reader hears the date, then the meaning.
    Widget meaning(DateTime date) {
      final day = data.dayAt(date, everyone: state.everyone);
      return Semantics(
        button: true,
        selected: _selectionOf(day.date) != CalendarCellSelection.none,
        label: CalendarDayText.details(l10n, locale, day),
        child: const SizedBox.shrink(),
      );
    }

    return TableCalendar<Object>(
      locale: locale,
      focusedDay: state.focusedMonth,
      firstDay: state.firstDay,
      lastDay: state.lastDay,
      currentDay: today,
      startingDayOfWeek: StartingDayOfWeek.monday,
      headerVisible: false,
      sixWeekMonthsEnforced: true,
      availableCalendarFormats: const {CalendarFormat.month: ''},
      availableGestures: AvailableGestures.horizontalSwipe,
      rowHeight: rowHeight,
      daysOfWeekHeight: weekdayHeight,
      pageAnimationEnabled: !disableAnimations,
      pageAnimationDuration: AppMotion.medium,
      pageAnimationCurve: AppMotion.standard,
      rangeSelectionMode: state.rangeMode
          ? RangeSelectionMode.toggledOn
          : RangeSelectionMode.toggledOff,
      rangeStartDay: state.rangeStart,
      rangeEndDay: state.rangeEnd,
      selectedDayPredicate: (day) =>
          !state.rangeMode && isSameDay(day, state.selectedDay),
      onDaySelected: (selected, _) => onDaySelected(selected),
      onRangeSelected: (start, end, _) => onRangeSelected(start, end),
      onPageChanged: onMonthChanged,
      calendarStyle: const CalendarStyle(cellMargin: EdgeInsets.zero),
      calendarBuilders: CalendarBuilders(
        prioritizedBuilder: (context, date, focused) => cell(date, focused),
        markerBuilder: (context, date, _) => meaning(date),
        dowBuilder: (context, day) => ExcludeSemantics(
          child: Center(
            child: Text(
              weekdayName(day),
              softWrap: false,
              textScaler: weekdayScaler,
              style: weekdayStyle,
            ),
          ),
        ),
      ),
    );
  }

  CalendarCellSelection _selectionOf(DateTime day) {
    if (!state.rangeMode) {
      return day == state.selectedDay
          ? CalendarCellSelection.edge
          : CalendarCellSelection.none;
    }
    final start = state.rangeStart;
    final end = state.rangeEnd;
    if (day == start || day == end) return CalendarCellSelection.edge;
    if (start != null &&
        end != null &&
        day.isAfter(start) &&
        day.isBefore(end)) {
      return CalendarCellSelection.inside;
    }
    return CalendarCellSelection.none;
  }

  static double _widest(List<String> labels, TextStyle? style) {
    var widest = 0.0;
    for (final label in labels) {
      final painter = TextPainter(
        text: TextSpan(text: label, style: style),
        textDirection: TextDirection.ltr,
      )..layout();
      widest = math.max(widest, painter.width);
      painter.dispose();
    }
    return widest;
  }

  static double _height(TextStyle? style, TextScaler scaler) {
    final painter = TextPainter(
      text: TextSpan(text: '0', style: style),
      textDirection: TextDirection.ltr,
      textScaler: scaler,
    )..layout();
    final height = painter.height;
    painter.dispose();
    return height.ceilToDouble();
  }
}
