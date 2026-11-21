import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:izin_planla/data/services/notifications/notification_gateway.dart';
import 'package:timezone/timezone.dart' as tz;

/// [NotificationGateway] backed by `flutter_local_notifications`.
///
/// The only file that imports the plugin. Needs the receivers and the
/// `POST_NOTIFICATIONS` and `RECEIVE_BOOT_COMPLETED` permissions in
/// `AndroidManifest.xml`. The plugin's boot receiver restores scheduled
/// notifications after a restart.
class PluginNotificationGateway implements NotificationGateway {
  /// Creates the gateway. Tests may pass their own [plugin].
  new({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  /// Id of the single reminder channel.
  static const channelId = 'reminders';

  /// Small icon of every notification.
  static const smallIcon = '@mipmap/ic_launcher';

  final FlutterLocalNotificationsPlugin _plugin;
  String _channelName = channelId;
  String _channelDescription = '';

  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  @override
  Future<void> initialize({
    required String channelName,
    required String channelDescription,
  }) async {
    _channelName = channelName;
    _channelDescription = channelDescription;
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings(smallIcon),
      ),
    );
  }

  @override
  Future<bool> requestPermission() async =>
      await _android?.requestNotificationsPermission() ?? false;

  @override
  Future<bool> isPermissionGranted() async =>
      await _android?.areNotificationsEnabled() ?? false;

  @override
  Future<Set<int>> pendingIds() async => {
    for (final request in await _plugin.pendingNotificationRequests())
      request.id,
  };

  @override
  Future<void> schedule({
    required int id,
    required tz.TZDateTime fireAt,
    required String title,
    required String body,
  }) => _plugin.zonedSchedule(
    id: id,
    scheduledDate: fireAt,
    notificationDetails: _details(body),
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    title: title,
    body: body,
  );

  @override
  Future<void> show({
    required int id,
    required String title,
    required String body,
  }) => _plugin.show(
    id: id,
    title: title,
    body: body,
    notificationDetails: _details(body),
  );

  @override
  Future<void> cancel(int id) => _plugin.cancel(id: id);

  @override
  Future<void> cancelAll() => _plugin.cancelAll();

  NotificationDetails _details(String body) => NotificationDetails(
    android: AndroidNotificationDetails(
      channelId,
      _channelName,
      channelDescription: _channelDescription,
      category: AndroidNotificationCategory.reminder,
      styleInformation: BigTextStyleInformation(body),
    ),
  );
}
