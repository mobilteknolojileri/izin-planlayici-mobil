import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/domain/entitlement/calendar_arithmetic.dart';
import 'package:izin_planla/domain/models/models.dart';

void main() {
  group('dateOnly', () {
    test('drops the time of day and returns UTC midnight', () {
      final day = DateTime(2024, 3, 5, 14, 30).dateOnly;

      expect(day, DateTime.utc(2024, 3, 5));
      expect(day.isUtc, isTrue);
    });
  });

  group('plusYears', () {
    test('keeps the calendar day', () {
      expect(DateTime.utc(2021, 3, 10).plusYears(1), DateTime.utc(2022, 3, 10));
    });

    test('29 February becomes 28 February in a non-leap year', () {
      final leapDay = DateTime.utc(2020, 2, 29);

      expect(leapDay.plusYears(1), DateTime.utc(2021, 2, 28));
      expect(leapDay.plusYears(4), DateTime.utc(2024, 2, 29));
      expect(leapDay.plusYears(-1), DateTime.utc(2019, 2, 28));
    });
  });

  group('plusDays', () {
    test('crosses month and year ends', () {
      expect(DateTime.utc(2020, 12, 25).plusDays(10), DateTime.utc(2021, 1, 4));
      expect(DateTime.utc(2024, 3).plusDays(-1), DateTime.utc(2024, 2, 29));
    });
  });

  group('minusService', () {
    test('zero duration keeps the day', () {
      final day = DateTime.utc(2024, 3, 10);

      expect(day.minusService(const ServiceDuration()), day);
    });

    test('subtracts years and months, then days', () {
      const fourYearsSixMonths = ServiceDuration(years: 4, months: 6);
      const mixed = ServiceDuration(years: 2, months: 3, days: 4);

      expect(
        DateTime.utc(2022, 5).minusService(fourYearsSixMonths),
        DateTime.utc(2017, 11),
      );
      expect(
        DateTime.utc(2024, 1, 2).minusService(mixed),
        DateTime.utc(2021, 9, 28),
      );
      expect(
        DateTime.utc(2024, 3, 10).minusService(const ServiceDuration(days: 15)),
        DateTime.utc(2024, 2, 24),
      );
    });

    test('moves to the last day of a shorter month', () {
      final day = DateTime.utc(2024, 3, 31);

      expect(
        day.minusService(const ServiceDuration(months: 1)),
        DateTime.utc(2024, 2, 29),
      );
      expect(
        day.minusService(const ServiceDuration(years: 1, months: 1)),
        DateTime.utc(2023, 2, 28),
      );
    });
  });

  group('completedYearsUntil', () {
    test('a year completes on the anniversary', () {
      final birth = DateTime.utc(2000, 6, 15);

      expect(birth.completedYearsUntil(DateTime.utc(2050, 6, 14)), 49);
      expect(birth.completedYearsUntil(DateTime.utc(2050, 6, 15)), 50);
    });

    test('a 29 February birthday completes on 28 February (TBK md. 92/3)', () {
      final birth = DateTime.utc(2000, 2, 29);

      expect(birth.completedYearsUntil(DateTime.utc(2018, 2, 27)), 17);
      expect(birth.completedYearsUntil(DateTime.utc(2018, 2, 28)), 18);
      expect(birth.completedYearsUntil(DateTime.utc(2020, 2, 28)), 19);
      expect(birth.completedYearsUntil(DateTime.utc(2020, 2, 29)), 20);
    });

    test('ignores the time of day', () {
      final start = DateTime(2000, 6, 15, 23);

      expect(start.completedYearsUntil(DateTime(2001, 6, 15)), 1);
    });
  });

  group('isoDate', () {
    test('formats as yyyy-MM-dd', () {
      expect(DateTime.utc(2026, 1, 5).isoDate, '2026-01-05');
    });
  });
}
