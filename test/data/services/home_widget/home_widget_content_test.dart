import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/services/home_widget/home_widget_content.dart';
import 'package:izin_planla/data/services/home_widget/home_widget_entry.dart';
import 'package:izin_planla/domain/models/models.dart';

const _entry = HomeWidgetEntry(
  value: '18',
  caption: 'gün izin hakkın kaldı',
  holiday: 'Yarın resmî tatil: Yılbaşı',
  description: '18 gün izin hakkın kaldı. Yarın resmî tatil: Yılbaşı',
);

const _fallback = HomeWidgetEntry(
  value: '',
  caption: 'Güncel bilgi için uygulamayı aç',
  holiday: '',
  description: 'Güncel bilgi için uygulamayı aç',
);

void main() {
  test('dateKey pads month and day like the Kotlin side', () {
    expect(HomeWidgetContent.dateKey(DateTime.utc(2027, 1, 9)), '2027-01-09');
    expect(HomeWidgetContent.dateKey(DateTime(2026, 12, 31, 23)), '2026-12-31');
  });

  test('encode writes the layout the Kotlin provider reads', () {
    for (final mode in AppThemeMode.values) {
      final content = HomeWidgetContent(
        themeMode: mode,
        days: const {'2026-12-31': _entry},
        fallback: _fallback,
      );

      expect(jsonDecode(content.encode()), {
        'version': 1,
        'theme': mode.name,
        'days': {'2026-12-31': _entry.toJson()},
        'fallback': _fallback.toJson(),
      });
    }
  });

  test('theme names match the Kotlin constants', () {
    expect(AppThemeMode.values.map((mode) => mode.name), [
      'system',
      'light',
      'dark',
    ]);
  });
}
