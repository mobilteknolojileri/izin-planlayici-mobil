import 'dart:math' as math;

import 'package:izin_planla/ui/core/theme/app_colors.dart';
import 'package:izin_planla/ui/core/theme/meaning.dart';
import 'package:izin_planla/ui/core/widgets/meaning_pattern_painter.dart';
import 'package:material_ui/material_ui.dart';

/// A mark for one [Meaning]: colour, pattern and icon together.
///
/// Decorative for screen readers, the parent provides the label.
class MeaningTile extends StatelessWidget {
  /// Creates a tile, square unless [width] and [height] differ.
  const new({
    required this.meaning,
    this.width = 40,
    this.height = 40,
    super.key,
  });

  /// What the tile shows.
  final Meaning meaning;

  /// Width in logical pixels.
  final double width;

  /// Height in logical pixels.
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context).forMeaning(meaning);
    final side = math.min(width, height);
    return ExcludeSemantics(
      child: CustomPaint(
        size: Size(width, height),
        painter: MeaningPatternPainter(
          pattern: meaning.pattern,
          colors: colors,
          radius: side / 5,
        ),
        child: SizedBox(
          width: width,
          height: height,
          child: Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.fill,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: EdgeInsets.all(side * 0.08),
                child: Icon(
                  meaning.icon,
                  size: side * 0.5,
                  color: colors.accent,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
