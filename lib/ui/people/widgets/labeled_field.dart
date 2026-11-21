import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:material_ui/material_ui.dart';

/// A form field with its label on its own line above it.
///
/// A floating label inside the field is cut with an ellipsis at large
/// system text, a label above it wraps instead. Screen readers hear the
/// label and the field as one item. Shared by every form of 11a. A
/// candidate for `lib/ui/core/widgets/`.
class LabeledField extends StatelessWidget {
  /// Creates the field.
  const new({required this.label, required this.child, super.key});

  /// Label above the field.
  final String label;

  /// The field, without its own label.
  final Widget child;

  @override
  Widget build(BuildContext context) => MergeSemantics(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: AppSpacing.xs),
        child,
      ],
    ),
  );
}
