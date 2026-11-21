import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/core/widgets/app_illustration.dart';
import 'package:izin_planla/ui/core/widgets/illustration.dart';
import 'package:izin_planla/ui/core/widgets/primary_button.dart';
import 'package:material_ui/material_ui.dart';

/// What a screen shows when it has nothing yet: an illustration, one
/// sentence and one button.
///
/// Scrolls when the system text is large, so nothing is cut.
class EmptyState extends StatelessWidget {
  /// Creates the empty state.
  const new({
    required this.illustration,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    super.key,
  });

  /// Illustration above the sentence.
  final Illustration illustration;

  /// One sentence that says what is missing.
  final String message;

  /// Label of the single button.
  final String actionLabel;

  /// Called when the button is tapped.
  final VoidCallback onAction;

  static const _maxWidth = 400.0;

  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxWidth),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIllustration(illustration),
            const SizedBox(height: AppSpacing.lg),
            Text(
              message,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(label: actionLabel, onPressed: onAction),
          ],
        ),
      ),
    ),
  );
}
