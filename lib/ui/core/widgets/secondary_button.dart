import 'package:material_ui/material_ui.dart';

/// A second, less important action, such as "Vazgeç". Same size and shape
/// as `PrimaryButton`, with a grey fill and accent text instead of a solid
/// accent fill.
class SecondaryButton extends StatelessWidget {
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

  /// Called on tap, null when the action is not possible.
  final VoidCallback? onPressed;

  /// Optional icon before the label.
  final IconData? icon;

  /// Whether the button fills the available width.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final icon = this.icon;
    final text = Text(label, textAlign: TextAlign.center);
    final button = icon == null
        ? FilledButton.tonal(onPressed: onPressed, child: text)
        : FilledButton.tonalIcon(
            onPressed: onPressed,
            icon: Icon(icon),
            label: text,
          );
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
