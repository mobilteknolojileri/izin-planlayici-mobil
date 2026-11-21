import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/ui/leaves/view_models/leave_list_item.dart';
import 'package:izin_planla/ui/leaves/view_models/leaves_section.dart';

/// What the leaves tab shows.
sealed class LeavesState {
  const new();
}

/// Data is still loading.
final class LeavesLoading extends LeavesState {
  /// Creates the state.
  const new();
}

/// Data could not be loaded.
final class LeavesError extends LeavesState {
  /// Creates the state.
  const new();
}

/// No profile yet, the setup has not run.
final class LeavesNoProfile extends LeavesState {
  /// Creates the state.
  const new();
}

/// The filtered leave, hourly leave and overtime lists of the active
/// profile.
final class LeavesReady extends LeavesState {
  /// Creates the state.
  const new({
    required this.today,
    required this.section,
    required this.year,
    required this.years,
    required this.type,
    required this.types,
    required this.hasAnyLeave,
    required this.planned,
    required this.used,
    required this.hourly,
    required this.overtime,
    required this.hourlyTotal,
    required this.overtimeTotal,
  });

  /// Today, UTC midnight.
  final DateTime today;

  /// The visible part of the tab.
  final LeavesSection section;

  /// The chosen year.
  final int year;

  /// Years that can be chosen, newest first.
  final List<int> years;

  /// The chosen leave type, null for every type.
  final LeaveType? type;

  /// Leave types that can be chosen.
  final List<LeaveType> types;

  /// Whether the profile has any leave at all, else the empty state shows.
  final bool hasAnyLeave;

  /// Whole and half day leave of [year] that starts after today.
  final List<LeaveListItem> planned;

  /// Whole and half day leave of [year] that started already.
  final List<LeaveListItem> used;

  /// Hourly leave of [year].
  final List<LeaveListItem> hourly;

  /// Overtime records of [year], newest first.
  final List<OvertimeRecord> overtime;

  /// Hours of hourly leave in [year].
  final double hourlyTotal;

  /// Overtime hours in [year].
  final double overtimeTotal;
}
