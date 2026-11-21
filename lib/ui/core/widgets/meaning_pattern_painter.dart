import 'package:izin_planla/ui/core/theme/meaning_colors.dart';
import 'package:izin_planla/ui/core/theme/meaning_pattern.dart';
import 'package:material_ui/material_ui.dart';

/// Paints a rounded mark: fill colour, [pattern] in the accent colour and an
/// accent border.
///
/// Colours are passed in, the painter never reads the theme.
class MeaningPatternPainter extends CustomPainter {
  /// Creates a painter for one mark.
  const new({
    required this.pattern,
    required this.colors,
    required this.radius,
  });

  /// Pattern drawn over the fill.
  final MeaningPattern pattern;

  /// Fill and accent colours.
  final MeaningColors colors;

  /// Corner radius of the mark.
  final double radius;

  /// Opacity of pattern lines, so the fill colour still shows through.
  static const patternAlpha = 0.55;

  static const _border = 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    canvas
      ..drawRRect(rrect, Paint()..color = colors.fill)
      ..save()
      ..clipRRect(rrect);
    paintPattern(canvas, rect, pattern, colors.accent);
    canvas
      ..restore()
      ..drawRRect(
        rrect.deflate(_border / 2),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = _border
          ..color = colors.accent,
      );
  }

  /// Paints [pattern] in [accent] over [rect]. The caller clips the canvas.
  static void paintPattern(
    Canvas canvas,
    Rect rect,
    MeaningPattern pattern,
    Color accent,
  ) {
    const gap = 7.0;
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = accent.withValues(alpha: patternAlpha);
    final fill = Paint()..color = accent.withValues(alpha: patternAlpha);
    switch (pattern) {
      case MeaningPattern.none:
        return;
      case MeaningPattern.solid:
        canvas.drawRect(rect, Paint()..color = accent);
      case MeaningPattern.stripes:
        _diagonals(canvas, rect, line, gap, rising: true);
      case MeaningPattern.crosshatch:
        _diagonals(canvas, rect, line, gap, rising: true);
        _diagonals(canvas, rect, line, gap, rising: false);
      case MeaningPattern.dots:
        for (var y = rect.top + gap / 2; y < rect.bottom; y += gap) {
          for (var x = rect.left + gap / 2; x < rect.right; x += gap) {
            canvas.drawCircle(Offset(x, y), 1.8, fill);
          }
        }
      case MeaningPattern.half:
        canvas.drawPath(
          Path()
            ..moveTo(rect.right, rect.top)
            ..lineTo(rect.right, rect.bottom)
            ..lineTo(rect.left, rect.bottom)
            ..close(),
          fill,
        );
      case MeaningPattern.horizontalLines:
        for (var y = rect.top + gap / 2; y < rect.bottom; y += gap) {
          canvas.drawLine(Offset(rect.left, y), Offset(rect.right, y), line);
        }
      case MeaningPattern.verticalLines:
        for (var x = rect.left + gap / 2; x < rect.right; x += gap) {
          canvas.drawLine(Offset(x, rect.top), Offset(x, rect.bottom), line);
        }
    }
  }

  static void _diagonals(
    Canvas canvas,
    Rect rect,
    Paint paint,
    double gap, {
    required bool rising,
  }) {
    final h = rect.height;
    for (var d = -h; d < rect.width; d += gap) {
      final x = rect.left + d;
      if (rising) {
        canvas.drawLine(Offset(x, rect.bottom), Offset(x + h, rect.top), paint);
      } else {
        canvas.drawLine(Offset(x, rect.top), Offset(x + h, rect.bottom), paint);
      }
    }
  }

  @override
  bool shouldRepaint(MeaningPatternPainter oldDelegate) =>
      oldDelegate.pattern != pattern ||
      oldDelegate.colors != colors ||
      oldDelegate.radius != radius;
}
