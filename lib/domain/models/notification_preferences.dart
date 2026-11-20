import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_preferences.freezed.dart';
part 'notification_preferences.g.dart';

/// Reminder choices. All reminders are off until the user turns them on,
/// because the notification permission is asked only then.
@freezed
abstract class NotificationPreferences with _$NotificationPreferences {
  /// Creates notification preferences.
  const factory({
    @Default(false) bool holidayReminder,
    @Default(7) int holidayDaysBefore,
    @Default(false) bool accrualReminder,
    @Default(false) bool plannedLeaveReminder,
    @Default(1) int plannedLeaveDaysBefore,
    @Default(false) bool yearEndReminder,
  }) = _NotificationPreferences;

  /// Creates notification preferences from JSON.
  factory fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesFromJson(json);
}
