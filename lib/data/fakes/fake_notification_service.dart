import 'package:izin_planla/data/services/notifications/notification_service.dart';

/// [NotificationService] that schedules nothing.
class FakeNotificationService implements NotificationService {
  @override
  Future<void> initialize() async {}

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<void> reschedule() async {}

  @override
  Future<void> cancelAll() async {}
}
