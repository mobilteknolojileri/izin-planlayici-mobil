import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/routing/routes.dart';
import 'package:izin_planla/ui/core/app_format.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/core/theme/color_groups.dart';
import 'package:izin_planla/ui/core/theme/meaning.dart';
import 'package:izin_planla/ui/core/widgets/empty_state.dart';
import 'package:izin_planla/ui/core/widgets/illustration.dart';
import 'package:izin_planla/ui/core/widgets/inset_card.dart';
import 'package:izin_planla/ui/core/widgets/large_title_page.dart';
import 'package:izin_planla/ui/core/widgets/meaning_tile.dart';
import 'package:izin_planla/ui/core/widgets/primary_button.dart';
import 'package:izin_planla/ui/core/widgets/secondary_button.dart';
import 'package:izin_planla/ui/core/widgets/stat_card.dart';
import 'package:izin_planla/ui/leave_form/widgets/leave_form_screen.dart';
import 'package:izin_planla/ui/leave_form/widgets/leave_texts.dart';
import 'package:izin_planla/ui/leaves/view_models/leave_list_item.dart';
import 'package:izin_planla/ui/leaves/view_models/leaves_section.dart';
import 'package:izin_planla/ui/leaves/view_models/leaves_state.dart';
import 'package:izin_planla/ui/leaves/view_models/leaves_view_model.dart';
import 'package:izin_planla/ui/leaves/widgets/overtime_sheet.dart';
import 'package:izin_planla/ui/people/widgets/option_list.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

/// Leaves tab: planned and used leave of one year, filtered by type, and a
/// second part for hourly leave and overtime.
class LeavesScreen extends ConsumerWidget {
  /// Creates the screen.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(leavesViewModelProvider);
    final viewModel = ref.read(leavesViewModelProvider.notifier);
    return LargeTitlePage(
      title: l10n.leavesTitle,
      children: switch (state) {
        LeavesLoading() => [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Center(
              child: CircularProgressIndicator(
                semanticsLabel: l10n.leavesLoading,
              ),
            ),
          ),
        ],
        LeavesError() => [
          InsetCard(
            summary: Text(l10n.leavesErrorMessage),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(
                onPressed: viewModel.retry,
                child: Text(l10n.leavesRetry),
              ),
            ),
          ),
        ],
        LeavesNoProfile() => [
          EmptyState(
            illustration: Illustration.onboardingEmployment,
            message: l10n.leavesNoProfileMessage,
            actionLabel: l10n.leavesNoProfileAction,
            onAction: () => unawaited(context.push(Routes.onboarding)),
          ),
        ],
        final LeavesReady ready => _readyChildren(context, ready, viewModel),
      },
    );
  }

  List<Widget> _readyChildren(
    BuildContext context,
    LeavesReady state,
    LeavesViewModel viewModel,
  ) {
    final l10n = AppLocalizations.of(context);
    final hours = state.section == LeavesSection.hours;
    void addLeave() => unawaited(context.push(Routes.leaveForm));
    return [
      _SectionSwitch(
        selected: state.section,
        onSelected: viewModel.selectSection,
      ),
      const SizedBox(height: AppSpacing.md),
      if (!hours && !state.hasAnyLeave)
        EmptyState(
          illustration: Illustration.leavesEmpty,
          message: l10n.leavesEmptyMessage,
          actionLabel: l10n.leavesAdd,
          onAction: addLeave,
        )
      else ...[
        _Filters(state: state, viewModel: viewModel),
        const SizedBox(height: AppSpacing.md),
        if (hours) ...[
          PrimaryButton(
            label: l10n.leavesAddOvertime,
            icon: LucideIcons.plus,
            onPressed: () =>
                unawaited(OvertimeSheet.show(context, today: state.today)),
          ),
          const SizedBox(height: AppSpacing.md),
          _HoursPart(state: state),
        ] else ...[
          PrimaryButton(
            label: l10n.leavesAdd,
            icon: LucideIcons.plus,
            onPressed: addLeave,
          ),
          const SizedBox(height: AppSpacing.md),
          _LeavesPart(state: state),
        ],
      ],
    ];
  }
}

/// Switch between the leaves and the hours part, as two capsules.
class _SectionSwitch extends StatelessWidget {
  const new({required this.selected, required this.onSelected});

  final LeavesSection selected;
  final ValueChanged<LeavesSection> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    // Both capsules take the height of the taller label.
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (index, section) in LeavesSection.values.indexed) ...[
            if (index > 0) const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Semantics(
                inMutuallyExclusiveGroup: true,
                selected: section == selected,
                button: true,
                child: Material(
                  color: section == selected
                      ? scheme.primary
                      : scheme.surfaceContainerHighest,
                  shape: const StadiumBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => onSelected(section),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: AppSpacing.xxl,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.smd,
                          vertical: AppSpacing.sm,
                        ),
                        child: Center(
                          child: Text(
                            switch (section) {
                              LeavesSection.leaves => l10n.leavesTabLeaves,
                              LeavesSection.hours => l10n.leavesTabHours,
                            },
                            textAlign: TextAlign.center,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: section == selected
                                  ? scheme.onPrimary
                                  : scheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Year and type filter buttons, each opening a list of choices.
class _Filters extends StatelessWidget {
  const new({required this.state, required this.viewModel});

  final LeavesState state;
  final LeavesViewModel viewModel;

  Future<T?> _choose<T>(
    BuildContext context, {
    required String title,
    required List<T> values,
    required T selected,
    required String Function(T value) label,
  }) => showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            header: true,
            child: Text(title, style: Theme.of(context).textTheme.titleLarge),
          ),
          const SizedBox(height: AppSpacing.smd),
          OptionList<T>(
            values: values,
            selected: selected,
            title: label,
            onSelected: (value) => Navigator.of(context).pop(value),
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = this.state;
    if (state is! LeavesReady) return const SizedBox.shrink();
    String typeLabel(LeaveType? type) =>
        type == null ? l10n.leavesTypeAll : LeaveTexts.typeLabel(l10n, type);
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        SecondaryButton(
          label: l10n.leavesYearFilter(state.year),
          icon: LucideIcons.calendarDays,
          expand: false,
          onPressed: () async {
            final year = await _choose<int>(
              context,
              title: l10n.leavesYearSheetTitle,
              values: state.years,
              selected: state.year,
              label: (year) => '$year',
            );
            if (year != null) viewModel.selectYear(year);
          },
        ),
        if (state.section == LeavesSection.leaves)
          SecondaryButton(
            label: l10n.leavesTypeFilter(typeLabel(state.type)),
            icon: LucideIcons.listFilter,
            expand: false,
            onPressed: () async {
              // Choices are numbered: 0 is every type, a sheet closed
              // without a choice returns null.
              final types = state.types;
              final choice = await _choose<int>(
                context,
                title: l10n.leavesTypeSheetTitle,
                values: [for (var i = 0; i <= types.length; i++) i],
                selected: switch (state.type) {
                  null => 0,
                  final type => types.indexOf(type) + 1,
                },
                label: (i) => typeLabel(i == 0 ? null : types[i - 1]),
              );
              if (choice != null) {
                viewModel.selectType(choice == 0 ? null : types[choice - 1]);
              }
            },
          ),
      ],
    );
  }
}

class _LeavesPart extends StatelessWidget {
  const new({required this.state});

  final LeavesReady state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (state.planned.isEmpty && state.used.isEmpty) {
      return InsetCard(
        summary: Text(
          l10n.leavesNoMatch,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (state.planned.isNotEmpty)
          _Group(
            title: l10n.leavesPlannedHeader,
            children: [for (final item in state.planned) _LeaveRow(item: item)],
          ),
        if (state.planned.isNotEmpty && state.used.isNotEmpty)
          const SizedBox(height: AppSpacing.lg),
        if (state.used.isNotEmpty)
          _Group(
            title: l10n.leavesUsedHeader,
            children: [for (final item in state.used) _LeaveRow(item: item)],
          ),
      ],
    );
  }
}

class _HoursPart extends StatelessWidget {
  const new({required this.state});

  final LeavesReady state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final stack = MediaQuery.textScalerOf(context).scale(10) > 13;
    final cards = [
      StatCard(
        tint: AppTint.purple,
        icon: LucideIcons.timer,
        title: l10n.leavesOvertimeTitle,
        value: AppFormat.days(state.overtimeTotal, locale),
        unit: l10n.leavesHourUnit,
      ),
      StatCard(
        tint: AppTint.blue,
        icon: LucideIcons.clock,
        title: l10n.leavesHourlyTitle,
        value: AppFormat.days(state.hourlyTotal, locale),
        unit: l10n.leavesHourUnit,
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (stack) ...[
          cards[0],
          const SizedBox(height: AppSpacing.smd),
          cards[1],
        ] else
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: cards[0]),
                const SizedBox(width: AppSpacing.smd),
                Expanded(child: cards[1]),
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.lg),
        if (state.overtime.isEmpty && state.hourly.isEmpty)
          InsetCard(
            summary: Text(
              l10n.leavesHoursEmpty,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        if (state.overtime.isNotEmpty)
          _Group(
            title: l10n.leavesOvertimeHeader,
            children: [
              for (final record in state.overtime)
                _OvertimeRow(record: record, today: state.today),
            ],
          ),
        if (state.overtime.isNotEmpty && state.hourly.isNotEmpty)
          const SizedBox(height: AppSpacing.lg),
        if (state.hourly.isNotEmpty)
          _Group(
            title: l10n.leavesHourlyHeader,
            children: [for (final item in state.hourly) _LeaveRow(item: item)],
          ),
      ],
    );
  }
}

/// A heading and a card of rows separated by lines.
class _Group extends StatelessWidget {
  const new({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Semantics(
        header: true,
        child: Text(title, style: Theme.of(context).textTheme.titleLarge),
      ),
      const SizedBox(height: AppSpacing.sm),
      Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (index, child) in children.indexed) ...[
              if (index > 0) const Divider(indent: AppSpacing.md),
              child,
            ],
          ],
        ),
      ),
    ],
  );
}

/// One leave: its mark, type, dates and cost. Opens the form on tap.
class _LeaveRow extends StatelessWidget {
  const new({required this.item});

  final LeaveListItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final record = item.record;
    final deducted = item.deducted;
    final hours = record.hours;
    final amount = switch (record.unit) {
      LeaveUnit.hours => l10n.leavesHours(hours ?? 0),
      LeaveUnit.halfDay => l10n.coreDayHalfCounted,
      LeaveUnit.days when deducted != null => l10n.coreDays(deducted),
      LeaveUnit.days => l10n.leavesCalendarDays(record.range.dayCount),
    };
    return _Row(
      leading: MeaningTile(
        meaning: item.planned ? Meaning.planned : Meaning.used,
      ),
      lines: [
        LeaveTexts.recordLabel(l10n, record),
        AppFormat.dayRange(record.range, locale),
        amount,
      ],
      onTap: () =>
          unawaited(context.push(LeaveFormScreen.location(leaveId: record.id))),
    );
  }
}

/// One overtime record. Opens the overtime sheet on tap.
class _OvertimeRow extends StatelessWidget {
  const new({required this.record, required this.today});

  final OvertimeRecord record;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final note = record.note;
    return _Row(
      leading: ExcludeSemantics(
        child: Icon(
          LucideIcons.timer,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      lines: [
        AppFormat.longDate(record.date, locale),
        l10n.leavesHours(record.hours),
        ?note,
      ],
      onTap: () =>
          unawaited(OvertimeSheet.show(context, today: today, record: record)),
    );
  }
}

/// A tappable list row: a mark, a bold first line, quieter lines under it
/// and a chevron. Screen readers hear it as one button.
class _Row extends StatelessWidget {
  const new({required this.leading, required this.lines, required this.onTap});

  final Widget leading;
  final List<String> lines;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final secondary = theme.colorScheme.onSurfaceVariant;
    return MergeSemantics(
      child: Semantics(
        button: true,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.smd,
            ),
            child: Row(
              children: [
                leading,
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final (index, line) in lines.indexed)
                        Text(
                          line,
                          style: index == 0
                              ? text.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                )
                              : text.bodyMedium?.copyWith(color: secondary),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                ExcludeSemantics(
                  child: Icon(LucideIcons.chevronRight, color: secondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
