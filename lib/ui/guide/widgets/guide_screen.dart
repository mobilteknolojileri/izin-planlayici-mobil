import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/core/theme/color_groups.dart';
import 'package:izin_planla/ui/core/widgets/inset_card.dart';
import 'package:izin_planla/ui/guide/view_models/guide_view_model.dart';
import 'package:izin_planla/ui/guide/widgets/guide_source_name.dart';
import 'package:izin_planla/ui/guide/widgets/guide_source_row.dart';
import 'package:izin_planla/ui/guide/widgets/guide_topic_card.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

/// Legislation guide: the annual leave rules of the labour law or the civil
/// servants law in plain words, each with its source, and the legal
/// disclaimer at the end.
class GuideScreen extends ConsumerWidget {
  /// Creates the screen.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(guideViewModelProvider);
    final viewModel = ref.read(guideViewModelProvider.notifier);
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final padding = MediaQuery.paddingOf(context);
    final laws = {
      EmploymentType.laborLaw: l10n.guideLaborLaw,
      EmploymentType.civilServant: l10n.guideCivilServant,
    };
    return Scaffold(
      appBar: AppBar(title: Text(l10n.guideTitle)),
      body: state.loading
          ? Center(
              child: CircularProgressIndicator(
                semanticsLabel: l10n.guideLoading,
              ),
            )
          : ListView(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.lg + padding.bottom,
              ),
              children: [
                Text(l10n.guideIntro, style: text.bodyLarge),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final MapEntry(key: law, value: label) in laws.entries)
                      ChoiceChip(
                        label: Text(label),
                        selected: state.law == law,
                        onSelected: (_) => viewModel.selectLaw(law),
                      ),
                  ],
                ),
                for (final topic in state.topics) ...[
                  const SizedBox(height: AppSpacing.smd),
                  GuideTopicCard(topic: topic, law: state.law),
                ],
                const SizedBox(height: AppSpacing.smd),
                InsetCard(
                  header: Semantics(
                    header: true,
                    child: CardHeader(
                      tint: AppTint.purple,
                      icon: LucideIcons.bookOpen,
                      title: l10n.guideSourcesTitle,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(l10n.guideSourcesChecked, style: text.bodyLarge),
                      const SizedBox(height: AppSpacing.sm),
                      for (final source in state.sources)
                        GuideSourceRow(
                          text: guideSourceName(l10n, source),
                          sourceName: guideSourceName(l10n, source),
                          source: source,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.smd),
                InsetCard(
                  header: Semantics(
                    header: true,
                    child: CardHeader(
                      tint: AppTint.orange,
                      icon: LucideIcons.scale,
                      title: l10n.guideDisclaimerTitle,
                    ),
                  ),
                  summary: Text(l10n.guideDisclaimer, style: text.bodyMedium),
                ),
              ],
            ),
    );
  }
}
