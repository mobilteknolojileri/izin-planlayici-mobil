import 'package:izin_planla/ui/core/theme/app_colors.dart';
import 'package:izin_planla/ui/core/theme/app_radius.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

/// The main answer of a screen on the blue hero card: a title, one large
/// number, a short sentence and an optional "Nasıl hesaplandı?" row.
///
/// [trailing], usually a `BalanceRing`, sits next to the number and moves
/// under it when the system text is large. [footer], usually a
/// `BalanceLegend`, sits under the sentence. Every line is its own screen
/// reader stop.
class BigNumberCard extends StatelessWidget {
  /// Creates the card.
  const new({
    required this.title,
    required this.icon,
    required this.value,
    required this.unit,
    this.caption,
    this.trailing,
    this.footer,
    this.actionLabel,
    this.onAction,
    super.key,
  }) : assert(
         (actionLabel == null) == (onAction == null),
         'actionLabel and onAction go together',
       );

  /// Title above the number, such as "Kalan izin".
  final String title;

  /// Icon before the title.
  final IconData icon;

  /// The number, already formatted (`18`, `4,5`).
  final String value;

  /// Word after the number, such as "gün".
  final String unit;

  /// Optional sentence under the number.
  final String? caption;

  /// Optional graphic next to the number.
  final Widget? trailing;

  /// Optional content under the sentence.
  final Widget? footer;

  /// Label of the bottom row, such as "Nasıl hesaplandı?".
  final String? actionLabel;

  /// Called when the bottom row is tapped.
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final hero = AppColors.of(context).hero;
    final text = Theme.of(context).textTheme;
    final large = MediaQuery.textScalerOf(context).scale(10) > 13;
    final caption = this.caption;
    final trailing = this.trailing;
    final footer = this.footer;
    final actionLabel = this.actionLabel;
    final number = MergeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ExcludeSemantics(
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: hero.onHero.withValues(alpha: 0.14),
                    shape: AppShapes.small,
                  ),
                  child: SizedBox.square(
                    dimension: 32,
                    child: Icon(icon, size: 19, color: hero.onHero),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Flexible(
                child: Text(
                  title,
                  style: text.titleMedium?.copyWith(color: hero.onHero),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: text.displayLarge?.copyWith(color: hero.onHero),
                ),
                TextSpan(
                  text: ' $unit',
                  style: text.titleLarge?.copyWith(
                    color: hero.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [hero.top, hero.bottom],
          ),
          shape: AppShapes.card,
          shadows: [
            BoxShadow(
              color: hero.bottom.withValues(alpha: 0.35),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipPath(
          clipper: const ShapeBorderClipper(shape: AppShapes.card),
          child: CustomPaint(
            painter: _WavesPainter(
              shade: hero.bottom.withValues(alpha: 0.35),
              light: hero.wave,
            ),
            // Ink of the bottom row paints on this layer, above the waves.
            child: Material(
              type: MaterialType.transparency,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.mdl,
                      AppSpacing.md,
                      AppSpacing.mdl,
                      0,
                    ),
                    child: trailing == null
                        ? number
                        : large
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              number,
                              const SizedBox(height: AppSpacing.md),
                              trailing,
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: number),
                              trailing,
                            ],
                          ),
                  ),
                  if (caption != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.mdl,
                        AppSpacing.smd,
                        AppSpacing.mdl,
                        0,
                      ),
                      child: Text(
                        caption,
                        style: text.bodyLarge?.copyWith(color: hero.muted),
                      ),
                    ),
                  if (footer != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.mdl,
                        AppSpacing.md,
                        AppSpacing.mdl,
                        0,
                      ),
                      child: footer,
                    ),
                  if (actionLabel == null)
                    const SizedBox(height: AppSpacing.mdl)
                  else ...[
                    const SizedBox(height: AppSpacing.smd),
                    Divider(
                      height: 1,
                      indent: AppSpacing.mdl,
                      color: hero.onHero.withValues(alpha: 0.3),
                    ),
                    MergeSemantics(
                      child: Semantics(
                        button: true,
                        child: InkWell(
                          onTap: onAction,
                          customBorder: RoundedSuperellipseBorder(
                            borderRadius: BorderRadius.vertical(
                              bottom: AppRadius.card.bottomLeft,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              AppSpacing.mdl,
                              AppSpacing.md,
                              AppSpacing.md,
                              AppSpacing.md,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    actionLabel,
                                    style: text.bodyLarge?.copyWith(
                                      color: hero.onHero,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                ExcludeSemantics(
                                  child: Icon(
                                    LucideIcons.chevronRight,
                                    size: 22,
                                    color: hero.onHero,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Soft shapes behind the hero content: a shade sweeping up from the bottom
/// and a faint light band across the middle, for depth. The light band is
/// faint enough to keep the text contrast, `AppColors` tests check it.
class _WavesPainter extends CustomPainter {
  const new({required this.shade, required this.light});

  final Color shade;
  final Color light;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final shadePath = Path()
      ..moveTo(w * 0.2, h)
      ..cubicTo(w * 0.5, h * 0.8, w * 0.72, h * 0.58, w, h * 0.46)
      ..lineTo(w, h)
      ..close();
    final lightPath = Path()
      ..moveTo(0, h * 0.58)
      ..cubicTo(w * 0.3, h * 0.42, w * 0.62, h * 0.6, w, h * 0.2)
      ..lineTo(w, h * 0.34)
      ..cubicTo(w * 0.64, h * 0.74, w * 0.3, h * 0.56, 0, h * 0.72)
      ..close();
    canvas
      ..drawPath(shadePath, Paint()..color = shade)
      ..drawPath(lightPath, Paint()..color = light);
  }

  @override
  bool shouldRepaint(_WavesPainter oldDelegate) =>
      oldDelegate.shade != shade || oldDelegate.light != light;
}
