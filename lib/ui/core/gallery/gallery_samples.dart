import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/ui/core/theme/meaning.dart';
import 'package:izin_planla/ui/core/widgets/week_strip_day.dart';

/// Sample data for the gallery and the component tests.
abstract final class GallerySamples {
  /// Bridge around 23 April 2026: holiday Thursday, leave Friday, weekend.
  static final bridgeDays = [
    WeekStripDay(date: DateTime.utc(2026, 4, 22), meaning: Meaning.workday),
    WeekStripDay(date: DateTime.utc(2026, 4, 23), meaning: Meaning.holiday),
    WeekStripDay(date: DateTime.utc(2026, 4, 24), meaning: Meaning.bridge),
    WeekStripDay(date: DateTime.utc(2026, 4, 25), meaning: Meaning.weekend),
    WeekStripDay(date: DateTime.utc(2026, 4, 26), meaning: Meaning.weekend),
    WeekStripDay(date: DateTime.utc(2026, 4, 27), meaning: Meaning.workday),
  ];

  /// Bridge after Ramazan Bayramı 2027: eve Monday, holiday Tuesday to
  /// Thursday, leave Friday, weekend.
  static final homeBridgeDays = [
    WeekStripDay(date: DateTime.utc(2027, 3, 8), meaning: Meaning.eve),
    WeekStripDay(date: DateTime.utc(2027, 3, 9), meaning: Meaning.holiday),
    WeekStripDay(date: DateTime.utc(2027, 3, 10), meaning: Meaning.holiday),
    WeekStripDay(date: DateTime.utc(2027, 3, 11), meaning: Meaning.holiday),
    WeekStripDay(date: DateTime.utc(2027, 3, 12), meaning: Meaning.bridge),
    WeekStripDay(date: DateTime.utc(2027, 3, 13), meaning: Meaning.weekend),
    WeekStripDay(date: DateTime.utc(2027, 3, 14), meaning: Meaning.weekend),
  ];

  /// Leave from 27 to 30 October 2026 under Labour Law 4857.
  static final breakdown = [
    DayBreakdown(
      date: DateTime.utc(2026, 10, 27),
      value: 1,
      reason: DayReason.workday,
    ),
    DayBreakdown(
      date: DateTime.utc(2026, 10, 28),
      value: 0.5,
      reason: DayReason.halfDayHoliday,
      holidayName: 'Cumhuriyet Bayramı Arifesi',
    ),
    DayBreakdown(
      date: DateTime.utc(2026, 10, 29),
      value: 0,
      reason: DayReason.holiday,
      holidayName: 'Cumhuriyet Bayramı',
    ),
    DayBreakdown(
      date: DateTime.utc(2026, 10, 30),
      value: 1,
      reason: DayReason.workday,
    ),
    DayBreakdown(
      date: DateTime.utc(2026, 10, 31),
      value: 0,
      reason: DayReason.contractualRest,
    ),
  ];
}
