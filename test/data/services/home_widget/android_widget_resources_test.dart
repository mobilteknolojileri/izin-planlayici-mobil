import 'dart:io';
import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/services/home_widget/home_widget_content.dart';
import 'package:izin_planla/data/services/home_widget/plugin_home_widget_gateway.dart';

// Contract between the Dart side and the Android files of the widget, which
// no Dart analyzer checks. Paths are relative to the project root, where
// `flutter test` runs.

const _res = 'android/app/src/main/res';
const _provider =
    'android/app/src/main/kotlin/com/izinplanla/app/widget/'
    'LeaveWidgetProvider.kt';

String _read(String path) => File(path).readAsStringSync();

/// WCAG 2 relative luminance of an `RRGGBB` colour.
double _luminance(String hex) {
  double channel(int start) {
    final value = int.parse(hex.substring(start, start + 2), radix: 16) / 255;
    return value <= 0.04045
        ? value / 12.92
        : math.pow((value + 0.055) / 1.055, 2.4).toDouble();
  }

  return 0.2126 * channel(0) + 0.7152 * channel(2) + 0.0722 * channel(4);
}

double _contrast(String a, String b) {
  final la = _luminance(a);
  final lb = _luminance(b);
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

void main() {
  test('Kotlin reads the key the service writes', () {
    expect(
      _read(_provider),
      contains('DATA_KEY = "${HomeWidgetContent.storageKey}"'),
    );
  });

  test('the gateway names the Kotlin provider class', () {
    final source = _read(_provider);
    final package = RegExp(
      r'^package ([\w.]+)',
      multiLine: true,
    ).firstMatch(source)!.group(1);

    expect(source, contains('class LeaveWidgetProvider'));
    expect(
      PluginHomeWidgetGateway.providerName,
      '$package.LeaveWidgetProvider',
    );
  });

  test('Kotlin and XML hold no user-visible Turkish text', () {
    final turkish = RegExp('[çğıöşüÇĞİÖŞÜâîû]');
    for (final path in [
      _provider,
      '$_res/layout/leave_widget.xml',
      '$_res/xml/leave_widget_info.xml',
    ]) {
      expect(turkish.hasMatch(_read(path)), isFalse, reason: path);
    }
    final layout = _read('$_res/layout/leave_widget.xml');
    for (final match in RegExp(
      'android:(?:text|contentDescription)="([^"]*)"',
    ).allMatches(layout)) {
      expect(match.group(1), startsWith('@string/'));
    }
  });

  group('text contrast on the widget backgrounds', () {
    for (final theme in ['light', 'dark']) {
      test('$theme gradient keeps white and muted text at AA', () {
        final drawable = _read('$_res/drawable/widget_background_$theme.xml');
        final colors = RegExp(
          'android:(?:start|end)Color="#FF([0-9A-Fa-f]{6})"',
        ).allMatches(drawable).map((m) => m.group(1)!).toList();

        expect(colors, hasLength(2));
        for (final background in colors) {
          // White body text and AppPalette.blue91 for the holiday line.
          expect(_contrast('FFFFFF', background), greaterThanOrEqualTo(4.5));
          expect(_contrast('DDE4FF', background), greaterThanOrEqualTo(4.5));
        }
      });
    }

    test('Kotlin uses the checked muted colour', () {
      expect(_read(_provider), contains('0xFFDDE4FF'));
    });
  });
}
