import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_planla/config/dependencies.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/ui/onboarding/view_models/onboarding_state.dart';
import 'package:izin_planla/ui/people/view_models/profile_draft.dart';
import 'package:izin_planla/utils/result.dart';

/// State and actions of the setup screen.
final NotifierProvider<OnboardingViewModel, OnboardingState>
onboardingViewModelProvider = NotifierProvider.autoDispose(
  OnboardingViewModel.new,
);

/// View model of the setup: at most four questions, then the profile is
/// saved and becomes the active one. Nothing is asked of the system, no
/// permission is requested.
class OnboardingViewModel extends Notifier<OnboardingState> {
  /// Creates the view model. [clock] gives the current time, tests pass a
  /// fixed one.
  new({DateTime Function()? clock}) : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;

  @override
  OnboardingState build() {
    final now = _clock();
    return OnboardingState(today: DateTime.utc(now.year, now.month, now.day));
  }

  /// Answers step 1.
  void chooseEmploymentType(EmploymentType type) =>
      _update(state.draft.copyWith(employmentType: type));

  /// Answers step 2.
  void chooseStartDate(DateTime date) =>
      _update(state.draft.copyWith(startDate: date));

  /// Answers step 3.
  void chooseBirthDate(DateTime date) =>
      _update(state.draft.copyWith(birthDate: date));

  /// Answers step 4.
  void chooseSaturday({required bool works}) =>
      _update(state.draft.copyWith(worksSaturday: works));

  /// Replaces the optional answers of the last step.
  void updateAdvanced(ProfileDraft draft) => _update(draft);

  /// Goes to the next step when the current one is answered.
  void next() {
    if (!state.canContinue || state.isLastStep) return;
    state = state.copyWith(step: state.step + 1);
  }

  /// Goes back one step.
  void back() {
    if (state.step == 1) return;
    state = state.copyWith(step: state.step - 1);
  }

  /// Saves the profile under [name] and makes it the active one. Returns
  /// whether it was saved.
  Future<bool> finish(String name) async {
    if (!state.canContinue || !state.isLastStep) return false;
    state = state.copyWith(saving: true);
    final profiles = ref.read(profileRepositoryProvider);
    final settingsRepository = ref.read(settingsRepositoryProvider);
    final id = 'profile-${_clock().microsecondsSinceEpoch}';
    final profile = state.draft.copyWith(name: name).toProfile(id: id);
    final saved = await profiles.save(profile);
    var ok = saved is Ok<void>;
    if (ok) {
      final settings = await settingsRepository.watch().first;
      final active = await settingsRepository.save(
        settings.copyWith(activeProfileId: id),
      );
      ok = active is Ok<void>;
    }
    if (ref.mounted) state = state.copyWith(saving: false);
    return ok;
  }

  void _update(ProfileDraft draft) {
    // Civil servants have three steps, so a later step may no longer exist.
    final next = state.copyWith(draft: draft);
    state = next.step > next.stepCount
        ? next.copyWith(step: next.stepCount)
        : next;
  }
}
