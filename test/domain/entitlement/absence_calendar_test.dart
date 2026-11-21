import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/domain/entitlement/absence_calendar.dart';
import 'package:izin_planla/domain/models/models.dart';

DateRange _range(DateTime start, DateTime end) =>
    DateRange(start: start, end: end);

void main() {
  final serviceStart = DateTime.utc(2020);

  group('daysBefore', () {
    test('no absence counts nothing', () {
      final calendar = AbsenceCalendar(const [], from: serviceStart);

      expect(calendar.isEmpty, isTrue);
      expect(calendar.daysBefore(DateTime.utc(2030)), 0);
    });

    test('counts only days strictly before the given day', () {
      final calendar = AbsenceCalendar([
        _range(DateTime.utc(2020, 6), DateTime.utc(2020, 6, 10)),
      ], from: serviceStart);

      expect(calendar.isEmpty, isFalse);
      expect(calendar.daysBefore(DateTime.utc(2020, 6)), 0);
      expect(calendar.daysBefore(DateTime.utc(2020, 6, 5)), 4);
      expect(calendar.daysBefore(DateTime.utc(2020, 6, 11)), 10);
      expect(calendar.daysBefore(DateTime.utc(2021)), 10);
    });

    test('overlapping and repeated days count once', () {
      final calendar = AbsenceCalendar([
        _range(DateTime.utc(2020, 6, 5), DateTime.utc(2020, 6, 15)),
        _range(DateTime.utc(2020, 6), DateTime.utc(2020, 6, 10)),
        _range(DateTime.utc(2020, 6, 7), DateTime.utc(2020, 6, 8)),
      ], from: serviceStart);

      expect(calendar.daysBefore(DateTime.utc(2021)), 15);
    });

    test('adjacent periods add up', () {
      final calendar = AbsenceCalendar([
        _range(DateTime.utc(2020, 6, 11), DateTime.utc(2020, 6, 20)),
        _range(DateTime.utc(2020, 6), DateTime.utc(2020, 6, 10)),
      ], from: serviceStart);

      expect(calendar.daysBefore(DateTime.utc(2021)), 20);
    });

    test('days before the service start are ignored', () {
      final calendar = AbsenceCalendar([
        _range(DateTime.utc(2019, 12, 25), DateTime.utc(2020, 1, 5)),
      ], from: serviceStart);
      final before = AbsenceCalendar([
        _range(DateTime.utc(2019, 3), DateTime.utc(2019, 12, 31)),
      ], from: serviceStart);

      expect(calendar.daysBefore(DateTime.utc(2021)), 5);
      expect(before.isEmpty, isTrue);
    });
  });

  group('shift', () {
    test('without absences the anniversary stays', () {
      final calendar = AbsenceCalendar(const [], from: serviceStart);

      expect(calendar.shift(DateTime.utc(2021)), DateTime.utc(2021));
    });

    test('moves the anniversary by the absent days before it', () {
      final calendar = AbsenceCalendar([
        _range(DateTime.utc(2020, 6), DateTime.utc(2020, 6, 10)),
      ], from: serviceStart);

      expect(calendar.shift(DateTime.utc(2021)), DateTime.utc(2021, 1, 11));
    });

    test('an absence over the anniversary counts in full', () {
      final calendar = AbsenceCalendar([
        _range(DateTime.utc(2020, 12, 25), DateTime.utc(2021, 1, 10)),
      ], from: serviceStart);

      expect(calendar.shift(DateTime.utc(2021)), DateTime.utc(2021, 1, 18));
    });

    test('an absence reached by the shift also counts', () {
      final calendar = AbsenceCalendar([
        _range(DateTime.utc(2020, 12, 30), DateTime.utc(2020, 12, 31)),
        _range(DateTime.utc(2021, 1, 2), DateTime.utc(2021, 1, 3)),
      ], from: serviceStart);

      expect(calendar.shift(DateTime.utc(2021)), DateTime.utc(2021, 1, 5));
    });

    test('an absence starting on the anniversary does not move it', () {
      final calendar = AbsenceCalendar([
        _range(DateTime.utc(2021), DateTime.utc(2021, 1, 5)),
      ], from: serviceStart);

      expect(calendar.shift(DateTime.utc(2021)), DateTime.utc(2021));
      expect(calendar.shift(DateTime.utc(2022)), DateTime.utc(2022, 1, 6));
    });
  });
}
