import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/bridge/view_models/bridge_item.dart';
import 'package:izin_planla/ui/core/app_format.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/core/theme/color_groups.dart';
import 'package:izin_planla/ui/core/widgets/inset_card.dart';
import 'package:izin_planla/ui/core/widgets/secondary_button.dart';
import 'package:izin_planla/ui/core/widgets/week_strip.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

/// One bridge suggestion: the holidays it joins, one sentence such as
/// "2 gün izinle 5 gün tatil, 20-24 Nisan", the days as a week strip and a
/// "Planla" button.
class BridgeSuggestionCard extends StatelessWidget {
  /// Creates the card.
  const new({required this.item, required this.onPlan, super.key});

  /// The suggestion and its days.
  final BridgeItem item;

  /// Called by the "Planla" button. Not called once the leave is planned.
  final VoidCallback onPlan;

  /// The main sentence of [item].
  static String sentence(
    AppLocalizations l10n,
    String locale,
    BridgeItem item,
  ) {
    final suggestion = item.suggestion;
    return l10n.bridgeSuggestionSentence(
      suggestion.leaveDaysUsed,
      suggestion.totalDaysOff,
      AppFormat.dayRange(suggestion.vacation, locale),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final title = item.holidayNames.isEmpty
        ? l10n.bridgeSuggestionWeekend
        : item.holidayNames.join(', ');
    return InsetCard(
      header: CardHeader(
        tint: AppTint.blue,
        icon: LucideIcons.treePalm,
        title: title,
      ),
      summary: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sentence(l10n, locale, item),
            style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          if (item.inPlan) ...[
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                ExcludeSemantics(
                  child: Icon(
                    LucideIcons.badgeCheck,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    l10n.bridgeInPlan,
                    style: text.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WeekStrip(days: item.days),
          const SizedBox(height: AppSpacing.md),
          SecondaryButton(
            label: item.planned
                ? l10n.bridgePlannedLabel
                : l10n.bridgePlanAction,
            icon: item.planned ? LucideIcons.check : LucideIcons.calendarPlus,
            onPressed: item.planned ? null : onPlan,
          ),
        ],
      ),
    );
  }
}
