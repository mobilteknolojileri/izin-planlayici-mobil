import 'package:flutter_svg/flutter_svg.dart';
import 'package:izin_planla/ui/core/theme/illustration_colors.dart';
import 'package:izin_planla/ui/core/widgets/illustration.dart';
import 'package:material_ui/material_ui.dart';

/// Shows an [Illustration] in the colours of the current theme.
///
/// Decorative: screen readers skip it, the text next to it carries the
/// meaning.
class AppIllustration extends StatelessWidget {
  /// Creates the illustration with the given [height].
  const new(this.illustration, {this.height = 160, super.key});

  /// Which illustration to show.
  final Illustration illustration;

  /// Height in logical pixels. The width follows the aspect ratio.
  final double height;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return ExcludeSemantics(
      child: SvgPicture.asset(
        illustration.asset,
        height: height,
        colorMapper: dark ? const _DarkColorMapper() : null,
      ),
    );
  }
}

class _DarkColorMapper extends ColorMapper {
  const new();

  @override
  Color substitute(
    String? id,
    String elementName,
    String attributeName,
    Color color,
  ) => IllustrationColors.toDark(color);
}
