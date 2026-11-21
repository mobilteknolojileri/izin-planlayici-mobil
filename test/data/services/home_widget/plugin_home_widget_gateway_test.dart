import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/services/home_widget/plugin_home_widget_gateway.dart';

const _channel = MethodChannel('home_widget');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<MethodCall> calls;
  var pinSupported = true;

  void handle(Future<Object?> Function(MethodCall call) handler) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, (call) {
          calls.add(call);
          return handler(call);
        });
  }

  setUp(() {
    calls = [];
    pinSupported = true;
    handle(
      (call) async => switch (call.method) {
        'isRequestPinWidgetSupported' => pinSupported,
        'requestPinWidget' => null,
        _ => true,
      },
    );
  });

  tearDown(
    () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, null),
  );

  const gateway = PluginHomeWidgetGateway();

  /// Collects what the gateway logs in this test instead of printing it.
  List<String?> captureLogs() {
    final logs = <String?>[];
    final original = debugPrint;
    debugPrint = (message, {wrapWidth}) => logs.add(message);
    addTearDown(() => debugPrint = original);
    return logs;
  }

  test('save stores the string under the key', () async {
    await gateway.save('leave_widget_data', '{}');

    expect(calls.single.method, 'saveWidgetData');
    expect(calls.single.arguments, {'id': 'leave_widget_data', 'data': '{}'});
  });

  test('update names the Kotlin provider', () async {
    await gateway.update();

    expect(calls.single.method, 'updateWidget');
    expect(
      (calls.single.arguments as Map)['qualifiedAndroidName'],
      'com.izinplanla.app.widget.LeaveWidgetProvider',
    );
  });

  test('requestPin pins when the launcher supports it', () async {
    await gateway.requestPin();

    expect(calls.map((call) => call.method), [
      'isRequestPinWidgetSupported',
      'requestPinWidget',
    ]);
    expect(
      (calls.last.arguments as Map)['qualifiedAndroidName'],
      PluginHomeWidgetGateway.providerName,
    );
  });

  test('requestPin does nothing when the launcher cannot pin', () async {
    pinSupported = false;

    await gateway.requestPin();

    expect(calls.map((call) => call.method), ['isRequestPinWidgetSupported']);
  });

  test('platform errors do not reach the caller', () async {
    final logs = captureLogs();
    handle((call) async => throw PlatformException(code: '-3'));

    await expectLater(gateway.update(), completes);
    expect(logs, [startsWith('Home widget call failed')]);
  });

  test('a missing plugin does not reach the caller', () async {
    final logs = captureLogs();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, null);

    await expectLater(gateway.save('leave_widget_data', '{}'), completes);
    expect(logs, [startsWith('Home widget unavailable')]);
  });
}
