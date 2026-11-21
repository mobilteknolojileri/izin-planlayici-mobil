import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/services/notifications/reminder.dart';
import 'package:izin_planla/data/services/notifications/reminder_planner.dart';
import 'package:izin_planla/data/services/notifications/scheduled_reminder.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:timezone/data/latest_10y.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'stub_calculators.dart';

late tz.Location istanbul;

tz.TZDateTime at(
  int year,
  int month,
  int day, [
  int hour = 0,
  int minute = 0,
]) => tz.TZDateTime(istanbul, year, month, day, hour, minute);

final newYear = Holiday(
  date: DateTime.utc(2027),
  name: 'Yılbaşı',
  type: HolidayType.national,
  halfDay: false,
);

final List<Holiday> ramadan = [
  Holiday(
    date: DateTime.utc(2027, 3, 8),
    name: 'Ramazan Bayramı Arifesi',
    type: HolidayType.eve,
    halfDay: true,
  ),
  for (final (day, name) in [(9, '1. Gün'), (10, '2. Gün'), (11, '3. Gün')])
    Holiday(
      date: DateTime.utc(2027, 3, day),
      name: 'Ramazan Bayramı $name',
      type: HolidayType.religious,
      halfDay: false,
    ),
];

// Leave on the eve morning and on Friday: Saturday 6 to Sunday 14 March.
final ramadanBridge = BridgeSuggestion(
  leaveDays: [DateTime.utc(2027, 3, 8), DateTime.utc(2027, 3, 12)],
  vacation: DateRange(
    start: DateTime.utc(2027, 3, 6),
    end: DateTime.utc(2027, 3, 14),
  ),
  totalDaysOff: 9,
  leaveDaysUsed: 1.5,
);

Profile person({
  String id = 'p1',
  String name = 'Ayşe',
  EmploymentType type = EmploymentType.laborLaw,
  bool isTeacher = false,
  List<int> workDays = const [1, 2, 3, 4, 5],
}) => Profile(
  id: id,
  name: name,
  employmentType: type,
  employmentStartDate: DateTime.utc(2020, 3, 15),
  birthDate: DateTime.utc(1990, 5, 5),
  isTeacher: isTeacher,
  workSchedule: WorkSchedule(workDays: workDays),
);

LeaveRecord leave(
  String id,
  DateTime start,
  DateTime end, {
  String profileId = 'p1',
  LeaveUnit unit = LeaveUnit.days,
}) => LeaveRecord(
  id: id,
  profileId: profileId,
  type: LeaveType.annual,
  range: DateRange(start: start, end: end),
  unit: unit,
);

LeaveBalance balanceWith({double remaining = 0, double expiring = 0}) =>
    LeaveBalance(
      earned: remaining,
      used: 0,
      planned: 0,
      remaining: remaining,
      expiringAtYearEnd: expiring,
    );

void main() {
  setUpAll(() {
    tz_data.initializeTimeZones();
    istanbul = tz.getLocation('Europe/Istanbul');
  });

  late StubCalculators calculators;

  setUp(() => calculators = StubCalculators());

  ReminderPlanner planner({int maxReminders = 50}) => ReminderPlanner(
    location: istanbul,
    entitlementCalculator: calculators,
    balanceCalculator: calculators,
    bridgePlanner: calculators,
    maxReminders: maxReminders,
  );

  List<ScheduledReminder> plan({
    required NotificationPreferences preferences,
    DateTime? now,
    List<Profile>? profiles,
    List<LeaveRecord> leaves = const [],
    List<Holiday> holidays = const [],
    String? activeProfileId = 'p1',
    int maxReminders = 50,
  }) {
    final people = profiles ?? [person()];
    return planner(maxReminders: maxReminders).plan(
      // Saturday, 21 November 2026, 10.00 in Istanbul.
      now: now ?? at(2026, 11, 21, 10),
      settings: AppSettings(
        activeProfileId: activeProfileId,
        notifications: preferences,
      ),
      profiles: people,
      leavesByProfile: {
        for (final p in people)
          p.id: [...leaves.where((l) => l.profileId == p.id)],
      },
      holidays: holidays,
    );
  }

  group('holiday reminders', () {
    const preferences = NotificationPreferences(holidayReminder: true);

    test('fire the chosen days before at 09.00 Istanbul time', () {
      final result = plan(preferences: preferences, holidays: [newYear]);

      expect(result, hasLength(1));
      expect(result.single.fireAt, at(2026, 12, 25, 9));
      expect(result.single.fireAt.toUtc(), DateTime.utc(2026, 12, 25, 6));
      expect(
        result.single.reminder,
        const HolidayReminder(holidayName: 'Yılbaşı', daysUntil: 7),
      );
    });

    test('talk about the first full day after an eve, once per block', () {
      final result = plan(
        preferences: preferences.copyWith(holidayDaysBefore: 3),
        holidays: ramadan,
      );

      expect(result, hasLength(1));
      expect(result.single.fireAt, at(2027, 3, 6, 9));
      expect(
        result.single.reminder,
        const HolidayReminder(
          holidayName: 'Ramazan Bayramı 1. Gün',
          daysUntil: 3,
        ),
      );
    });

    test('fire on the holiday morning with a lead time of 0', () {
      final result = plan(
        preferences: preferences.copyWith(holidayDaysBefore: 0),
        holidays: [newYear],
      );

      expect(result.single.fireAt, at(2027, 1, 1, 9));
      expect(
        result.single.reminder,
        const HolidayReminder(holidayName: 'Yılbaşı', daysUntil: 0),
      );
    });

    test('are skipped when the reminder time has passed', () {
      final result = plan(
        preferences: preferences,
        holidays: [newYear],
        now: at(2026, 12, 28, 10),
      );

      expect(result, isEmpty);
    });

    test('use the Istanbul clock when now is given in UTC', () {
      // 05.30 UTC is 08.30 in Istanbul, before the 09.00 reminder.
      final before = plan(
        preferences: preferences,
        holidays: [newYear],
        now: tz.TZDateTime.utc(2026, 12, 25, 5, 30),
      );
      // 06.30 UTC is 09.30 in Istanbul, after it.
      final after = plan(
        preferences: preferences,
        holidays: [newYear],
        now: tz.TZDateTime.utc(2026, 12, 25, 6, 30),
      );

      expect(before, hasLength(1));
      expect(after, isEmpty);
    });
  });

  group('bridge reminders', () {
    const preferences = NotificationPreferences(holidayReminder: true);

    setUp(() {
      calculators
        ..balanceOf = ((_, _) => balanceWith(remaining: 10))
        ..bridges[2027] = [ramadanBridge];
    });

    test('replace the holiday reminder and fire before the break', () {
      final result = plan(
        preferences: preferences,
        holidays: [newYear, ...ramadan],
      );

      expect(result, hasLength(2));
      expect(result.first.reminder, isA<HolidayReminder>());
      expect(result.last.fireAt, at(2027, 2, 27, 9));
      expect(
        result.last.reminder,
        const BridgeReminder(
          holidayName: 'Ramazan Bayramı 1. Gün',
          daysUntil: 10,
          leaveDays: 1.5,
          totalDaysOff: 9,
        ),
      );
      expect(calculators.bridgeBudgets, [10, 10]);
    });

    test('are skipped when a suggested day is already on leave', () {
      final result = plan(
        preferences: preferences,
        holidays: ramadan,
        leaves: [
          leave('l1', DateTime.utc(2027, 3, 12), DateTime.utc(2027, 3, 12)),
        ],
      );

      expect(result.single.fireAt, at(2027, 3, 2, 9));
      expect(result.single.reminder, isA<HolidayReminder>());
    });

    test('are skipped without remaining leave', () {
      calculators.balanceOf = (_, _) => balanceWith();

      final result = plan(preferences: preferences, holidays: ramadan);

      expect(result.single.reminder, isA<HolidayReminder>());
      expect(calculators.bridgeBudgets, isEmpty);
    });

    test('fall back to the holiday reminder when already late', () {
      final result = plan(
        preferences: preferences,
        holidays: ramadan,
        now: at(2027, 2, 28, 10),
      );

      expect(result.single.fireAt, at(2027, 3, 2, 9));
      expect(result.single.reminder, isA<HolidayReminder>());
    });

    test('use the active profile', () {
      calculators.balanceOf = (profile, _) =>
          balanceWith(remaining: profile.id == 'p2' ? 10 : 0);

      final result = plan(
        preferences: preferences,
        holidays: ramadan,
        profiles: [
          person(),
          person(id: 'p2', name: 'Mehmet'),
        ],
        activeProfileId: 'p2',
      );

      expect(result.single.reminder, isA<BridgeReminder>());
    });
  });

  group('accrual reminders', () {
    const preferences = NotificationPreferences(accrualReminder: true);

    test('fire on the accrual day at 09.00', () {
      calculators.accruals['p1'] = [
        NextAccrual(date: DateTime.utc(2027, 3, 15), days: 14),
      ];

      final result = plan(preferences: preferences);

      expect(result.single.fireAt, at(2027, 3, 15, 9));
      expect(
        result.single.reminder,
        const AccrualReminder(profileName: 'Ayşe', days: 14),
      );
    });

    test('keep an accrual later today and plan the next one', () {
      calculators.accruals['p1'] = [
        NextAccrual(date: DateTime.utc(2027, 3, 15), days: 14),
        NextAccrual(date: DateTime.utc(2028, 3, 15), days: 14),
      ];

      final early = plan(preferences: preferences, now: at(2027, 3, 15, 8));
      final late = plan(preferences: preferences, now: at(2027, 3, 15, 10));

      expect(early.map((r) => r.fireAt), [
        at(2027, 3, 15, 9),
        at(2028, 3, 15, 9),
      ]);
      expect(late.map((r) => r.fireAt), [at(2028, 3, 15, 9)]);
    });

    test('are skipped when nothing is earned', () {
      calculators.accruals['p1'] = [
        NextAccrual(date: DateTime.utc(2027, 3, 15), days: 0),
      ];

      expect(plan(preferences: preferences), isEmpty);
    });

    test('are planned for every profile', () {
      calculators
        ..accruals['p1'] = [
          NextAccrual(date: DateTime.utc(2027, 3, 15), days: 14),
        ]
        ..accruals['p2'] = [NextAccrual(date: DateTime.utc(2027), days: 20)];

      final result = plan(
        preferences: preferences,
        profiles: [
          person(),
          person(id: 'p2', name: 'Mehmet'),
        ],
      );

      expect(result.map((r) => r.reminder), [
        const AccrualReminder(profileName: 'Mehmet', days: 20),
        const AccrualReminder(profileName: 'Ayşe', days: 14),
      ]);
    });
  });

  group('leave reminders', () {
    const preferences = NotificationPreferences(plannedLeaveReminder: true);

    // Monday 7 to Friday 11 December 2026.
    final week = leave(
      'l1',
      DateTime.utc(2026, 12, 7),
      DateTime.utc(2026, 12, 11),
    );

    test('fire before the start and on the evening before return', () {
      final result = plan(preferences: preferences, leaves: [week]);

      expect(result.map((r) => (r.fireAt, r.reminder)), [
        (
          at(2026, 12, 6, 9),
          const LeaveStartReminder(profileName: 'Ayşe', daysUntil: 1),
        ),
        (at(2026, 12, 13, 18), const LeaveReturnReminder(profileName: 'Ayşe')),
      ]);
    });

    test('use the chosen lead time', () {
      final result = plan(
        preferences: preferences.copyWith(plannedLeaveDaysBefore: 3),
        leaves: [week],
      );

      expect(result.first.fireAt, at(2026, 12, 4, 9));
      expect(
        result.first.reminder,
        const LeaveStartReminder(profileName: 'Ayşe', daysUntil: 3),
      );
    });

    test('skip the weekend and holidays to find the return day', () {
      // Monday 28 to Thursday 31 December, Friday 1 January is a holiday.
      final result = plan(
        preferences: preferences,
        holidays: [newYear],
        leaves: [
          leave('l1', DateTime.utc(2026, 12, 28), DateTime.utc(2026, 12, 31)),
        ],
      );

      expect(result.last.fireAt, at(2027, 1, 3, 18));
      expect(result.last.reminder, isA<LeaveReturnReminder>());
    });

    test('follow the work days of the profile', () {
      final result = plan(
        preferences: preferences,
        profiles: [
          person(workDays: const [1, 2, 3, 4, 5, 6]),
        ],
        leaves: [week],
      );

      // Saturday is a working day, so the return reminder is on Friday.
      expect(result.last.fireAt, at(2026, 12, 11, 18));
    });

    test('back-to-back leaves get one start and one return reminder', () {
      final result = plan(
        preferences: preferences,
        leaves: [
          week,
          leave('l2', DateTime.utc(2026, 12, 14), DateTime.utc(2026, 12, 18)),
        ],
      );

      expect(result.map((r) => r.fireAt), [
        at(2026, 12, 6, 9),
        at(2026, 12, 20, 18),
      ]);
    });

    test('a half day gets no return reminder', () {
      final result = plan(
        preferences: preferences,
        leaves: [
          leave(
            'l1',
            DateTime.utc(2026, 12, 9),
            DateTime.utc(2026, 12, 9),
            unit: LeaveUnit.halfDay,
          ),
        ],
      );

      expect(result.single.reminder, isA<LeaveStartReminder>());
    });

    test('a running leave gets only the return reminder', () {
      final result = plan(
        preferences: preferences,
        leaves: [week],
        now: at(2026, 12, 8, 10),
      );

      expect(result.single.reminder, isA<LeaveReturnReminder>());
    });
  });

  group('year-end reminders', () {
    const preferences = NotificationPreferences(yearEndReminder: true);

    test('warn a civil servant on 1 December about days dropped', () {
      calculators.balanceOf = (_, _) =>
          balanceWith(remaining: 20, expiring: 4.5);

      final result = plan(
        preferences: preferences,
        profiles: [person(type: EmploymentType.civilServant)],
      );

      expect(result.single.fireAt, at(2026, 12, 1, 9));
      expect(
        result.single.reminder,
        const YearEndExpiringReminder(profileName: 'Ayşe', days: 4.5),
      );
      expect(calculators.balanceDays, [DateTime.utc(2026, 12, 31)]);
    });

    test('tell a worker about unused days without a warning', () {
      calculators.balanceOf = (_, _) => balanceWith(remaining: 6);

      final result = plan(preferences: preferences);

      expect(result.single.fireAt, at(2026, 12, 1, 9));
      expect(
        result.single.reminder,
        const YearEndUnusedReminder(profileName: 'Ayşe', days: 6),
      );
    });

    test('a civil servant with nothing expiring gets none', () {
      calculators.balanceOf = (_, _) => balanceWith(remaining: 20);

      final result = plan(
        preferences: preferences,
        profiles: [person(type: EmploymentType.civilServant)],
      );

      expect(result, isEmpty);
    });

    test('a worker with no days left gets none', () {
      expect(plan(preferences: preferences), isEmpty);
    });

    test('after 1 December plan next year with its balance', () {
      calculators.balanceOf = (_, _) => balanceWith(remaining: 6);

      final result = plan(preferences: preferences, now: at(2026, 12, 15));

      expect(result.single.fireAt, at(2027, 12, 1, 9));
      expect(calculators.balanceDays, [DateTime.utc(2027, 12, 31)]);
    });

    test('teachers get none', () {
      calculators.balanceOf = (_, _) => balanceWith(expiring: 5);

      final result = plan(
        preferences: preferences,
        profiles: [person(type: EmploymentType.civilServant, isTeacher: true)],
      );

      expect(result, isEmpty);
    });
  });

  group('plan', () {
    const allOn = NotificationPreferences(
      holidayReminder: true,
      accrualReminder: true,
      plannedLeaveReminder: true,
      yearEndReminder: true,
    );
    final leaves = [
      leave('l1', DateTime.utc(2026, 12, 7), DateTime.utc(2026, 12, 11)),
    ];

    setUp(() {
      calculators
        ..balanceOf = ((_, _) => balanceWith(remaining: 6))
        ..accruals['p1'] = [
          NextAccrual(date: DateTime.utc(2027, 3, 15), days: 14),
        ];
    });

    test('is empty when every reminder is off', () {
      final result = plan(
        preferences: const NotificationPreferences(),
        holidays: [newYear, ...ramadan],
        leaves: leaves,
      );

      expect(result, isEmpty);
    });

    test('gives the same ids for the same data, all unique', () {
      List<ScheduledReminder> run() => plan(
        preferences: allOn,
        holidays: [newYear, ...ramadan],
        leaves: leaves,
      );

      final first = run();
      final second = run();

      expect(first, hasLength(6));
      expect(second, first);
      expect(first.map((r) => r.id).toSet(), hasLength(first.length));
      expect(first.every((r) => r.id > 0), isTrue);
    });

    test('keeps the id of a moved leave and changes its time', () {
      final before = plan(preferences: allOn, leaves: leaves);
      final after = plan(
        preferences: allOn,
        leaves: [
          leave('l1', DateTime.utc(2026, 12, 14), DateTime.utc(2026, 12, 18)),
        ],
      );

      ScheduledReminder start(List<ScheduledReminder> all) =>
          all.singleWhere((r) => r.reminder is LeaveStartReminder);

      expect(start(after).id, start(before).id);
      expect(start(before).fireAt, at(2026, 12, 6, 9));
      expect(start(after).fireAt, at(2026, 12, 13, 9));
    });

    test('keeps the nearest reminders up to the limit, ordered', () {
      final all = plan(
        preferences: allOn,
        holidays: [newYear, ...ramadan],
        leaves: leaves,
      );
      final limited = plan(
        preferences: allOn,
        holidays: [newYear, ...ramadan],
        leaves: leaves,
        maxReminders: 3,
      );

      final times = all.map((r) => r.fireAt).toList();
      expect(times, [...times]..sort());
      expect(limited, all.take(3).toList());
    });
  });
}
