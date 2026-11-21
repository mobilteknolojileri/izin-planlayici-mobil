import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/core/theme/meaning.dart';
import 'package:izin_planla/ui/core/widgets/meaning_tile.dart';
import 'package:material_ui/material_ui.dart';

/// What each mark means. Always visible under a calendar or chart.
class LegendRow extends StatelessWidget {
  /// Creates a legend of [meanings] in the given order.
  const new({required this.meanings, super.key});

  /// Meanings that appear on the calendar or chart above.
  final List<Meaning> meanings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Semantics(
      container: true,
      label: l10n.coreLegendSemantics,
      child: Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.sm,
        children: [
          for (final meaning in meanings)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                MeaningTile(meaning: meaning, width: 28, height: 28),
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(meaning.label(l10n), style: text.bodyMedium),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
