import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/domain/bridge/compare_bridge_suggestions.dart';
import 'package:izin_planla/domain/models/models.dart';

void main() {
  BridgeSuggestion s(int startDay, int length, double cost) {
    final start = DateTime.utc(2027, 3, startDay);
    return BridgeSuggestion(
      leaveDays: [start],
      vacation: DateRange(
        start: start,
        end: DateTime.utc(2027, 3, startDay + length - 1),
      ),
      totalDaysOff: length,
      leaveDaysUsed: cost,
    );
  }

  test('higher efficiency comes first', () {
    expect(compareBridgeSuggestions(s(1, 6, 0.5), s(1, 9, 1.5)), lessThan(0));
    expect(compareBridgeSuggestions(s(1, 4, 1), s(1, 6, 0.5)), greaterThan(0));
  });

  test('equal efficiency puts the longer break first', () {
    expect(compareBridgeSuggestions(s(9, 6, 1), s(6, 9, 1.5)), greaterThan(0));
    expect(compareBridgeSuggestions(s(6, 9, 1.5), s(9, 6, 1)), lessThan(0));
  });

  test('equal efficiency and length puts the earlier break first', () {
    expect(compareBridgeSuggestions(s(2, 4, 1), s(9, 4, 1)), lessThan(0));
  });

  test('a free suggestion beats every paid one', () {
    expect(compareBridgeSuggestions(s(1, 3, 0), s(9, 9, 0.5)), lessThan(0));
    expect(compareBridgeSuggestions(s(9, 9, 0.5), s(1, 3, 0)), greaterThan(0));
    expect(compareBridgeSuggestions(s(1, 3, 0), s(9, 6, 0)), greaterThan(0));
  });

  test('a suggestion equals itself', () {
    expect(compareBridgeSuggestions(s(1, 4, 1), s(1, 4, 1)), 0);
  });
}
