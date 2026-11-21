import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:izin_planla/data/services/home_widget/home_widget_gateway.dart';

/// [HomeWidgetGateway] backed by the `home_widget` plugin.
///
/// The widget is optional, so a platform without the plugin (tests, other
/// operating systems) or a launcher error never fails the caller. The error
/// is logged and the widget keeps its previous content.
class PluginHomeWidgetGateway implements HomeWidgetGateway {
  /// Creates the gateway.
  const new();

  /// Fully qualified name of the Android `AppWidgetProvider`.
  static const providerName = 'com.izinplanla.app.widget.LeaveWidgetProvider';

  @override
  Future<void> save(String key, String value) =>
      _guard(() => HomeWidget.saveWidgetData<String>(key, value));

  @override
  Future<void> update() =>
      _guard(() => HomeWidget.updateWidget(qualifiedAndroidName: providerName));

  @override
  Future<void> requestPin() => _guard(() async {
    final supported = await HomeWidget.isRequestPinWidgetSupported();
    if (supported ?? false) {
      await HomeWidget.requestPinWidget(qualifiedAndroidName: providerName);
    }
  });

  Future<void> _guard(Future<void> Function() action) async {
    try {
      await action();
    } on MissingPluginException catch (error) {
      debugPrint('Home widget unavailable: $error');
    } on PlatformException catch (error) {
      debugPrint('Home widget call failed: $error');
    }
  }
}
