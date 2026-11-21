import 'package:izin_planla/domain/models/models.dart';

/// What the explain screen shows.
sealed class ExplainState {
  const new();
}

/// Data is still loading.
final class ExplainLoading extends ExplainState {
  /// Creates the state.
  const new();
}

/// Data could not be loaded.
final class ExplainError extends ExplainState {
  /// Creates the state.
  const new();
}

/// No profile yet, the setup has not run.
final class ExplainNoProfile extends ExplainState {
  /// Creates the state.
  const new();
}

/// The calculation of the active profile, period by period.
final class ExplainReady extends ExplainState {
  /// Creates the state.
  const new({
    required this.profile,
    required this.isTeacher,
    required this.periods,
    required this.showNoAbsenceNote,
    this.balance,
    this.nextAccrual,
  });

  /// The active profile, whose facts the calculation uses.
  final Profile profile;

  /// Whether the profile is a teacher with no annual leave (657 art.
  /// 103/2).
  final bool isTeacher;

  /// Accrual periods up to today, newest first.
  final List<EntitlementPeriod> periods;

  /// Whether to say that continuous work is assumed, because no absence is
  /// entered and no period says it already.
  final bool showNoAbsenceNote;

  /// The balance arithmetic, null for a teacher.
  final LeaveBalance? balance;

  /// The next accrual, null when none is coming.
  final NextAccrual? nextAccrual;

  /// Whether the profile works under Labour Law 4857.
  bool get isLabor => profile.employmentType == EmploymentType.laborLaw;

  /// Whether the Saturday setting applies: 4857 and no Saturday work.
  bool get showSaturdayNote =>
      isLabor && !profile.workSchedule.workDays.contains(DateTime.saturday);
}
