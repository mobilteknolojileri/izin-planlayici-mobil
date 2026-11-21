import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/ui/core/app_format.dart';

void main() {
  setUpAll(() => initializeDateFormatting('tr'));

  String range(DateTime start, DateTime end) =>
      AppFormat.dayRange(DateRange(start: start, end: end), 'tr');

  group('dayRange', () {
    test('writes the month once inside one month', () {
      expect(
        range(DateTime(2026, 7, 6), DateTime(2026, 7, 10)),
        '6-10 Temmuz 2026',
      );
    });

    test('names both months across a month end', () {
      expect(
        range(DateTime(2026, 10, 29), DateTime(2026, 11)),
        '29 Ekim-1 Kasım 2026',
      );
    });

    test('names both years across a year end', () {
      expect(
        range(DateTime(2026, 12, 28), DateTime(2027, 1, 3)),
        '28 Aralık 2026-3 Ocak 2027',
      );
    });

    test('writes a single day in full', () {
      expect(
        range(DateTime(2026, 7, 6), DateTime(2026, 7, 6)),
        '6 Temmuz 2026, Pazartesi',
      );
    });
  });
}
