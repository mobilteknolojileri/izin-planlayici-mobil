import 'package:izin_planla/domain/models/models.dart';
import 'package:material_ui/material_ui.dart';

/// The loaded statistics for the chosen person and year.
@immutable
class StatsContent {
  /// Creates the content.
  const new({
    required this.profiles,
    required this.selectedProfileId,
    required this.years,
    required this.year,
    required this.summary,
    required this.byYear,
    required this.hasLeaves,
  });

  /// Every stored person.
  final List<Profile> profiles;

  /// The chosen person, null for everyone together.
  final String? selectedProfileId;

  /// Years with statistics, oldest first.
  final List<int> years;

  /// The chosen year.
  final int year;

  /// Statistics of [year], summed over the chosen people.
  final YearSummary summary;

  /// Earned and used per year, up to [year], oldest first.
  final List<YearSummary> byYear;

  /// Whether the chosen people have any leave record.
  final bool hasLeaves;

  /// Whether a person is stored.
  bool get hasProfile => profiles.isNotEmpty;

  /// Whether the person filter is worth showing.
  bool get hasManyPeople => profiles.length > 1;
}
