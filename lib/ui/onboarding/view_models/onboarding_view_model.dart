import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State and actions of the onboarding screen. Built by task 11.
final onboardingViewModelProvider = NotifierProvider<OnboardingViewModel, void>(
  OnboardingViewModel.new,
);

/// View model of the onboarding screen. The screen only reads its state
/// and calls its methods, business rules stay in the domain layer.
class OnboardingViewModel extends Notifier<void> {
  @override
  void build() {}
}
