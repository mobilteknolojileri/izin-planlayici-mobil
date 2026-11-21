/// Illustrations in `assets/illustrations/`, drawn for this project.
enum Illustration {
  /// No leave recorded yet.
  leavesEmpty('assets/illustrations/leaves_empty.svg'),

  /// No other person added yet.
  peopleEmpty('assets/illustrations/people_empty.svg'),

  /// No bridge suggestion for the chosen period.
  bridgeEmpty('assets/illustrations/bridge_empty.svg'),

  /// Not enough data for statistics.
  statsEmpty('assets/illustrations/stats_empty.svg'),

  /// Setup step: employment type.
  onboardingEmployment('assets/illustrations/onboarding_employment.svg'),

  /// Setup step: start date at the workplace.
  onboardingStartDate('assets/illustrations/onboarding_start_date.svg'),

  /// Setup step: birth date.
  onboardingBirthDate('assets/illustrations/onboarding_birth_date.svg'),

  /// Setup step: working on Saturdays.
  onboardingSaturday('assets/illustrations/onboarding_saturday.svg');

  new(this.asset);

  /// Asset path of the SVG file.
  final String asset;
}
