import 'package:izin_planla/domain/models/models.dart';
import 'package:material_ui/material_ui.dart';

/// The loaded settings screen.
@immutable
class SettingsContent {
  /// Creates the content.
  const new({
    required this.settings,
    required this.profiles,
    required this.activeProfile,
  });

  /// App wide settings.
  final AppSettings settings;

  /// Every stored person.
  final List<Profile> profiles;

  /// The person whose work schedule is shown, null before setup.
  final Profile? activeProfile;

  /// Lowest daily working hours.
  static const minHours = 1.0;

  /// Highest daily working hours.
  static const maxHours = 16.0;

  /// Lowest number of days before a reminder.
  static const minDaysBefore = 1;

  /// Highest number of days before a reminder.
  static const maxDaysBefore = 30;
}
