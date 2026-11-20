/// Route paths. The first five are bottom navigation tabs, the rest are
/// pushed on top of them.
abstract final class Routes {
  /// Home tab.
  static const home = '/';

  /// Leave list tab.
  static const leaves = '/leaves';

  /// Calendar tab.
  static const calendar = '/calendar';

  /// Bridge planner tab.
  static const bridge = '/bridge';

  /// Settings tab.
  static const settings = '/settings';

  /// First-run setup.
  static const onboarding = '/onboarding';

  /// Add or edit a leave.
  static const leaveForm = '/leave-form';

  /// How the entitlement was calculated.
  static const explain = '/explain';

  /// People list.
  static const people = '/people';

  /// Statistics.
  static const stats = '/stats';

  /// Legislation guide.
  static const guide = '/guide';

  /// About the app.
  static const about = '/about';
}
