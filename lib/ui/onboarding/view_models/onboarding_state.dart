import 'package:flutter/foundation.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/ui/people/view_models/profile_draft.dart';

/// State of the setup: the current step and the answers so far.
@immutable
class OnboardingState {
  /// Creates the state. [today] is a UTC midnight date.
  const new({
    required this.today,
    this.step = 1,
    this.draft = const ProfileDraft(),
    this.saving = false,
  });

  /// Today, the latest start date the picker allows.
  final DateTime today;

  /// Current step, from 1 to [stepCount].
  final int step;

  /// The answers so far.
  final ProfileDraft draft;

  /// Whether the answers are being saved.
  final bool saving;

  /// Number of steps: civil servants skip the birth date, because their
  /// leave does not depend on age, and the Saturday question, because their
  /// Saturdays inside a leave always count (`docs/mevzuat.md` 2.5).
  int get stepCount =>
      draft.employmentType == EmploymentType.civilServant ? 2 : 4;

  /// Whether this is the last step.
  bool get isLastStep => step == stepCount;

  /// Whether the question of this step is answered.
  bool get canContinue {
    if (saving) return false;
    final answered = switch (step) {
      1 => draft.employmentType != null,
      2 => draft.startDate != null,
      3 => draft.birthDate != null,
      _ => draft.worksSaturday != null,
    };
    return answered && (!isLastStep || draft.isComplete);
  }

  /// A copy with the given fields replaced.
  OnboardingState copyWith({int? step, ProfileDraft? draft, bool? saving}) =>
      OnboardingState(
        today: today,
        step: step ?? this.step,
        draft: draft ?? this.draft,
        saving: saving ?? this.saving,
      );
}
