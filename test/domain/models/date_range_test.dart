import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/domain/models/date_range.dart';

void main() {
  final range = DateRange(
    start: DateTime.utc(2026, 12, 30),
    end: DateTime.utc(2027, 1, 2),
  );

  test('dayCount includes both ends across a year change', () {
    expect(range.dayCount, 4);
  });

  test('contains is inclusive', () {
    expect(range.contains(DateTime.utc(2026, 12, 30)), isTrue);
    expect(range.contains(DateTime.utc(2027, 1, 2)), isTrue);
    expect(range.contains(DateTime.utc(2027, 1, 3)), isFalse);
  });

  test('end before start is rejected', () {
    expect(
      () => DateRange(start: DateTime.utc(2026, 2), end: DateTime.utc(2026)),
      throwsA(isA<AssertionError>()),
    );
  });
}
