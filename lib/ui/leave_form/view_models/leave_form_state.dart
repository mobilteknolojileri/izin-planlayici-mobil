import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/ui/leave_form/view_models/leave_draft.dart';

/// What the leave form shows.
sealed class LeaveFormState {
  const new();
}

/// Data is still loading.
final class LeaveFormLoading extends LeaveFormState {
  /// Creates the state.
  const new();
}

/// Data could not be loaded.
final class LeaveFormError extends LeaveFormState {
  /// Creates the state.
  const new();
}

/// No profile yet, the setup has not run.
final class LeaveFormNoProfile extends LeaveFormState {
  /// Creates the state.
  const new();
}

/// The form with the live day count and its warnings.
final class LeaveFormReady extends LeaveFormState {
  /// Creates the state.
  const new({
    required this.draft,
    required this.isEditing,
    required this.employmentType,
    required this.dailyHours,
    required this.today,
    required this.showErrors,
    required this.saving,
    required this.deducts,
    this.dayCount,
    this.remainingAfter,
    this.shortfall,
    this.warnings = const [],
    this.suggestedDays,
  });

  /// The answers so far.
  final LeaveDraft draft;

  /// Whether an existing leave is edited.
  final bool isEditing;

  /// The law of the active profile.
  final EmploymentType employmentType;

  /// Working hours per day of the active profile.
  final double dailyHours;

  /// Today, UTC midnight.
  final DateTime today;

  /// Whether errors are shown, after the first save attempt.
  final bool showErrors;

  /// Whether the leave is being saved.
  final bool saving;

  /// Whether this leave reduces the annual balance.
  final bool deducts;

  /// Days deducted and the reason for every day, for whole day leave
  /// that reduces the balance. Null before a date is chosen.
  final DayCount? dayCount;

  /// Balance left after this leave, null before the form is valid.
  final double? remainingAfter;

  /// Days the balance goes below zero with this leave, null when it does
  /// not.
  final double? shortfall;

  /// Split rule and travel leave warnings.
  final List<LeaveWarningType> warnings;

  /// Legal days for the chosen excuse type, null when the law sets none.
  final int? suggestedDays;

  /// Whether the start date is missing.
  bool get startMissing => draft.start == null;

  /// Whether the name of an "other" leave is missing.
  bool get customNameMissing =>
      draft.type == LeaveType.other && draft.customName.trim().isEmpty;

  /// Whether the hours of an hourly leave are missing or not a positive
  /// number.
  bool get hoursInvalid {
    if (draft.unit != LeaveUnit.hours) return false;
    final hours = draft.hoursValue;
    return hours == null || hours <= 0;
  }

  /// Whether the hours are longer than one working day.
  bool get hoursTooMany {
    if (draft.unit != LeaveUnit.hours) return false;
    final hours = draft.hoursValue;
    return hours != null && hours > dailyHours;
  }

  /// Whether the form can be saved.
  bool get isValid =>
      !startMissing && !customNameMissing && !hoursInvalid && !hoursTooMany;

  /// Whether the second excuse block switch applies: a civil servant's
  /// excuse leave.
  bool get offersSecondExcuse =>
      draft.type == LeaveType.excuse &&
      employmentType == EmploymentType.civilServant;
}
