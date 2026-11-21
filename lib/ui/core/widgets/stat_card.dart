import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/core/theme/color_groups.dart';
import 'package:izin_planla/ui/core/widgets/inset_card.dart';
import 'package:material_ui/material_ui.dart';

/// A card with one number under a tinted header, for example "Sıradaki
/// tatil, 42 gün kaldı, Yılbaşı, 1 Ocak". Two of them usually sit side by
/// side, the screen stacks them when the system text is large.
///
/// Screen readers hear the whole card as one sentence.
class StatCard extends StatelessWidget {
  /// Creates the card.
  const new({
    required this.tint,
    required this.icon,
    required this.title,
    required this.value,
    required this.unit,
    this.detail,
    super.key,
  });

  /// Colour of the header.
  final AppTint tint;

  /// Header icon.
  final IconData icon;

  /// Header title.
  final String title;

  /// The number, already formatted (`42`, `4,5`).
  final String value;

  /// Words after the number, on their own line ("gün kaldı").
  final String unit;

  /// Optional detail at the bottom of the card.
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final secondary = theme.colorScheme.onSurfaceVariant;
    final detail = this.detail;
    return MergeSemantics(
      child: InsetCard(
        header: CardHeader(tint: tint, icon: icon, title: title),
        summary: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.xs),
            Text(value, style: text.displaySmall),
            Text(
              unit,
              style: text.bodyLarge?.copyWith(
                color: secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (detail != null) ...[
              const SizedBox(height: AppSpacing.smd),
              Text(detail, style: text.bodyMedium?.copyWith(color: secondary)),
            ],
          ],
        ),
      ),
    );
  }
}
