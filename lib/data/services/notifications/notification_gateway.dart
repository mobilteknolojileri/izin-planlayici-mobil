import 'package:timezone/timezone.dart' as tz;

/// Thin wrapper over the notification plugin.
///
/// Holds no logic, so `LocalNotificationService` and `ReminderPlanner` are
/// unit tested with a fake gateway. Platform errors are thrown as
/// exceptions and handled by the service.
abstract interface class NotificationGateway {
  /// Starts the plugin. The channel texts are shown in the system settings.
  Future<void> initialize({
    required String channelName,
    required String channelDescription,
  });

  /// Shows the system permission dialog when needed. Returns whether
  /// notifications are allowed.
  Future<bool> requestPermission();

  /// Whether notifications are allowed, without asking.
  Future<bool> isPermissionGranted();

  /// Ids of the notifications waiting to fire.
  Future<Set<int>> pendingIds();

  /// Schedules a notification at [fireAt], replacing any with the same [id].
  /// Android fires it roughly then, exact alarms are not used.
  Future<void> schedule({
    required int id,
    required tz.TZDateTime fireAt,
    required String title,
    required String body,
  });

  /// Shows a notification right away.
  Future<void> show({
    required int id,
    required String title,
    required String body,
  });

  /// Cancels the notification with [id].
  Future<void> cancel(int id);

  /// Cancels every scheduled and shown notification of the app.
  Future<void> cancelAll();
}
