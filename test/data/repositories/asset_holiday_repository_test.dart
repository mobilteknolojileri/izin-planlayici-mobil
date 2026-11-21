import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/repositories/asset_holiday_repository.dart';
import 'package:izin_planla/domain/models/models.dart';

/// Serves one JSON text for any key and counts the reads.
final class _JsonBundle extends AssetBundle {
  new(this.json);

  final String json;
  int loads = 0;

  @override
  Future<ByteData> load(String key) async {
    loads++;
    return ByteData.sublistView(utf8.encode(json));
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    loads++;
    return json;
  }
}

String _document(List<Map<String, Object>> holidays) => jsonEncode({
  'source': ['https://example.org'],
  'generatedAt': '2026-11-20',
  'holidays': holidays,
});

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('bundled file', () {
    final repository = AssetHolidayRepository();

    test('covers 2026 to 2028 in date order', () async {
      final holidays = await repository.all();
      final dates = [for (final h in holidays) h.date];

      expect(holidays, isNotEmpty);
      expect({for (final d in dates) d.year}, {2026, 2027, 2028});
      expect(dates, [...dates]..sort());
      expect(dates.every((d) => d.isUtc), isTrue);
    });

    test('contains every holiday type and half days only on eves', () async {
      final holidays = await repository.all();

      expect({for (final h in holidays) h.type}, HolidayType.values.toSet());
      expect(
        holidays
            .where((h) => h.halfDay)
            .every((h) => h.type == HolidayType.eve),
        isTrue,
      );
    });

    test('includes New Year and Republic Day of 2027', () async {
      final holidays = await repository.inRange(
        DateRange(start: DateTime.utc(2027), end: DateTime.utc(2027, 12, 31)),
      );
      final dates = {for (final h in holidays) h.date};

      expect(dates, contains(DateTime.utc(2027)));
      expect(dates, contains(DateTime.utc(2027, 10, 29)));
      expect(holidays.every((h) => h.date.year == 2027), isTrue);
    });
  });

  group('queries', () {
    final bundle = _JsonBundle(
      _document([
        {
          'date': '2026-10-29',
          'name': 'Cumhuriyet Bayramı',
          'type': 'national',
          'halfDay': false,
        },
        {
          'date': '2026-01-01',
          'name': 'Yılbaşı',
          'type': 'national',
          'halfDay': false,
        },
        {
          'date': '2026-10-28',
          'name': 'Cumhuriyet Bayramı Arifesi',
          'type': 'eve',
          'halfDay': true,
        },
      ]),
    );
    final repository = AssetHolidayRepository(bundle: bundle);

    test('all sorts the file by date', () async {
      final holidays = await repository.all();

      expect(
        [for (final h in holidays) h.date],
        [
          DateTime.utc(2026),
          DateTime.utc(2026, 10, 28),
          DateTime.utc(2026, 10, 29),
        ],
      );
      expect(holidays[1].halfDay, isTrue);
    });

    test('inRange includes both ends', () async {
      final holidays = await repository.inRange(
        DateRange(
          start: DateTime.utc(2026, 10, 28),
          end: DateTime.utc(2026, 10, 29),
        ),
      );

      expect(holidays, hasLength(2));
    });

    test('inRange is empty for a range without holidays', () async {
      final holidays = await repository.inRange(
        DateRange(start: DateTime.utc(2026, 2), end: DateTime.utc(2026, 2, 28)),
      );

      expect(holidays, isEmpty);
    });

    test('reads the file only once', () async {
      await repository.all();
      await repository.inRange(
        DateRange(start: DateTime.utc(2026), end: DateTime.utc(2026, 12, 31)),
      );

      expect(bundle.loads, 1);
    });

    test('the returned list cannot be changed', () async {
      final holidays = await repository.all();

      expect(holidays.clear, throwsUnsupportedError);
    });
  });
}
