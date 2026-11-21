import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/repositories/holiday_repository.dart';
import 'package:izin_planla/data/repositories/leave_repository.dart';
import 'package:izin_planla/data/repositories/profile_repository.dart';
import 'package:izin_planla/data/repositories/settings_repository.dart';
import 'package:izin_planla/data/services/notifications/local_notification_service.dart';
import 'package:izin_planla/data/services/notifications/notification_gateway.dart';
import 'package:izin_planla/data/services/notifications/stable_notification_id.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/utils/result.dart';
import 'package:timezone/timezone.dart' as tz;

import 'stub_calculators.dart';

typedef _Shown = ({tz.TZDateTime? fireAt, String title, String body});

class _FakeGateway implements NotificationGateway {
  final Map<int, _Shown> pending = {};
  final Map<int, _Shown> shown = {};
  final List<int> cancelled = [];
  int initializeCalls = 0;
  int scheduleCalls = 0;
  int cancelAllCalls = 0;
  String? channelName;
  bool granted = true;
  bool answer = true;
  Exception? initializeError;
  Exception? requestError;
  Exception? scheduleError;

  @override
  Future<void> initialize({
    required String channelName,
    required String channelDescription,
  }) async {
    initializeCalls++;
    if (initializeError case final error?) throw error;
    this.channelName = channelName;
  }

  @override
  Future<bool> requestPermission() async {
    if (requestError case final error?) throw error;
    return answer;
  }

  @override
  Future<bool> isPermissionGranted() async => granted;

  @override
  Future<Set<int>> pendingIds() async => {...pending.keys};

  @override
  Future<void> schedule({
    required int id,
    required tz.TZDateTime fireAt,
    required String title,
    required String body,
  }) async {
    scheduleCalls++;
    if (scheduleError case final error?) throw error;
    pending[id] = (fireAt: fireAt, title: title, body: body);
  }

  @override
  Future<void> show({
    required int id,
    required String title,
    required String body,
  }) async {
    shown[id] = (fireAt: null, title: title, body: body);
  }

  @override
  Future<void> cancel(int id) async {
    cancelled.add(id);
    pending.remove(id);
  }

  @override
  Future<void> cancelAll() async {
    cancelAllCalls++;
    pending.clear();
  }
}

class _Settings implements SettingsRepository {
  new(this.value);

  AppSettings value;
  int reads = 0;

  @override
  Stream<AppSettings> watch() {
    reads++;
    return Stream.value(value);
  }

  @override
  Future<Result<void>> save(AppSettings settings) async {
    value = settings;
    return const Result.ok(null);
  }
}

class _Profiles implements ProfileRepository {
  new(this.items);

  final List<Profile> items;

  @override
  Stream<List<Profile>> watchAll() => Stream.value(items);

  @override
  Future<Profile?> findById(String id) async =>
      items.where((p) => p.id == id).firstOrNull;

  @override
  Future<Result<void>> save(Profile profile) async => const Result.ok(null);

  @override
  Future<Result<void>> delete(String id) async => const Result.ok(null);
}

class _Leaves implements LeaveRepository {
  List<LeaveRecord> items = [];

  @override
  Stream<List<LeaveRecord>> watchForProfile(String profileId) =>
      Stream.value([...items.where((l) => l.profileId == profileId)]);

  @override
  Future<Result<void>> save(LeaveRecord record) async => const Result.ok(null);

  @override
  Future<Result<void>> delete(String id) async => const Result.ok(null);
}

class _Holidays implements HolidayRepository {
  new(this.items);

  final List<Holiday> items;

  @override
  Future<List<Holiday>> all() async => items;

  @override
  Future<List<Holiday>> inRange(DateRange range) async => [
    ...items.where((h) => range.contains(h.date)),
  ];
}

const _holidayAndLeave = NotificationPreferences(
  holidayReminder: true,
  plannedLeaveReminder: true,
);

final _week = LeaveRecord(
  id: 'l1',
  profileId: 'p1',
  type: LeaveType.annual,
  range: DateRange(
    start: DateTime.utc(2026, 12, 7),
    end: DateTime.utc(2026, 12, 11),
  ),
);

void main() {
  late _FakeGateway gateway;
  late _Settings settings;
  late _Leaves leaves;
  late LocalNotificationService service;

  setUp(() {
    gateway = _FakeGateway();
    settings = _Settings(
      const AppSettings(activeProfileId: 'p1', notifications: _holidayAndLeave),
    );
    leaves = _Leaves()..items = [_week];
    service = LocalNotificationService(
      gateway: gateway,
      profileRepository: _Profiles([
        Profile(
          id: 'p1',
          name: 'Ayşe',
          employmentType: EmploymentType.laborLaw,
          employmentStartDate: DateTime.utc(2020, 3, 15),
          birthDate: DateTime.utc(1990, 5, 5),
        ),
      ]),
      leaveRepository: leaves,
      settingsRepository: settings,
      holidayRepository: _Holidays([
        Holiday(
          date: DateTime.utc(2027),
          name: 'Yılbaşı',
          type: HolidayType.national,
          halfDay: false,
        ),
      ]),
      entitlementCalculator: StubCalculators(),
      balanceCalculator: StubCalculators(),
      bridgePlanner: StubCalculators(),
      // Saturday, 21 November 2026, 10.00 in Istanbul.
      clock: () => DateTime.utc(2026, 11, 21, 7),
    );
  });

  test('initialize starts the plugin once with the Turkish channel', () async {
    await service.initialize();
    await service.initialize();

    expect(gateway.initializeCalls, 1);
    expect(gateway.channelName, 'Hatırlatmalar');
  });

  test('reschedule schedules every planned reminder with its text', () async {
    await service.reschedule();

    final reminders = gateway.pending.values.toList()
      ..sort((a, b) => a.fireAt!.compareTo(b.fireAt!));
    expect(reminders.map((r) => r.title), [
      'İzin yaklaşıyor',
      'İzin bitiyor',
      'Resmî tatil yaklaşıyor',
    ]);
    expect(reminders.last.body, 'Yılbaşı için 7 gün kaldı.');
    expect(reminders.last.fireAt!.location.name, 'Europe/Istanbul');
    expect(reminders.last.fireAt!.toUtc(), DateTime.utc(2026, 12, 25, 6));
  });

  test('rescheduling the same data keeps the ids, no duplicates', () async {
    await service.reschedule();
    final ids = {...gateway.pending.keys};
    await service.reschedule();

    expect(gateway.pending.keys.toSet(), ids);
    expect(gateway.pending, hasLength(3));
    expect(gateway.cancelled, isEmpty);
  });

  test('reschedule cancels reminders that are no longer planned', () async {
    await service.reschedule();
    leaves.items = [];
    await service.reschedule();

    expect(gateway.cancelled, hasLength(2));
    expect(gateway.pending.values.single.title, 'Resmî tatil yaklaşıyor');
  });

  test('turning every reminder off cancels the pending ones', () async {
    await service.reschedule();
    settings.value = const AppSettings(activeProfileId: 'p1');
    await service.reschedule();

    expect(gateway.pending, isEmpty);
  });

  test('without the permission nothing is scheduled', () async {
    await service.reschedule();
    gateway.granted = false;
    await service.reschedule();

    expect(gateway.pending, isEmpty);
    expect(gateway.scheduleCalls, 3);
  });

  test('requestPermission returns the answer of the user', () async {
    expect(await service.requestPermission(), isTrue);
    gateway.answer = false;
    expect(await service.requestPermission(), isFalse);
  });

  test('requestPermission returns false on a platform error', () async {
    gateway.requestError = PlatformException(code: 'denied');

    expect(await service.requestPermission(), isFalse);
  });

  test('a failing schedule call does not throw', () async {
    gateway.scheduleError = PlatformException(code: 'broken');

    await expectLater(service.reschedule(), completes);
  });

  test('a failed start does not throw and is tried again', () async {
    gateway.initializeError = PlatformException(code: 'broken');

    await expectLater(service.initialize(), completes);
    await expectLater(service.reschedule(), completes);
    expect(await service.requestPermission(), isFalse);
    expect(gateway.pending, isEmpty);

    gateway.initializeError = null;
    await service.reschedule();

    expect(gateway.pending, hasLength(3));
  });

  test('a reschedule during a running one makes it run once more', () async {
    final first = service.reschedule();
    final second = service.reschedule();
    final third = service.reschedule();
    await Future.wait([first, second, third]);

    expect(settings.reads, 2);
    expect(gateway.pending, hasLength(3));

    await service.reschedule();
    expect(settings.reads, 3);
  });

  test('cancelAll removes every reminder', () async {
    await service.reschedule();
    await service.cancelAll();

    expect(gateway.cancelAllCalls, 1);
    expect(gateway.pending, isEmpty);
  });

  test('the test notification shows right away with its own id', () async {
    expect(await service.showTestNotification(), isTrue);

    expect(gateway.shown.keys, [testNotificationId]);
    expect(gateway.shown.values.single.title, 'Bildirimler açık');
  });
}
