import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/calendar/view_models/calendar_data.dart';
import 'package:izin_planla/ui/calendar/view_models/calendar_state.dart';
import 'package:izin_planla/ui/calendar/view_models/calendar_view_mode.dart';
import 'package:izin_planla/ui/calendar/view_models/calendar_view_model.dart';
import 'package:izin_planla/ui/calendar/widgets/calendar_day_details.dart';
import 'package:izin_planla/ui/calendar/widgets/calendar_month_card.dart';
import 'package:izin_planla/ui/calendar/widgets/calendar_year_card.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/core/theme/meaning.dart';
import 'package:izin_planla/ui/core/widgets/inset_card.dart';
import 'package:izin_planla/ui/core/widgets/large_title_page.dart';
import 'package:izin_planla/ui/core/widgets/legend_row.dart';
import 'package:izin_planla/ui/leave_form/widgets/leave_form_screen.dart';
import 'package:material_ui/material_ui.dart';

/// Calendar tab: holidays, eves, leave and bridge suggestions in a month or
/// year view, with the legend always under the calendar. A tap shows the
/// day's details, a range opens the leave form.
class CalendarScreen extends ConsumerWidget {
  /// Creates the screen.
  const new({super.key});

  /// Meanings that can appear on the calendar, in legend order.
  static const List<Meaning> legend = [
    Meaning.holiday,
    Meaning.eve,
    Meaning.used,
    Meaning.planned,
    Meaning.bridge,
    Meaning.weekend,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(calendarViewModelProvider);
    final viewModel = ref.read(calendarViewModelProvider.notifier);
    final text = Theme.of(context).textTheme;
    final List<Widget> children;
    switch (state.data) {
      case AsyncValue(value: final data?):
        children = _content(context, state, data, viewModel);
      case AsyncValue(error: _?):
        children = [
          InsetCard(summary: Text(l10n.calendarError, style: text.bodyLarge)),
        ];
      case _:
        children = [
          Center(
            child: CircularProgressIndicator(
              semanticsLabel: l10n.calendarLoading,
            ),
          ),
        ];
    }
    return LargeTitlePage(
      title: l10n.calendarTitle,
      // Seven 48 dp day columns fit a 360 dp phone with this padding.
      horizontalPadding: AppSpacing.smd,
      children: children,
    );
  }

  List<Widget> _content(
    BuildContext context,
    CalendarState state,
    CalendarData data,
    CalendarViewModel viewModel,
  ) {
    final l10n = AppLocalizations.of(context);
    final month = state.mode == CalendarViewMode.month;
    return [
      Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          ChoiceChip(
            label: Text(l10n.calendarViewMonth),
            selected: month,
            onSelected: (_) => viewModel.showMonth(),
          ),
          ChoiceChip(
            label: Text(l10n.calendarViewYear),
            selected: !month,
            onSelected: (_) => viewModel.showYear(),
          ),
          if (month)
            FilterChip(
              label: Text(l10n.calendarRangeMode),
              selected: state.rangeMode,
              onSelected: (_) => viewModel.toggleRangeMode(),
            ),
          if (data.hasManyPeople)
            FilterChip(
              label: Text(l10n.calendarEveryone),
              selected: state.everyone,
              onSelected: (_) => viewModel.toggleEveryone(),
            ),
        ],
      ),
      const SizedBox(height: AppSpacing.md),
      if (month)
        CalendarMonthCard(
          state: state,
          data: data,
          onDaySelected: viewModel.selectDay,
          onRangeSelected: viewModel.selectRange,
          onMonthChanged: viewModel.focusMonth,
          onPrevious: viewModel.previous,
          onNext: viewModel.next,
        )
      else
        CalendarYearCard(
          state: state,
          data: data,
          onOpenMonth: viewModel.openMonth,
          onPrevious: viewModel.previous,
          onNext: viewModel.next,
        ),
      const SizedBox(height: AppSpacing.smd),
      const InsetCard(child: LegendRow(meanings: legend)),
      if (month) ...[
        const SizedBox(height: AppSpacing.smd),
        CalendarDayDetails(
          state: state,
          data: data,
          onAddLeave: (start, end) => _addLeave(context, start, end),
        ),
      ],
    ];
  }

  void _addLeave(BuildContext context, DateTime start, DateTime end) => context
      .push<void>(LeaveFormScreen.location(start: start, end: end))
      .ignore();
}
