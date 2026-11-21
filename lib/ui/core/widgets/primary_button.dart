import 'package:izin_planla/ui/core/theme/app_colors.dart';
import 'package:material_ui/material_ui.dart';

/// The one main action of a screen: a capsule at least 56 dp high, full
/// width by default, with a soft vertical gradient and a glow under it so it
/// stands out. A long label wraps instead of being cut.
class PrimaryButton extends StatelessWidget {
  /// Creates the button. A null [onPressed] disables it.
  const new({
    required this.label,
    required this.onPressed,
    this.icon,
    this.expand = true,
    super.key,
  });

  /// Button text.
  final String label;

  /// Called on tap, null when the action is not possible yet.
  final VoidCallback? onPressed;

  /// Optional icon before the label.
  final IconData? icon;

  /// Whether the button fills the available width.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final action = AppColors.of(context).action;
    final style = ButtonStyle(
      // The gradient below replaces the flat fill while enabled. Disabled
      // buttons keep the theme's flat disabled colour.
      backgroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled)
            ? null
            : action.bottom.withValues(alpha: 0),
      ),
      backgroundBuilder: (context, states, child) {
        if (states.contains(WidgetState.disabled)) {
          return child ?? const SizedBox.shrink();
        }
        return DecoratedBox(
          decoration: ShapeDecoration(
            shape: const StadiumBorder(),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [action.top, action.bottom],
            ),
            shadows: [
              BoxShadow(
                color: action.bottom.withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        );
      },
    );
    final icon = this.icon;
    final text = Text(label, textAlign: TextAlign.center);
    final button = icon == null
        ? FilledButton(onPressed: onPressed, style: style, child: text)
        : FilledButton.icon(
            onPressed: onPressed,
            style: style,
            icon: Icon(icon),
            label: text,
          );
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
