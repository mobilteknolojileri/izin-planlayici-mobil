import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/domain/models/models.dart';

void main() {
  test('bundled holiday file parses into Holiday values', () {
    final json = jsonDecode(
      File('assets/holidays/tr_2026_2028.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    final holidays = [
      for (final item in json['holidays'] as List<dynamic>)
        Holiday.fromJson(item as Map<String, dynamic>),
    ];

    expect(holidays, isNotEmpty);
    expect(holidays.first.date, DateTime.utc(2026));
    expect(
      holidays.where((h) => h.type == HolidayType.eve),
      everyElement(predicate<Holiday>((h) => h.halfDay)),
    );
  });
}
