import 'package:izin_planla/ui/core/theme/app_colors.dart';
import 'package:izin_planla/ui/core/theme/app_radius.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/core/theme/color_groups.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

/// Header of a card: a small coloured icon square and the title, as in the
/// iOS Health cards. Shows a chevron when the card opens another screen.
class CardHeader extends StatelessWidget {
  /// Creates the header.
  const new({
    required this.tint,
    required this.icon,
    required this.title,
    this.chevron = false,
    super.key,
  });

  /// Colour of the icon square and the title.
  final AppTint tint;

  /// Icon in the square.
  final IconData icon;

  /// Card title.
  final String title;

  /// Whether a chevron at the end says the card opens another screen.
  final bool chevron;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context).forTint(tint);
    final theme = Theme.of(context);
    return Row(
      children: [
        ExcludeSemantics(
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: colors.icon,
              shape: AppShapes.small,
            ),
            child: SizedBox.square(
              dimension: 30,
              child: Icon(icon, size: 18, color: colors.onIcon),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(color: colors.title),
          ),
        ),
        if (chevron)
          ExcludeSemantics(
            child: Icon(
              LucideIcons.chevronRight,
              size: 22,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}

/// A white card on the grouped background, the basic surface of every
/// screen.
///
/// With [onTap], the [header] and [summary] become one button that opens
/// another screen. The [child] below them stays outside the button, so its
/// own parts, such as day tiles, keep their own screen reader stops.
class InsetCard extends StatelessWidget {
  /// Creates the card.
  const new({this.header, this.summary, this.child, this.onTap, super.key})
    : assert(
        header != null || summary != null || child != null,
        'InsetCard needs content',
      );

  /// Optional header, usually a [CardHeader].
  final Widget? header;

  /// Optional main sentence under the header.
  final Widget? summary;

  /// Optional content under the summary.
  final Widget? child;

  /// Called when the header or summary is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final header = this.header;
    final summary = this.summary;
    final child = this.child;
    final onTap = this.onTap;
    final hasTop = header != null || summary != null;
    Widget? top;
    if (hasTop) {
      top = Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          child == null ? AppSpacing.md : AppSpacing.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ?header,
            if (header != null && summary != null)
              const SizedBox(height: AppSpacing.smd),
            ?summary,
          ],
        ),
      );
      if (onTap != null) {
        top = MergeSemantics(
          child: Semantics(
            button: true,
            child: InkWell(
              onTap: onTap,
              customBorder: child == null
                  ? AppShapes.card
                  : RoundedSuperellipseBorder(
                      borderRadius: BorderRadius.vertical(
                        top: AppRadius.card.topLeft,
                      ),
                    ),
              child: top,
            ),
          ),
        );
      }
    }
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ?top,
          if (child != null)
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md,
                hasTop ? AppSpacing.sm : AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
              ),
              child: child,
            ),
        ],
      ),
    );
  }
}
