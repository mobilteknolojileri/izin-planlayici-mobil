import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/services/home_widget/home_widget_entry.dart';

const _entry = HomeWidgetEntry(
  value: '4,5',
  caption: 'gün izin hakkın kaldı',
  holiday: 'Bugün resmî tatil: Yılbaşı',
  description: '4,5 gün izin hakkın kaldı. Bugün resmî tatil: Yılbaşı',
);

void main() {
  test('toJson uses the keys of the Kotlin provider', () {
    expect(_entry.toJson(), {
      'value': '4,5',
      'caption': 'gün izin hakkın kaldı',
      'holiday': 'Bugün resmî tatil: Yılbaşı',
      'description': '4,5 gün izin hakkın kaldı. Bugün resmî tatil: Yılbaşı',
    });
  });

  test('entries with the same texts are equal', () {
    const same = HomeWidgetEntry(
      value: '4,5',
      caption: 'gün izin hakkın kaldı',
      holiday: 'Bugün resmî tatil: Yılbaşı',
      description: '4,5 gün izin hakkın kaldı. Bugün resmî tatil: Yılbaşı',
    );
    const other = HomeWidgetEntry(
      value: '5',
      caption: 'gün izin hakkın kaldı',
      holiday: 'Bugün resmî tatil: Yılbaşı',
      description: '5 gün izin hakkın kaldı. Bugün resmî tatil: Yılbaşı',
    );

    expect(_entry, same);
    expect(_entry.hashCode, same.hashCode);
    expect(_entry, isNot(other));
  });
}
