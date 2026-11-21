import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/database/converters/day_converter.dart';

void main() {
  const converter = DayConverter();

  test('stores a day as yyyy-MM-dd text', () {
    expect(converter.toSql(DateTime.utc(2026, 3, 9)), '2026-03-09');
  });

  test('reads a day back as UTC midnight', () {
    final day = converter.fromSql('2026-10-28');

    expect(day, DateTime.utc(2026, 10, 28));
    expect(day.isUtc, isTrue);
  });

  test('drops the time of day', () {
    expect(converter.toSql(DateTime.utc(2026, 1, 1, 23, 59)), '2026-01-01');
  });
}
