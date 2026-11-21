import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/ui/core/theme/meaning.dart';
import 'package:izin_planla/ui/core/widgets/week_strip_day.dart';

/// What the home screen shows.
sealed class HomeState {
  const new();
}

/// Data is still loading.
final class HomeLoading extends HomeState {
  /// Creates the state.
  const new();
}

/// Data could not be loaded.
final class HomeError extends HomeState {
  /// Creates the state.
  const new();
}

/// No profile yet, the setup has not run.
final class HomeNoProfile extends HomeState {
  /// Creates the state.
  const new();
}

/// The balance and the cards of the active profile.
final class HomeReady extends HomeState {
  /// Creates the state.
  const new({
    required this.today,
    required this.profileName,
    required this.hasSeveralProfiles,
    required this.isTeacher,
    this.balance,
    this.nextAccrual,
    this.daysUntilAccrual,
    this.nextHoliday,
    this.daysUntilHoliday,
    this.bridge,
    this.bridgeDays = const [],
    this.bridgeMeanings = const [],
  });

  /// Today, UTC midnight.
  final DateTime today;

  /// Name of the active profile.
  final String profileName;

  /// Whether more than one profile exists, so the name is shown.
  final bool hasSeveralProfiles;

  /// Whether the profile is a teacher with no annual leave (657 art.
  /// 103/2). The balance is not shown then.
  final bool isTeacher;

  /// Annual leave balance, null for a teacher.
  final LeaveBalance? balance;

  /// The next accrual, null when none is coming.
  final NextAccrual? nextAccrual;

  /// Days from today to [nextAccrual].
  final int? daysUntilAccrual;

  /// The next full-day official holiday after today.
  final Holiday? nextHoliday;

  /// Days from today to [nextHoliday].
  final int? daysUntilHoliday;

  /// The best bridge suggestion still ahead, null when there is none.
  final BridgeSuggestion? bridge;

  /// Every day of [bridge] with its meaning, for the week strip.
  final List<WeekStripDay> bridgeDays;

  /// Meanings that appear in [bridgeDays], for the legend.
  final List<Meaning> bridgeMeanings;
}
