import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/routing/routes.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/core/widgets/illustration.dart';
import 'package:izin_planla/ui/core/widgets/step_scaffold.dart';
import 'package:izin_planla/ui/onboarding/view_models/onboarding_view_model.dart';
import 'package:izin_planla/ui/people/widgets/date_field.dart';
import 'package:izin_planla/ui/people/widgets/option_list.dart';
import 'package:izin_planla/ui/people/widgets/profile_advanced_fields.dart';
import 'package:material_ui/material_ui.dart';

/// First-run setup: one question per step, at most four steps, each with
/// the reason it is asked. The last step has an optional advanced section.
class OnboardingScreen extends ConsumerWidget {
  /// Creates the screen.
  const new({super.key});

  /// Earliest start or birth date the pickers allow.
  static final _firstDate = DateTime.utc(1940);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(onboardingViewModelProvider);
    final viewModel = ref.read(onboardingViewModelProvider.notifier);
    final draft = state.draft;
    final labor = draft.employmentType != EmploymentType.civilServant;
    final (question, reason, illustration, answer) = switch (state.step) {
      1 => (
        l10n.onboardingTypeQuestion,
        l10n.onboardingTypeReason,
        Illustration.onboardingEmployment,
        OptionList<EmploymentType>(
          values: EmploymentType.values,
          selected: draft.employmentType,
          title: (type) => switch (type) {
            EmploymentType.laborLaw => l10n.onboardingTypeLabor,
            EmploymentType.civilServant => l10n.onboardingTypeCivil,
          },
          detail: (type) => switch (type) {
            EmploymentType.laborLaw => l10n.onboardingTypeLaborDetail,
            EmploymentType.civilServant => l10n.onboardingTypeCivilDetail,
          },
          onSelected: viewModel.chooseEmploymentType,
        ),
      ),
      2 => (
        labor
            ? l10n.onboardingStartQuestionLabor
            : l10n.onboardingStartQuestionCivil,
        labor
            ? l10n.onboardingStartReasonLabor
            : l10n.onboardingStartReasonCivil,
        Illustration.onboardingStartDate,
        DateField(
          label: l10n.onboardingStartLabel,
          value: draft.startDate,
          firstDate: _firstDate,
          lastDate: state.today,
          onChanged: viewModel.chooseStartDate,
        ),
      ),
      3 => (
        l10n.onboardingBirthQuestion,
        l10n.onboardingBirthReasonLabor,
        Illustration.onboardingBirthDate,
        DateField(
          label: l10n.onboardingBirthLabel,
          value: draft.birthDate,
          firstDate: _firstDate,
          lastDate: state.today,
          onChanged: viewModel.chooseBirthDate,
        ),
      ),
      _ => (
        l10n.onboardingSaturdayQuestion,
        l10n.onboardingSaturdayReason,
        Illustration.onboardingSaturday,
        OptionList<bool>(
          values: const [true, false],
          selected: draft.worksSaturday,
          title: (works) =>
              works ? l10n.onboardingSaturdayYes : l10n.onboardingSaturdayNo,
          onSelected: (works) => viewModel.chooseSaturday(works: works),
        ),
      ),
    };
    final canPop = Navigator.of(context).canPop();
    return PopScope(
      canPop: state.step == 1,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) viewModel.back();
      },
      child: StepScaffold(
        step: state.step,
        stepCount: state.stepCount,
        question: question,
        reason: reason,
        illustration: illustration,
        nextLabel: state.isLastStep
            ? l10n.onboardingFinish
            : l10n.onboardingNext,
        onNext: !state.canContinue
            ? null
            : state.isLastStep
            ? () => unawaited(_finish(context, ref))
            : viewModel.next,
        onBack: state.step > 1
            ? viewModel.back
            : canPop
            ? () => Navigator.of(context).pop()
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            answer,
            if (state.isLastStep) ...[
              const SizedBox(height: AppSpacing.lg),
              ProfileAdvancedFields(
                draft: draft,
                onChanged: viewModel.updateAdvanced,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _finish(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final saved = await ref
        .read(onboardingViewModelProvider.notifier)
        .finish(l10n.onboardingDefaultName);
    if (!context.mounted) return;
    if (saved) {
      context.go(Routes.home);
    } else {
      messenger.showSnackBar(SnackBar(content: Text(l10n.onboardingSaveError)));
    }
  }
}
