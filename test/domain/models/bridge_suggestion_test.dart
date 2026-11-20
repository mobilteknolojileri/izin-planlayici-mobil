import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/domain/models/models.dart';

void main() {
  BridgeSuggestion suggestion({required double leaveDaysUsed}) =>
      BridgeSuggestion(
        leaveDays: [DateTime.utc(2026, 10, 30)],
        vacation: DateRange(
          start: DateTime.utc(2026, 10, 29),
          end: DateTime.utc(2026, 11),
        ),
        totalDaysOff: 4,
        leaveDaysUsed: leaveDaysUsed,
      );

  test('efficiency is days off per leave day', () {
    expect(suggestion(leaveDaysUsed: 0.5).efficiency, 8);
  });

  test('efficiency without leave days is the days off', () {
    expect(suggestion(leaveDaysUsed: 0).efficiency, 4);
  });

  test('JSON round trip', () {
    final value = suggestion(leaveDaysUsed: 1);
    expect(BridgeSuggestion.fromJson(value.toJson()), value);
  });
}
