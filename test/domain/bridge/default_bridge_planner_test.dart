import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/domain/bridge/compare_bridge_suggestions.dart';
import 'package:izin_planla/domain/bridge/default_bridge_planner.dart';
import 'package:izin_planla/domain/models/models.dart';

import 'bridge_test_data.dart';
import 'rule_based_leave_day_counter.dart';

void main() {
  final holidays = bundledHolidays();
  late RuleBasedLeaveDayCounter counter;
  late DefaultBridgePlanner planner;

  setUp(() {
    counter = RuleBasedLeaveDayCounter();
    planner = DefaultBridgePlanner(counter: counter);
  });

  List<BridgeSuggestion> suggest(
    int year, {
    Profile? profile,
    List<Holiday>? holidayList,
    double? budget,
    int maxLeaveDays = 5,
  }) => planner.suggestions(
    year: year,
    profile: profile ?? laborProfile(),
    holidays: holidayList ?? holidays,
    budget: budget,
    maxLeaveDays: maxLeaveDays,
  );

  List<BridgeSuggestion> plan(
    int year,
    double budget, {
    Profile? profile,
    List<Holiday>? holidayList,
  }) => planner.optimalPlan(
    year: year,
    profile: profile ?? laborProfile(),
    holidays: holidayList ?? holidays,
    budget: budget,
  );

  BridgeSuggestion? find(
    List<BridgeSuggestion> list,
    DateTime start,
    DateTime end,
  ) {
    for (final s in list) {
      if (s.vacation.start == start && s.vacation.end == end) return s;
    }
    return null;
  }

  int daysOff(List<BridgeSuggestion> list) =>
      list.fold(0, (sum, s) => sum + s.totalDaysOff);

  double used(List<BridgeSuggestion> list) =>
      list.fold(0, (sum, s) => sum + s.leaveDaysUsed);

  group('2027 vectors, Labour Law Monday-Friday', () {
    test('Ramazan: Friday 12 March gives 9-14 March', () {
      final s = find(suggest(2027), day(2027, 3, 9), day(2027, 3, 14));
      expect(s, isNotNull);
      expect(s!.leaveDays, [day(2027, 3, 12)]);
      expect(s.totalDaysOff, 6);
      expect(s.leaveDaysUsed, 1);
      expect(s.efficiency, 6);
      expect(s.holidayNames, [
        'Ramazan Bayramı 1. Gün',
        'Ramazan Bayramı 2. Gün',
        'Ramazan Bayramı 3. Gün',
      ]);
    });

    test('Ramazan: the eve morning costs half a day', () {
      final s = find(suggest(2027), day(2027, 3, 6), day(2027, 3, 11));
      expect(s!.leaveDays, [day(2027, 3, 8)]);
      expect(s.totalDaysOff, 6);
      expect(s.leaveDaysUsed, 0.5);
      expect(s.efficiency, 12);
      expect(s.holidayNames.first, 'Ramazan Bayramı Arifesi');
    });

    test('Ramazan: eve and Friday give 6-14 March for 1.5 days', () {
      final s = find(suggest(2027), day(2027, 3, 6), day(2027, 3, 14));
      expect(s!.leaveDays, [day(2027, 3, 8), day(2027, 3, 12)]);
      expect(s.totalDaysOff, 9);
      expect(s.leaveDaysUsed, 1.5);
    });

    test('Kurban: the Saturday eve is free, 2 days give 15-23 May', () {
      final s = find(suggest(2027), day(2027, 5, 15), day(2027, 5, 23));
      expect(s!.leaveDays, [day(2027, 5, 20), day(2027, 5, 21)]);
      expect(s.totalDaysOff, 9);
      expect(s.leaveDaysUsed, 2);
      expect(s.holidayNames.first, 'Kurban Bayramı Arifesi');
      expect(
        s.holidayNames.last,
        "Kurban Bayramı 4. Gün ve Atatürk'ü Anma, Gençlik ve Spor Bayramı",
      );
    });

    test('Thursday holiday and a Friday leave give 4 days', () {
      final s = find(suggest(2027), day(2027, 7, 15), day(2027, 7, 18));
      expect(s!.leaveDays, [day(2027, 7, 16)]);
      expect(s.totalDaysOff, 4);
      expect(s.leaveDaysUsed, 1);
      expect(s.holidayNames, ['Demokrasi ve Milli Birlik Günü']);
    });

    test('28 October morning joins the Friday holiday', () {
      final s = find(suggest(2027), day(2027, 10, 28), day(2027, 10, 31));
      expect(s!.leaveDays, [day(2027, 10, 28)]);
      expect(s.leaveDaysUsed, 0.5);
      expect(s.efficiency, 8);
    });

    test('a holiday on a non-working Saturday alone makes no bridge', () {
      final list = suggest(2027);
      expect(
        list.where(
          (s) =>
              s.vacation.contains(day(2027, 5, 1)) &&
              !s.vacation.contains(day(2027, 4, 23)),
        ),
        isEmpty,
      );
      expect(
        list.where((s) => s.vacation.contains(day(2027, 5, 1))),
        isNotEmpty,
        reason: 'a break from 23 April may still reach 1 May',
      );
    });
  });

  group('2026 and 2028 vectors', () {
    test('Thursday New Year and a Friday leave give 1-4 January', () {
      final s = find(suggest(2026), day(2026, 1, 1), day(2026, 1, 4));
      expect(s!.leaveDays, [day(2026, 1, 2)]);
      expect(s.leaveDaysUsed, 1);
    });

    test('Republic Day 2026 matches the screen sample', () {
      final s = find(suggest(2026), day(2026, 10, 29), day(2026, 11, 1));
      expect(s!.leaveDays, [day(2026, 10, 30)]);
      expect(s.totalDaysOff, 4);
      expect(s.leaveDaysUsed, 1);
      expect(s.holidayNames, ['Cumhuriyet Bayramı']);
    });

    test('Kurban 2026 joins both weekends for 1.5 days', () {
      final s = find(suggest(2026), day(2026, 5, 23), day(2026, 5, 31));
      expect(s!.leaveDays, [day(2026, 5, 25), day(2026, 5, 26)]);
      expect(s.totalDaysOff, 9);
      expect(s.leaveDaysUsed, 1.5);
    });

    test('Kurban 2028: Thursday eve morning gives 4-8 May', () {
      final s = find(suggest(2028), day(2028, 5, 4), day(2028, 5, 8));
      expect(s!.leaveDays, [day(2028, 5, 4)]);
      expect(s.leaveDaysUsed, 0.5);
      expect(s.efficiency, 10);
    });

    test('Ramazan 2028: Friday eve morning gives 25-28 February', () {
      final s = find(suggest(2028), day(2028, 2, 25), day(2028, 2, 28));
      expect(s!.leaveDays, [day(2028, 2, 25)]);
      expect(s.leaveDaysUsed, 0.5);
    });
  });

  group('year boundary', () {
    test('31 December 2026 leave belongs to 2026 and reaches 2027', () {
      final s = find(suggest(2026), day(2026, 12, 31), day(2027, 1, 3));
      expect(s!.leaveDays, [day(2026, 12, 31)]);
      expect(s.holidayNames, ['Yılbaşı']);
    });

    test('2027 suggestions take leave only in 2027', () {
      for (final s in suggest(2027)) {
        expect(s.leaveDays.every((d) => d.year == 2027), isTrue);
      }
      expect(find(suggest(2027), day(2026, 12, 31), day(2027, 1, 3)), isNull);
    });

    test('holidays of other years give nothing', () {
      final only2026 = [
        for (final h in holidays)
          if (h.date.year == 2026) h,
      ];
      expect(suggest(2028, holidayList: only2026), isEmpty);
    });
  });

  group('ranking and grouping', () {
    test('best of every holiday first, by efficiency, length, date', () {
      final leaders = suggest(2027).take(7).map((s) => s.vacation).toList();
      expect(leaders, [
        DateRange(start: day(2027, 3, 6), end: day(2027, 3, 11)),
        DateRange(start: day(2027, 10, 28), end: day(2027, 10, 31)),
        DateRange(start: day(2027, 5, 14), end: day(2027, 5, 19)),
        DateRange(start: day(2027, 1, 1), end: day(2027, 1, 4)),
        DateRange(start: day(2027, 4, 22), end: day(2027, 4, 25)),
        DateRange(start: day(2027, 7, 15), end: day(2027, 7, 18)),
        DateRange(start: day(2027, 8, 27), end: day(2027, 8, 30)),
      ]);
    });

    test('alternatives follow the leaders in the same order', () {
      final list = suggest(2027);
      final leaders = list.take(7).toList();
      final others = list.skip(7).toList();
      bool sorted(List<BridgeSuggestion> l) => [
        for (var i = 1; i < l.length; i++)
          compareBridgeSuggestions(l[i - 1], l[i]),
      ].every((c) => c < 0);
      expect(sorted(leaders), isTrue);
      expect(sorted(others), isTrue);
      expect(others, isNotEmpty);
      for (final s in list) {
        expect(compareBridgeSuggestions(list.first, s), lessThanOrEqualTo(0));
      }
    });

    test('equal efficiency puts the longer break first', () {
      final list = suggest(2027);
      final nineDays = list.indexOf(
        find(list, day(2027, 3, 6), day(2027, 3, 14))!,
      );
      final sixDays = list.indexOf(
        find(list, day(2027, 3, 9), day(2027, 3, 14))!,
      );
      expect(nineDays, lessThan(sixDays));
    });

    test('the same input gives the same list', () {
      expect(suggest(2027), suggest(2027));
    });
  });

  group('one leave record per suggestion', () {
    test('cost is the counter result from first to last leave day', () {
      final list = suggest(2026);
      final check = RuleBasedLeaveDayCounter();
      for (final s in list) {
        final range = DateRange(
          start: s.leaveDays.first,
          end: s.leaveDays.last,
        );
        expect(counter.calls, contains(range));
        expect(
          check.count(range, laborProfile(), holidays).total,
          s.leaveDaysUsed,
        );
      }
    });

    test('every break is continuous and as long as it can be', () {
      final profile = laborProfile();
      final check = RuleBasedLeaveDayCounter();
      bool needsLeave(DateTime d) =>
          check.count(DateRange(start: d, end: d), profile, holidays).total > 0;
      for (final s in suggest(2027)) {
        expect(s.totalDaysOff, s.vacation.dayCount);
        expect(s.leaveDays.every(s.vacation.contains), isTrue);
        expect(s.leaveDaysUsed, lessThanOrEqualTo(5));
        final before = s.vacation.start.subtract(const Duration(days: 1));
        final after = s.vacation.end.add(const Duration(days: 1));
        expect(needsLeave(before), isTrue, reason: '$before');
        expect(needsLeave(after), isTrue, reason: '$after');
      }
    });
  });

  group('Saturday', () {
    final saturdayWorker = laborProfile(
      schedule: const WorkSchedule(workDays: [1, 2, 3, 4, 5, 6]),
    );

    test('a working Saturday needs leave', () {
      final list = suggest(2027, profile: saturdayWorker);
      final full = find(list, day(2027, 3, 9), day(2027, 3, 14));
      expect(full!.leaveDays, [day(2027, 3, 12), day(2027, 3, 13)]);
      expect(full.leaveDaysUsed, 2);
      final short = find(list, day(2027, 3, 9), day(2027, 3, 12));
      expect(short!.leaveDays, [day(2027, 3, 12)]);
    });

    test('a Saturday eve becomes a half working day', () {
      final list = suggest(2027, profile: saturdayWorker);
      final s = find(list, day(2027, 5, 15), day(2027, 5, 19));
      expect(s!.leaveDays, [day(2027, 5, 15)]);
      expect(s.leaveDaysUsed, 0.5);
    });

    test('the Saturday setting prices a Saturday inside the leave', () {
      final countsSaturday = find(
        suggest(2027),
        day(2027, 3, 6),
        day(2027, 3, 15),
      );
      final skipsSaturday = find(
        suggest(
          2027,
          profile: laborProfile(
            schedule: const WorkSchedule(saturdayCountsAsLeave: false),
          ),
        ),
        day(2027, 3, 6),
        day(2027, 3, 15),
      );
      expect(countsSaturday!.leaveDays, [
        day(2027, 3, 8),
        day(2027, 3, 12),
        day(2027, 3, 15),
      ]);
      expect(countsSaturday.leaveDaysUsed, 3.5);
      expect(skipsSaturday!.leaveDaysUsed, 2.5);
    });
  });

  group('4857 and 657', () {
    test('a weekend inside the leave counts for a civil servant', () {
      final worker = find(suggest(2026), day(2026, 5, 23), day(2026, 6, 1));
      final officer = find(
        suggest(2026, profile: civilServantProfile()),
        day(2026, 5, 23),
        day(2026, 6, 1),
      );
      expect(worker!.leaveDays, officer!.leaveDays);
      expect(worker.leaveDaysUsed, 2.5);
      expect(officer.leaveDaysUsed, 4.5);
      expect(
        compareBridgeSuggestions(worker, officer),
        lessThan(0),
        reason: 'the cheaper suggestion ranks higher',
      );
    });

    test('Ramazan 2027 over a weekend costs 4.5 for a civil servant', () {
      final s = find(
        suggest(2027, profile: civilServantProfile()),
        day(2027, 3, 6),
        day(2027, 3, 15),
      );
      expect(s!.leaveDaysUsed, 4.5);
    });

    test('a bridge without a weekend costs the same', () {
      final worker = find(suggest(2027), day(2027, 3, 9), day(2027, 3, 14));
      final officer = find(
        suggest(2027, profile: civilServantProfile()),
        day(2027, 3, 9),
        day(2027, 3, 14),
      );
      expect(worker!.leaveDaysUsed, officer!.leaveDaysUsed);
    });

    test('administrative leave is free for a civil servant only', () {
      final admin = [day(2027, 3, 12)];
      final officer = suggest(
        2027,
        profile: civilServantProfile(administrativeLeaveDays: admin),
      );
      expect(officer.first.vacation.start, day(2027, 3, 6));
      expect(officer.first.vacation.end, day(2027, 3, 14));
      expect(officer.first.leaveDays, [day(2027, 3, 8)]);
      expect(officer.first.leaveDaysUsed, 0.5);

      final worker = suggest(
        2027,
        profile: laborProfile().copyWith(administrativeLeaveDays: admin),
      );
      final s = find(worker, day(2027, 3, 6), day(2027, 3, 14));
      expect(s!.leaveDays, [day(2027, 3, 8), day(2027, 3, 12)]);
    });

    test('a civil servant teacher gets nothing (657 md. 103/2)', () {
      final teacher = civilServantProfile(isTeacher: true);
      expect(suggest(2027, profile: teacher), isEmpty);
      expect(plan(2027, 14, profile: teacher), isEmpty);
    });
  });

  group('budget', () {
    test('budget 0 gives nothing', () {
      expect(suggest(2027, budget: 0), isEmpty);
      expect(plan(2027, 0), isEmpty);
    });

    test('negative or NaN budget gives nothing', () {
      expect(suggest(2027, budget: -1), isEmpty);
      expect(plan(2027, -1), isEmpty);
      expect(plan(2027, double.nan), isEmpty);
    });

    test('budget limits every suggestion', () {
      final list = suggest(2027, budget: 1);
      expect(list, isNotEmpty);
      expect(list.every((s) => s.leaveDaysUsed <= 1), isTrue);
      expect(find(list, day(2027, 3, 9), day(2027, 3, 14)), isNotNull);
      expect(find(list, day(2027, 3, 6), day(2027, 3, 14)), isNull);
    });

    test('maxLeaveDays still applies under a large budget', () {
      final list = suggest(2027, budget: 20, maxLeaveDays: 2);
      expect(list.every((s) => s.leaveDaysUsed <= 2), isTrue);
    });

    test('a free eve morning fits in budget 0', () {
      final list = suggest(
        2027,
        budget: 0,
        profile: laborProfile(
          schedule: const WorkSchedule(halfDayDeduction: HalfDayDeduction.zero),
        ),
      );
      expect(list.map((s) => s.leaveDays), [
        [day(2027, 3, 8)],
        [day(2027, 10, 28)],
      ]);
      expect(list.every((s) => s.leaveDaysUsed == 0), isTrue);
    });

    test('a full eve deduction makes the eve cost a day', () {
      final s = find(
        suggest(
          2027,
          profile: laborProfile(
            schedule: const WorkSchedule(
              halfDayDeduction: HalfDayDeduction.full,
            ),
          ),
        ),
        day(2027, 3, 6),
        day(2027, 3, 11),
      );
      expect(s!.leaveDaysUsed, 1);
    });

    test('budget below the cheapest suggestion gives an empty plan', () {
      expect(plan(2027, 0.25), isEmpty);
    });

    test('half a day buys the Ramazan eve', () {
      final best = plan(2027, 0.5);
      expect(best.map((s) => s.vacation), [
        DateRange(start: day(2027, 3, 6), end: day(2027, 3, 11)),
      ]);
    });

    test('one day buys both eves', () {
      final best = plan(2027, 1);
      expect(best.map((s) => s.leaveDays), [
        [day(2027, 3, 8)],
        [day(2027, 10, 28)],
      ]);
      expect(daysOff(best), 10);
      expect(used(best), 1);
    });

    test('one and a half days give 12 days off', () {
      final best = plan(2027, 1.5);
      expect(daysOff(best), 12);
      expect(used(best), 1.5);
    });
  });

  group('optimal plan', () {
    /// Most days off, then fewest leave days, by trying every subset.
    (int, double) bruteForce(List<BridgeSuggestion> candidates, double budget) {
      final sorted = [...candidates]
        ..sort((a, b) => a.vacation.start.compareTo(b.vacation.start));
      var best = (0, 0.0);
      void search(int from, DateTime? lastEnd, int days, double cost) {
        if (days > best.$1 || (days == best.$1 && cost < best.$2)) {
          best = (days, cost);
        }
        for (var i = from; i < sorted.length; i++) {
          final s = sorted[i];
          if (lastEnd != null && !s.vacation.start.isAfter(lastEnd)) continue;
          if (cost + s.leaveDaysUsed > budget) continue;
          search(
            i + 1,
            s.vacation.end,
            days + s.totalDaysOff,
            cost + s.leaveDaysUsed,
          );
        }
      }

      search(0, null, 0, 0);
      return best;
    }

    void expectOptimal(
      int year,
      double budget,
      Profile profile, [
      List<Holiday>? holidayList,
    ]) {
      final best = plan(
        year,
        budget,
        profile: profile,
        holidayList: holidayList,
      );
      final candidates = suggest(
        year,
        profile: profile,
        holidayList: holidayList,
        budget: budget,
        maxLeaveDays: 366,
      );
      expect((daysOff(best), used(best)), bruteForce(candidates, budget));
    }

    test('matches brute force on a small year', () {
      final small = [
        Holiday(
          date: day(2027, 4, 22),
          name: 'A',
          type: HolidayType.national,
          halfDay: false,
        ),
        Holiday(
          date: day(2027, 6, 1),
          name: 'B',
          type: HolidayType.national,
          halfDay: false,
        ),
        Holiday(
          date: day(2027, 6, 3),
          name: 'C',
          type: HolidayType.national,
          halfDay: false,
        ),
      ];
      for (final budget in [0.0, 1, 2, 3, 4]) {
        expectOptimal(2027, budget.toDouble(), laborProfile(), small);
      }
    });

    test('matches brute force on 2027 for three profiles', () {
      final profiles = [
        laborProfile(),
        laborProfile(
          schedule: const WorkSchedule(workDays: [1, 2, 3, 4, 5, 6]),
        ),
        civilServantProfile(),
      ];
      for (final profile in profiles) {
        for (final budget in [0.5, 1, 1.5, 2]) {
          expectOptimal(2027, budget.toDouble(), profile);
        }
      }
    });

    test('a full balance gives disjoint breaks in date order', () {
      final best = plan(2027, 14);
      expect(used(best), lessThanOrEqualTo(14));
      expect(used(best), greaterThan(13));
      for (var i = 1; i < best.length; i++) {
        expect(best[i].vacation.start.isAfter(best[i - 1].vacation.end), true);
      }
      final longest = suggest(
        2027,
        budget: 14,
        maxLeaveDays: 14,
      ).map((s) => s.totalDaysOff).reduce((a, b) => a > b ? a : b);
      expect(daysOff(best), greaterThan(longest));
    });

    test('an infinite budget still finishes', () {
      final best = plan(2027, double.infinity);
      expect(best, isNotEmpty);
    });

    test('a whole year with a large balance stays fast', () {
      final watch = Stopwatch()..start();
      for (final profile in [laborProfile(), civilServantProfile()]) {
        planner
          ..suggestions(year: 2027, profile: profile, holidays: holidays)
          ..optimalPlan(
            year: 2027,
            profile: profile,
            holidays: holidays,
            budget: 30,
          );
      }
      expect(watch.elapsed, lessThan(const Duration(seconds: 10)));
    });
  });

  group('edge cases', () {
    test('a profile without working days gets nothing', () {
      final profile = laborProfile(schedule: const WorkSchedule(workDays: []));
      expect(suggest(2027, profile: profile), isEmpty);
      expect(plan(2027, 5, profile: profile), isEmpty);
    });

    test('no holidays means no bridges', () {
      expect(suggest(2027, holidayList: const []), isEmpty);
      expect(plan(2027, 10, holidayList: const []), isEmpty);
    });

    test('the default counter is wired', () {
      expect(const DefaultBridgePlanner(), isA<DefaultBridgePlanner>());
    });
  });
}
