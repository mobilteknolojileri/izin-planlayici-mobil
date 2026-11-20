/// Schedules local reminders. Implemented by task 12.
abstract interface class NotificationService {
  /// Prepares the plugin and time zones. Call once at start.
  Future<void> initialize();

  /// Asks for the notification permission. Returns whether it is granted.
  Future<bool> requestPermission();

  /// Recomputes and replaces all scheduled reminders from current data.
  Future<void> reschedule();

  /// Cancels every scheduled reminder.
  Future<void> cancelAll();
}
