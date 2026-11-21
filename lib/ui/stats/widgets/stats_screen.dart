import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/routing/routes.dart';
import 'package:izin_planla/ui/core/app_format.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/core/theme/color_groups.dart';
import 'package:izin_planla/ui/core/widgets/big_number_card.dart';
import 'package:izin_planla/ui/core/widgets/empty_state.dart';
import 'package:izin_planla/ui/core/widgets/illustration.dart';
import 'package:izin_planla/ui/core/widgets/inset_card.dart';
import 'package:izin_planla/ui/core/widgets/stat_card.dart';
import 'package:izin_planla/ui/leave_form/widgets/leave_texts.dart';
import 'package:izin_planla/ui/stats/view_models/stats_content.dart';
import 'package:izin_planla/ui/stats/view_models/stats_view_model.dart';
import 'package:izin_planla/ui/stats/widgets/stats_bar_chart.dart';
import 'package:izin_planla/ui/stats/widgets/stats_bar_group.dart';
import 'package:izin_planla/ui/stats/widgets/stats_legend.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

/// Statistics: days off of a year, earned and used leave per year, leave
/// per month and per type, for one person or everyone together. Every
/// chart has its values in words under it.
class StatsScreen extends ConsumerWidget {
  /// Creates the screen.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(statsViewModelProvider);
    final viewModel = ref.read(statsViewModelProvider.notifier);
    final text = Theme.of(context).textTheme;
    final Widget body;
    switch (state.content) {
      case AsyncValue(value: final content?) when !content.hasProfile:
        body = EmptyState(
          illustration: Illustration.statsEmpty,
          message: l10n.statsNoProfileMessage,
          actionLabel: l10n.statsNoProfileAction,
          onAction: () => context.go(Routes.onboarding),
        );
      case AsyncValue(value: final content?) when !content.hasLeaves:
        body = Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                0,
              ),
              child: _PeopleChips(content: content, viewModel: viewModel),
            ),
            Expanded(
              child: EmptyState(
                illustration: Illustration.statsEmpty,
                message: l10n.statsEmptyMessage,
                actionLabel: l10n.statsEmptyAction,
                onAction: () => context.push<void>(Routes.leaveForm).ignore(),
              ),
            ),
          ],
        );
      case AsyncValue(value: final content?):
        body = _Content(content: content, viewModel: viewModel);
      case AsyncValue(error: _?):
        body = Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: InsetCard(
            summary: Text(l10n.statsError, style: text.bodyLarge),
          ),
        );
      case _:
        body = Center(
          child: CircularProgressIndicator(semanticsLabel: l10n.statsLoading),
        );
    }
    return Scaffold(
      appBar: AppBar(title: Text(l10n.statsTitle)),
      body: body,
    );
  }
}

class _PeopleChips extends StatelessWidget {
  const new({required this.content, required this.viewModel});

  final StatsContent content;
  final StatsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (!content.hasManyPeople) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        ChoiceChip(
          label: Text(l10n.statsEveryone),
          selected: content.selectedProfileId == null,
          onSelected: (_) => viewModel.selectEveryone(),
        ),
        for (final profile in content.profiles)
          ChoiceChip(
            label: Text(profile.name),
            selected: content.selectedProfileId == profile.id,
            onSelected: (_) => viewModel.selectProfile(profile.id),
          ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  const new({required this.content, required this.viewModel});

  final StatsContent content;
  final StatsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final summary = content.summary;
    final everyone = content.selectedProfileId == null;
    // Side by side cards stack when the system text is large.
    final stack = MediaQuery.textScalerOf(context).scale(10) > 13;
    final cards = [
      StatCard(
        tint: AppTint.green,
        icon: LucideIcons.calendarPlus2,
        title: l10n.statsEarned,
        value: AppFormat.days(summary.earned, locale),
        unit: l10n.statsDaysUnit,
      ),
      StatCard(
        tint: AppTint.blue,
        icon: LucideIcons.circleCheck,
        title: l10n.statsUsed,
        value: AppFormat.days(summary.used, locale),
        unit: l10n.statsDaysUnit,
      ),
    ];
    final padding = MediaQuery.paddingOf(context);
    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.lg + padding.bottom,
      ),
      children: [
        if (content.hasManyPeople) ...[
          _PeopleChips(content: content, viewModel: viewModel),
          const SizedBox(height: AppSpacing.sm),
        ],
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final year in content.years)
              ChoiceChip(
                label: Text('$year'),
                selected: year == content.year,
                onSelected: (_) => viewModel.selectYear(year),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        BigNumberCard(
          title: l10n.statsDaysOffTitle(content.year),
          icon: LucideIcons.sun,
          value: '${summary.totalDaysOff}',
          unit: l10n.statsDaysUnit,
          caption: everyone
              ? l10n.statsDaysOffCaptionEveryone
              : l10n.statsDaysOffCaption,
        ),
        const SizedBox(height: AppSpacing.md),
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
        const SizedBox(height: AppSpacing.smd),
        _ByYearCard(content: content),
        const SizedBox(height: AppSpacing.smd),
        _ByMonthCard(content: content),
        const SizedBox(height: AppSpacing.smd),
        _ByTypeCard(content: content),
      ],
    );
  }
}

class _ByYearCard extends StatelessWidget {
  const new({required this.content});

  final StatsContent content;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return InsetCard(
      header: CardHeader(
        tint: AppTint.purple,
        icon: LucideIcons.chartColumn,
        title: l10n.statsByYearTitle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StatsBarChart(
            semanticsLabel: l10n.statsByYearChart,
            groups: [
              for (final summary in content.byYear)
                StatsBarGroup(
                  label: '${summary.year}',
                  earned: summary.earned,
                  used: summary.used,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.smd),
          StatsLegend(earnedLabel: l10n.statsEarned, usedLabel: l10n.statsUsed),
          const SizedBox(height: AppSpacing.smd),
          for (final summary in content.byYear.reversed)
            _ValueRow(
              text: l10n.statsByYearRow(
                summary.year,
                summary.earned,
                summary.used,
              ),
            ),
        ],
      ),
    );
  }
}

class _ByMonthCard extends StatelessWidget {
  const new({required this.content});

  final StatsContent content;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final byMonth = content.summary.usedByMonth;
    final months = [
      for (var month = 1; month <= 12; month++)
        DateTime.utc(content.year, month),
    ];
    final used = [
      for (final month in months)
        if ((byMonth[month.month] ?? 0) > 0) month,
    ];
    return InsetCard(
      header: CardHeader(
        tint: AppTint.purple,
        icon: LucideIcons.calendarRange,
        title: l10n.statsByMonthTitle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StatsBarChart(
            semanticsLabel: l10n.statsByMonthChart(content.year),
            groups: [
              for (final month in months)
                StatsBarGroup(
                  label: DateFormat.MMM(locale).format(month),
                  used: byMonth[month.month] ?? 0,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.smd),
          if (used.isEmpty)
            _ValueRow(text: l10n.statsByMonthEmpty(content.year))
          else
            for (final month in used)
              _ValueRow(
                text: l10n.statsByMonthRow(
                  DateFormat.MMMM(locale).format(month),
                  byMonth[month.month] ?? 0,
                ),
              ),
        ],
      ),
    );
  }
}

class _ByTypeCard extends StatelessWidget {
  const new({required this.content});

  final StatsContent content;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final entries =
        content.summary.usedByType.entries
            .where((entry) => entry.value > 0)
            .toList()
          ..sort((a, b) => b.value.compareTo(a.value));
    final top = entries.firstOrNull?.value ?? 1;
    return InsetCard(
      header: CardHeader(
        tint: AppTint.purple,
        icon: LucideIcons.chartBar,
        title: l10n.statsByTypeTitle,
      ),
      child: entries.isEmpty
          ? _ValueRow(text: l10n.statsByTypeEmpty(content.year))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final MapEntry(key: type, value: days) in entries)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xs,
                    ),
                    child: Semantics(
                      container: true,
                      label: l10n.statsByTypeRow(
                        LeaveTexts.typeLabel(l10n, type),
                        days,
                      ),
                      excludeSemantics: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            spacing: AppSpacing.sm,
                            children: [
                              Text(
                                LeaveTexts.typeLabel(l10n, type),
                                style: theme.textTheme.bodyLarge,
                              ),
                              Text(
                                l10n.coreDays(days),
                                style: theme.textTheme.titleSmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          LinearProgressIndicator(value: days / top),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _ValueRow extends StatelessWidget {
  const new({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
