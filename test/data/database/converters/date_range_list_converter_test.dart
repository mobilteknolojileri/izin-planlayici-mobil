import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/database/converters/date_range_list_converter.dart';
import 'package:izin_planla/domain/models/models.dart';

void main() {
  const converter = DateRangeListConverter();

  test('stores ranges as JSON objects with start and end days', () {
    final ranges = [
      DateRange(start: DateTime.utc(2024, 5), end: DateTime.utc(2024, 5, 20)),
    ];

    expect(
      converter.toSql(ranges),
      '[{"start":"2024-05-01","end":"2024-05-20"}]',
    );
  });

  test('round-trips ranges and keeps their order', () {
    final ranges = [
      DateRange(start: DateTime.utc(2024, 5), end: DateTime.utc(2024, 5, 20)),
      DateRange(start: DateTime.utc(2023, 1, 10), end: DateTime.utc(2023, 2)),
    ];

    expect(converter.fromSql(converter.toSql(ranges)), ranges);
  });
}
