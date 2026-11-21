import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

/// One option of a single choice list, as in iOS settings: the label and a
/// check mark on the chosen option. Screen readers hear it as a selected
/// option in a group.
class SettingsChoiceRow extends StatelessWidget {
  /// Creates the row.
  const new({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  /// Option text.
  final String label;

  /// Whether this option is chosen.
  final bool selected;

  /// Called when the option is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    inMutuallyExclusiveGroup: true,
    child: ListTile(
      contentPadding: EdgeInsets.zero,
      selected: selected,
      title: Text(label),
      trailing: selected ? const Icon(LucideIcons.check) : null,
      onTap: onTap,
    ),
  );
}
