import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/domain/models/date_only_converter.dart';

void main() {
  const converter = DateOnlyConverter();

  test('parses a date to UTC midnight', () {
    expect(converter.fromJson('2026-10-29'), DateTime.utc(2026, 10, 29));
  });

  test('drops the time part when parsing', () {
    expect(
      converter.fromJson('2026-10-29T23:59:00+03:00'),
      DateTime.utc(2026, 10, 29),
    );
  });

  test('formats with zero padding', () {
    expect(converter.toJson(DateTime.utc(2027, 1, 2)), '2027-01-02');
  });
}
