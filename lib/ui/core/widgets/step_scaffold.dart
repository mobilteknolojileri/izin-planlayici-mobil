import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/core/widgets/app_illustration.dart';
import 'package:izin_planla/ui/core/widgets/illustration.dart';
import 'package:izin_planla/ui/core/widgets/primary_button.dart';
import 'package:material_ui/material_ui.dart';

/// One setup step: progress, a single question, why it is asked, the answer
/// field and one button at the bottom.
class StepScaffold extends StatelessWidget {
  /// Creates a step. [step] starts at 1.
  const new({
    required this.step,
    required this.stepCount,
    required this.question,
    required this.reason,
    required this.nextLabel,
    required this.onNext,
    required this.child,
    this.illustration,
    this.onBack,
    super.key,
  }) : assert(step >= 1 && step <= stepCount, 'step out of range');

  /// Current step, from 1 to [stepCount].
  final int step;

  /// Number of steps.
  final int stepCount;

  /// The one question of this step.
  final String question;

  /// One sentence on why the app asks it.
  final String reason;

  /// Label of the bottom button.
  final String nextLabel;

  /// Called by the bottom button, null while the answer is missing.
  final VoidCallback? onNext;

  /// The answer field.
  final Widget child;

  /// Optional illustration above the question.
  final Illustration? illustration;

  /// Called by the back button. No back button when null.
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final illustration = this.illustration;
    final onBack = this.onBack;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: onBack == null ? null : BackButton(onPressed: onBack),
        title: Semantics(
          label: l10n.coreStepProgressSemantics(step, stepCount),
          excludeSemantics: true,
          child: Text(l10n.coreStepProgress(step, stepCount)),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(AppSpacing.xs),
          child: ExcludeSemantics(
            child: LinearProgressIndicator(value: step / stepCount),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            if (illustration != null) ...[
              Center(child: AppIllustration(illustration, height: 140)),
              const SizedBox(height: AppSpacing.lg),
            ],
            Semantics(
              header: true,
              child: Text(question, style: text.headlineSmall),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              reason,
              style: text.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            child,
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: PrimaryButton(label: nextLabel, onPressed: onNext),
        ),
      ),
    );
  }
}
