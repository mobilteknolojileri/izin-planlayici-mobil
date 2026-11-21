import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/database/converters/day_list_converter.dart';

void main() {
  const converter = DayListConverter();

  test('stores days as a JSON array of yyyy-MM-dd strings', () {
    final days = [DateTime.utc(2026, 1, 2), DateTime.utc(2025, 12)];

    expect(converter.toSql(days), '["2026-01-02","2025-12-01"]');
  });

  test('round-trips days and keeps their order', () {
    final days = [DateTime.utc(2026, 1, 2), DateTime.utc(2025, 12)];

    expect(converter.fromSql(converter.toSql(days)), days);
  });
}
