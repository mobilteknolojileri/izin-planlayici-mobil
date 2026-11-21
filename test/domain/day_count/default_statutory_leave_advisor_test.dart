import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/domain/day_count/default_statutory_leave_advisor.dart';
import 'package:izin_planla/domain/models/models.dart';

import 'day_count_fixtures.dart';

void main() {
  const advisor = DefaultStatutoryLeaveAdvisor();

  group('4857', () {
    final worker = laborLaw();

    test('excuse leave of Ek md. 2', () {
      expect(advisor.suggestedDays(LeaveType.marriage, worker), 3);
      expect(advisor.suggestedDays(LeaveType.adoption, worker), 3);
      expect(advisor.suggestedDays(LeaveType.bereavement, worker), 3);
      expect(advisor.suggestedDays(LeaveType.disabledChildCare, worker), 10);
    });

    test('paternity is 10 days for births from 1 May 2026', () {
      expect(
        advisor.suggestedDays(
          LeaveType.paternity,
          worker,
          eventDate: day(2026, 5, 1),
        ),
        10,
      );
      expect(
        advisor.suggestedDays(
          LeaveType.paternity,
          worker,
          eventDate: day(2026, 4, 30),
        ),
        5,
      );
    });

    test('paternity without a birth date uses the law in force', () {
      expect(advisor.suggestedDays(LeaveType.paternity, worker), 10);
    });

    test('a local birth date is compared by day', () {
      expect(
        advisor.suggestedDays(
          LeaveType.paternity,
          worker,
          eventDate: DateTime(2026, 5, 1, 23, 30),
        ),
        10,
      );
    });

    test('maternity is 24 weeks', () {
      expect(advisor.suggestedDays(LeaveType.maternity, worker), 168);
    });

    test('types without a legal number', () {
      for (final type in [
        LeaveType.annual,
        LeaveType.sick,
        LeaveType.unpaid,
        LeaveType.union,
        LeaveType.excuse,
        LeaveType.travel,
        LeaveType.other,
      ]) {
        expect(advisor.suggestedDays(type, worker), isNull, reason: '$type');
      }
    });
  });

  group('657', () {
    final servant = civilServant();

    test('excuse leave of md. 104', () {
      expect(advisor.suggestedDays(LeaveType.marriage, servant), 7);
      expect(advisor.suggestedDays(LeaveType.bereavement, servant), 7);
      expect(advisor.suggestedDays(LeaveType.excuse, servant), 10);
      expect(advisor.suggestedDays(LeaveType.disabledChildCare, servant), 10);
      expect(advisor.suggestedDays(LeaveType.maternity, servant), 168);
    });

    test('paternity is 10 days whatever the birth date', () {
      expect(
        advisor.suggestedDays(
          LeaveType.paternity,
          servant,
          eventDate: day(2026, 4, 30),
        ),
        10,
      );
    });

    test('types without a legal number', () {
      for (final type in [
        LeaveType.annual,
        LeaveType.sick,
        LeaveType.unpaid,
        LeaveType.adoption,
        LeaveType.union,
        LeaveType.travel,
        LeaveType.other,
      ]) {
        expect(advisor.suggestedDays(type, servant), isNull, reason: '$type');
      }
    });
  });
}
