import 'package:izin_planla/domain/models/models.dart';

/// What the people screen shows.
sealed class PeopleState {
  const new();
}

/// Data is still loading.
final class PeopleLoading extends PeopleState {
  /// Creates the state.
  const new();
}

/// Data could not be loaded.
final class PeopleError extends PeopleState {
  /// Creates the state.
  const new();
}

/// Every profile and which one is active.
final class PeopleReady extends PeopleState {
  /// Creates the state.
  const new({
    required this.profiles,
    required this.activeId,
    required this.today,
  });

  /// All profiles, in the order they were added.
  final List<Profile> profiles;

  /// Id of the profile shown on the home screen.
  final String? activeId;

  /// Today, UTC midnight, the latest date the pickers allow.
  final DateTime today;
}
