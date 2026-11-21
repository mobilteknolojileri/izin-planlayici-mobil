import 'package:flutter/foundation.dart' show immutable;
import 'package:izin_planla/data/services/notifications/reminder.dart';
import 'package:timezone/timezone.dart' as tz;

/// A [Reminder] with its notification id and the moment it fires.
@immutable
class ScheduledReminder {
  /// Creates a scheduled reminder.
  const new({required this.id, required this.fireAt, required this.reminder});

  /// Notification id. The same subject always gets the same id, so
  /// scheduling it again replaces the old notification.
  final int id;

  /// When the notification is shown, in `Europe/Istanbul`. Android fires it
  /// roughly then, because exact alarms are not used.
  final tz.TZDateTime fireAt;

  /// What the notification says.
  final Reminder reminder;

  @override
  bool operator ==(Object other) =>
      other is ScheduledReminder &&
      other.id == id &&
      other.fireAt == fireAt &&
      other.reminder == reminder;

  @override
  int get hashCode => Object.hash(id, fireAt, reminder);

  @override
  String toString() => 'ScheduledReminder($id, $fireAt, $reminder)';
}
