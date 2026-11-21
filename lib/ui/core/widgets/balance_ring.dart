import 'dart:math' as math;

import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/core/theme/app_colors.dart';
import 'package:izin_planla/ui/core/theme/app_motion.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/core/theme/color_groups.dart';
import 'package:izin_planla/ui/core/theme/meaning.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

/// How a ring segment is drawn. Each part of the balance has its own style,
/// so the segments stay apart without colour.
enum _Style {
  /// One continuous band: what is left.
  solid,

  /// Thin ticks across the band, like a segmented gauge: days already
  /// spent.
  ticked,

  /// Outline only: days planned but not taken yet.
  hollow,
}

/// The three parts of an annual leave balance, in ring order.
const List<(Meaning, _Style)> _parts = [
  (Meaning.remaining, _Style.solid),
  (Meaning.used, _Style.ticked),
  (Meaning.planned, _Style.hollow),
];

/// Ring colour of [meaning] on the hero card.
Color _ringColor(HeroColors hero, Meaning meaning) => switch (meaning) {
  Meaning.used => hero.ringUsed,
  Meaning.planned => hero.ringPlanned,
  _ => hero.ringRemaining,
};

/// Width of the outline of a hollow segment or swatch.
const double _outline = 2.5;

/// Ring chart of the annual leave balance: remaining, used and planned
/// days. Remaining is a solid band, used is a row of ticks and planned is
/// an outline, the same marks as in [BalanceLegend], so the parts stay apart
/// without colour. A glass disc with a calendar icon fills the centre.
///
/// Drawn for the hero card (`BigNumberCard`), its colours come from
/// `AppColors.hero`. Screen readers hear one sentence with all three
/// numbers.
class BalanceRing extends StatelessWidget {
  /// Creates the ring. A negative [remaining] draws no remaining segment.
  const new({
    required this.remaining,
    required this.used,
    required this.planned,
    this.size = 112,
    super.key,
  });

  /// Days still available.
  final double remaining;

  /// Days already taken.
  final double used;

  /// Days planned for the future.
  final double planned;

  /// Diameter in logical pixels.
  final double size;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hero = AppColors.of(context).hero;
    final values = [remaining, used, planned];
    return Semantics(
      container: true,
      label: l10n.coreBalanceRingSemantics(remaining, used, planned),
      child: SizedBox.square(
        dimension: size,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: AppMotion.resolve(context, AppMotion.long),
          curve: AppMotion.enter,
          builder: (context, progress, child) => CustomPaint(
            painter: _RingPainter(
              segments: [
                for (final (index, (meaning, style)) in _parts.indexed)
                  (
                    math.max(0, values[index]).toDouble(),
                    _ringColor(hero, meaning),
                    style,
                  ),
              ],
              track: hero.ringTrack,
              disc: hero.onHero.withValues(alpha: 0.12),
              highlight: hero.onHero,
              progress: progress,
            ),
            child: child,
          ),
          child: Center(
            child: Icon(
              LucideIcons.calendarDays,
              size: size * 0.24,
              color: hero.onHero,
            ),
          ),
        ),
      ),
    );
  }
}

/// Legend of [BalanceRing]: one chip per part with the same colour and
/// mark as its segment, and the number of days.
class BalanceLegend extends StatelessWidget {
  /// Creates the legend.
  const new({
    required this.remaining,
    required this.used,
    required this.planned,
    super.key,
  });

  /// Days still available.
  final double remaining;

  /// Days already taken.
  final double used;

  /// Days planned for the future.
  final double planned;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hero = AppColors.of(context).hero;
    final text = Theme.of(context).textTheme;
    final values = [remaining, used, planned];
    // Opaque, so its contrast is known: the hero text over the lighter
    // gradient end.
    final chip = Color.alphaBlend(
      hero.onHero.withValues(alpha: 0.12),
      hero.top,
    );
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final (index, (meaning, style)) in _parts.indexed)
          DecoratedBox(
            decoration: ShapeDecoration(
              color: chip,
              shape: const StadiumBorder(),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xs,
                AppSpacing.xs,
                AppSpacing.smd,
                AppSpacing.xs,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ExcludeSemantics(
                    child: SizedBox.square(
                      dimension: 24,
                      child: CustomPaint(
                        painter: _SwatchPainter(
                          _ringColor(hero, meaning),
                          style,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: Text(
                      '${meaning.label(l10n)} '
                      '${l10n.coreDays(values[index])}',
                      style: text.labelLarge?.copyWith(color: hero.onHero),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// A small sample of one segment style: a dot, three ticks or an outline.
class _SwatchPainter extends CustomPainter {
  const new(this.color, this.style);

  final Color color;
  final _Style style;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    switch (style) {
      case _Style.solid:
        canvas.drawCircle(center, radius, Paint()..color = color);
      case _Style.ticked:
        const width = 4.0;
        final paint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = width
          ..strokeCap = StrokeCap.round
          ..color = color;
        for (final dx in [-6.5, 0.0, 6.5]) {
          final x = center.dx + dx;
          // Shorter outer ticks keep the sample round.
          final reach = dx == 0 ? radius - width / 2 : radius * 0.62;
          canvas.drawLine(
            Offset(x, center.dy - reach),
            Offset(x, center.dy + reach),
            paint,
          );
        }
      case _Style.hollow:
        canvas
          ..drawCircle(
            center,
            radius - _outline / 2,
            Paint()..color = color.withValues(alpha: 0.22),
          )
          ..drawCircle(
            center,
            radius - _outline / 2,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = _outline
              ..color = color,
          );
    }
  }

  @override
  bool shouldRepaint(_SwatchPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.style != style;
}

class _RingPainter extends CustomPainter {
  new({
    required this.segments,
    required this.track,
    required this.disc,
    required this.highlight,
    required this.progress,
  });

  /// Value, colour and style of each segment.
  final List<(double, Color, _Style)> segments;

  /// Full circle under the segments.
  final Color track;

  /// Fill of the centre disc.
  final Color disc;

  /// The lighter end of the solid segment's gradient.
  final Color highlight;

  /// Animation progress from 0 to 1.
  final double progress;

  /// Band width as a share of the diameter.
  static const _strokeShare = 0.15;

  /// Angle between two segments, on top of the round caps.
  static const _gap = 0.14;

  /// Width of one tick and of the space after it, in logical pixels.
  static const _tick = 3.5;
  static const _tickGap = 3.5;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.shortestSide * _strokeShare;
    final radius = size.shortestSide / 2 - stroke / 2;
    final center = size.center(Offset.zero);
    final ring = Rect.fromCircle(center: center, radius: radius);

    canvas
      ..drawCircle(
        center,
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..color = track,
      )
      ..drawCircle(center, radius - stroke * 0.95, Paint()..color = disc);

    final total = segments.fold<double>(0, (sum, s) => sum + s.$1);
    if (total <= 0) return;
    final visible = segments.where((s) => s.$1 > 0).toList();
    // Round caps reach past the arc ends, the gap leaves room for them.
    final cap = stroke / 2 / radius;
    final gap = visible.length > 1 ? _gap : 0.0;
    var start = -math.pi / 2;
    for (final (value, color, style) in visible) {
      final sweep = value / total * 2 * math.pi * progress;
      // The band from the first cap's edge to the last cap's edge.
      final from = start + gap / 2;
      final to = start + sweep - gap / 2;
      if (to > from) {
        switch (style) {
          case _Style.solid:
            _solid(canvas, ring, from, to, cap, stroke, color);
          case _Style.ticked:
            _ticked(canvas, center, radius, from, to, stroke, color);
          case _Style.hollow:
            _hollow(canvas, center, radius, from, to, stroke, color);
        }
      }
      start += sweep;
    }
  }

  Paint _band(double stroke) => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = stroke
    ..strokeCap = StrokeCap.round;

  /// A continuous band that brightens along its length, with a soft glow.
  void _solid(
    Canvas canvas,
    Rect ring,
    double from,
    double to,
    double cap,
    double stroke,
    Color color,
  ) {
    final sweep = math.max(0.001, to - from - 2 * cap);
    final begin = from + cap;
    final lighter = Color.lerp(color, highlight, 0.45)!;
    canvas
      ..drawArc(
        ring,
        begin,
        sweep,
        false,
        _band(stroke)
          ..color = color.withValues(alpha: 0.35)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, stroke * 0.35),
      )
      ..drawArc(
        ring,
        begin,
        sweep,
        false,
        _band(stroke)
          ..shader = SweepGradient(
            endAngle: math.max(sweep, 0.01),
            colors: [color, lighter],
            transform: GradientRotation(begin),
          ).createShader(ring),
      );
  }

  /// Thin radial ticks across the band, evenly spread over the segment.
  void _ticked(
    Canvas canvas,
    Offset center,
    double radius,
    double from,
    double to,
    double stroke,
    Color color,
  ) {
    final length = (to - from) * radius;
    final count = math.max(
      1,
      ((length - _tick) / (_tick + _tickGap)).floor() + 1,
    );
    // Spread the ticks so the first and last sit on the segment ends.
    final step = count == 1 ? 0.0 : (length - _tick) / (count - 1) / radius;
    final first = from + _tick / 2 / radius;
    final inner = radius - stroke / 2 + _tick / 2;
    final outer = radius + stroke / 2 - _tick / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _tick
      ..strokeCap = StrokeCap.round
      ..color = color;
    for (var i = 0; i < count; i++) {
      final angle = first + i * step;
      final direction = Offset(math.cos(angle), math.sin(angle));
      canvas.drawLine(
        center + direction * inner,
        center + direction * outer,
        paint,
      );
    }
  }

  /// An outlined capsule with a faint fill.
  void _hollow(
    Canvas canvas,
    Offset center,
    double radius,
    double from,
    double to,
    double stroke,
    Color color,
  ) {
    final width = stroke - _outline;
    final capsule = _capsule(center, radius, width, from, to);
    canvas
      ..drawPath(capsule, Paint()..color = color.withValues(alpha: 0.22))
      ..drawPath(
        capsule,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = _outline
          ..color = color,
      );
  }

  /// Outline of the band between angles [from] and [to] with round ends.
  Path _capsule(
    Offset center,
    double radius,
    double width,
    double from,
    double to,
  ) {
    final half = width / 2;
    final cap = half / radius;
    final start = from + cap;
    final sweep = math.max(0.001, to - from - 2 * cap);
    final end = start + sweep;
    Offset at(double r, double angle) =>
        center + Offset(math.cos(angle) * r, math.sin(angle) * r);
    return Path()
      ..arcTo(
        Rect.fromCircle(center: center, radius: radius + half),
        start,
        sweep,
        true,
      )
      ..arcToPoint(at(radius - half, end), radius: Radius.circular(half))
      ..arcTo(
        Rect.fromCircle(center: center, radius: radius - half),
        end,
        -sweep,
        false,
      )
      ..arcToPoint(at(radius + half, start), radius: Radius.circular(half))
      ..close();
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) {
    if (oldDelegate.progress != progress ||
        oldDelegate.track != track ||
        oldDelegate.disc != disc ||
        oldDelegate.highlight != highlight) {
      return true;
    }
    if (oldDelegate.segments.length != segments.length) return true;
    for (var i = 0; i < segments.length; i++) {
      if (oldDelegate.segments[i] != segments[i]) return true;
    }
    return false;
  }
}
