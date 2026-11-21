import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/routing/routes.dart';
import 'package:izin_planla/ui/bridge/view_models/bridge_content.dart';
import 'package:izin_planla/ui/bridge/view_models/bridge_item.dart';
import 'package:izin_planla/ui/bridge/view_models/bridge_sort.dart';
import 'package:izin_planla/ui/bridge/view_models/bridge_view_model.dart';
import 'package:izin_planla/ui/bridge/widgets/bridge_budget_card.dart';
import 'package:izin_planla/ui/bridge/widgets/bridge_suggestion_card.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/core/theme/meaning.dart';
import 'package:izin_planla/ui/core/widgets/big_number_card.dart';
import 'package:izin_planla/ui/core/widgets/empty_state.dart';
import 'package:izin_planla/ui/core/widgets/illustration.dart';
import 'package:izin_planla/ui/core/widgets/inset_card.dart';
import 'package:izin_planla/ui/core/widgets/large_title_page.dart';
import 'package:izin_planla/ui/core/widgets/legend_row.dart';
import 'package:izin_planla/ui/core/widgets/undo_snack_bar.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

/// Bridge tab: the best leave days of a year around holidays and weekends,
/// limited by a leave budget, with the yearly best plan and one-tap
/// planning.
class BridgeScreen extends ConsumerWidget {
  /// Creates the screen.
  const new({super.key});

  /// Meanings of the week strip tiles, in legend order.
  static const List<Meaning> legend = [
    Meaning.bridge,
    Meaning.holiday,
    Meaning.eve,
    Meaning.weekend,
    Meaning.workday,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(bridgeViewModelProvider);
    final viewModel = ref.read(bridgeViewModelProvider.notifier);
    final text = Theme.of(context).textTheme;
    final List<Widget> children;
    switch (state.content) {
      case AsyncValue(value: final content?):
        children = content.profile == null
            ? [
                EmptyState(
                  illustration: Illustration.bridgeEmpty,
                  message: l10n.bridgeNoProfileMessage,
                  actionLabel: l10n.bridgeNoProfileAction,
                  onAction: () => context.go(Routes.onboarding),
                ),
              ]
            : _content(context, content, state.sort, viewModel);
      case AsyncValue(error: _?):
        children = [
          InsetCard(summary: Text(l10n.bridgeError, style: text.bodyLarge)),
        ];
      case _:
        children = [
          Center(
            child: CircularProgressIndicator(
              semanticsLabel: l10n.bridgeLoading,
            ),
          ),
        ];
    }
    return LargeTitlePage(title: l10n.bridgeTitle, children: children);
  }

  List<Widget> _content(
    BuildContext context,
    BridgeContent content,
    BridgeSort sort,
    BridgeViewModel viewModel,
  ) {
    final l10n = AppLocalizations.of(context);
    final sorts = {
      BridgeSort.efficiency: l10n.bridgeSortEfficiency,
      BridgeSort.length: l10n.bridgeSortLength,
      BridgeSort.date: l10n.bridgeSortDate,
    };
    return [
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
        title: l10n.bridgePlanTitle(content.year),
        icon: LucideIcons.bridge,
        value: '${content.planTotalDays}',
        unit: l10n.bridgePlanUnit,
        caption: content.planCount == 0
            ? l10n.bridgePlanNone
            : l10n.bridgePlanCaption(content.planLeaveDays, content.planCount),
      ),
      const SizedBox(height: AppSpacing.smd),
      BridgeBudgetCard(
        content: content,
        onDecrease: viewModel.decreaseBudget,
        onIncrease: viewModel.increaseBudget,
      ),
      const SizedBox(height: AppSpacing.lg),
      if (content.items.isEmpty)
        EmptyState(
          illustration: Illustration.bridgeEmpty,
          message: l10n.bridgeEmptyMessage,
          actionLabel: l10n.bridgeEmptyAction,
          onAction: () => context.go(Routes.calendar),
        )
      else ...[
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final MapEntry(key: value, value: label) in sorts.entries)
              ChoiceChip(
                label: Text(label),
                selected: value == sort,
                onSelected: (_) => viewModel.selectSort(value),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        const InsetCard(child: LegendRow(meanings: legend)),
        for (final item in content.items) ...[
          const SizedBox(height: AppSpacing.smd),
          BridgeSuggestionCard(
            item: item,
            onPlan: () => _plan(context, viewModel, item),
          ),
        ],
      ],
    ];
  }

  Future<void> _plan(
    BuildContext context,
    BridgeViewModel viewModel,
    BridgeItem item,
  ) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final id = await viewModel.plan(item.suggestion);
    if (!context.mounted) return;
    if (id == null) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.bridgeFailedMessage)));
      return;
    }
    UndoSnackBar.show(
      context,
      message: l10n.bridgePlannedMessage,
      onUndo: () => viewModel.undoPlan(id).ignore(),
    );
  }
}
