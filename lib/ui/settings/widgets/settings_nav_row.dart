import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

/// A row that runs an action or opens another screen: an icon, a title, an
/// optional second line and, for screens, a chevron.
class SettingsNavRow extends StatelessWidget {
  /// Creates the row.
  const new({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.chevron = false,
    this.destructive = false,
    super.key,
  });

  /// Icon before the title.
  final IconData icon;

  /// Row title.
  final String title;

  /// Optional second line.
  final String? subtitle;

  /// Called when the row is tapped.
  final VoidCallback onTap;

  /// Whether a chevron says the row opens another screen.
  final bool chevron;

  /// Whether the action deletes data, drawn in the error colour.
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final subtitle = this.subtitle;
    final color = destructive ? scheme.error : scheme.primary;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: destructive ? TextStyle(color: scheme.error) : null,
      ),
      subtitle: subtitle == null ? null : Text(subtitle),
      trailing: chevron ? const Icon(LucideIcons.chevronRight) : null,
      onTap: onTap,
    );
  }
}
