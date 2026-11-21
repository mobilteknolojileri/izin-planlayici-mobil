import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

/// A card of choices where one can be picked, each a full width row with
/// its title, an optional detail line and a check mark when chosen.
///
/// Rows grow with the system text size and screen readers hear each one as
/// a selectable button. Shared by the setup, people, leave and filter
/// forms. A candidate for `lib/ui/core/widgets/`.
class OptionList<T> extends StatelessWidget {
  /// Creates the list of [values].
  const new({
    required this.values,
    required this.selected,
    required this.title,
    required this.onSelected,
    this.detail,
    super.key,
  });

  /// The choices, in order.
  final List<T> values;

  /// The chosen value, null before a choice.
  final T? selected;

  /// Title of a choice.
  final String Function(T value) title;

  /// Optional detail line of a choice.
  final String? Function(T value)? detail;

  /// Called with the tapped value.
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final detail = this.detail;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (final (index, value) in values.indexed) ...[
            if (index > 0) const Divider(indent: AppSpacing.md),
            Semantics(
              inMutuallyExclusiveGroup: true,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                selected: value == selected,
                selectedColor: scheme.primary,
                title: Text(title(value)),
                subtitle: switch (detail?.call(value)) {
                  final text? => Text(text),
                  null => null,
                },
                trailing: Icon(
                  value == selected
                      ? LucideIcons.circleCheck
                      : LucideIcons.circle,
                  color: value == selected ? scheme.primary : scheme.outline,
                ),
                onTap: () => onSelected(value),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
