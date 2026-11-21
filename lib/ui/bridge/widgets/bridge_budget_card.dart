import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/bridge/view_models/bridge_content.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/core/theme/color_groups.dart';
import 'package:izin_planla/ui/core/widgets/inset_card.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

/// How many leave days the suggestions may use, with minus and plus
/// buttons. Starts at the days left.
class BridgeBudgetCard extends StatelessWidget {
  /// Creates the card.
  const new({
    required this.content,
    required this.onDecrease,
    required this.onIncrease,
    super.key,
  });

  /// Loaded content with the budget and the days left.
  final BridgeContent content;

  /// Called by the minus button.
  final VoidCallback onDecrease;

  /// Called by the plus button.
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final color = theme.colorScheme.primary;
    return InsetCard(
      header: CardHeader(
        tint: AppTint.green,
        icon: LucideIcons.wallet,
        title: l10n.bridgeBudgetTitle,
      ),
      summary: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.sm,
            children: [
              Semantics(
                liveRegion: true,
                child: Text(
                  l10n.coreDays(content.budget.toDouble()),
                  style: text.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton.filledTonal(
                    onPressed: content.budget > BridgeContent.minBudget
                        ? onDecrease
                        : null,
                    tooltip: l10n.bridgeBudgetDecrease,
                    color: color,
                    icon: const Icon(LucideIcons.minus),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton.filledTonal(
                    onPressed: content.budget < content.maxBudget
                        ? onIncrease
                        : null,
                    tooltip: l10n.bridgeBudgetIncrease,
                    color: color,
                    icon: const Icon(LucideIcons.plus),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${l10n.bridgeBudgetRemaining(content.remaining)} '
            '${l10n.bridgeBudgetHint}',
            style: text.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
