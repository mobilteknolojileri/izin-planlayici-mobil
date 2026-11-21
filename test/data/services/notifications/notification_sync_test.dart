import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/fakes/fake_leave_repository.dart';
import 'package:izin_planla/data/fakes/fake_profile_repository.dart';
import 'package:izin_planla/data/fakes/fake_settings_repository.dart';
import 'package:izin_planla/data/fakes/sample_data.dart';
import 'package:izin_planla/data/services/notifications/notification_service.dart';
import 'package:izin_planla/data/services/notifications/notification_sync.dart';
import 'package:izin_planla/domain/models/models.dart';

class _CountingService implements NotificationService {
  int reschedules = 0;

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<void> reschedule() async => reschedules++;

  @override
  Future<void> cancelAll() async {}
}

void main() {
  late _CountingService service;
  late FakeSettingsRepository settings;
  late FakeProfileRepository profiles;
  late FakeLeaveRepository leaves;
  late NotificationSync sync;

  setUp(() {
    service = _CountingService();
    settings = FakeSettingsRepository();
    profiles = FakeProfileRepository();
    leaves = FakeLeaveRepository();
    sync = NotificationSync(
      service: service,
      settings: settings,
      profiles: profiles,
      leaves: leaves,
    )..start();
  });

  tearDown(() => sync.dispose());

  // Lets the in-memory streams deliver their events.
  Future<void> settle() => Future<void>.delayed(Duration.zero);

  LeaveRecord leave(String id, String profileId) => LeaveRecord(
    id: id,
    profileId: profileId,
    type: LeaveType.annual,
    range: DateRange(
      start: DateTime.utc(2026, 12, 7),
      end: DateTime.utc(2026, 12, 8),
    ),
  );

  test('schedules once the data is first read', () async {
    await settle();
    expect(service.reschedules, greaterThan(0));
  });

  test('a new leave reschedules', () async {
    await settle();
    final before = service.reschedules;
    await leaves.save(leave('new', SampleData.profileId));
    await settle();
    expect(service.reschedules, greaterThan(before));
  });

  test('a settings change reschedules', () async {
    await settle();
    final before = service.reschedules;
    await settings.save(const AppSettings(themeMode: AppThemeMode.dark));
    await settle();
    expect(service.reschedules, greaterThan(before));
  });

  test('leaves of a deleted profile no longer reschedule', () async {
    await settle();
    await profiles.delete(SampleData.profileId);
    await settle();
    final before = service.reschedules;
    await leaves.save(leave('orphan', SampleData.profileId));
    await settle();
    expect(service.reschedules, before);
  });

  test('refresh reschedules without a data change', () async {
    await settle();
    final before = service.reschedules;
    sync.refresh();
    expect(service.reschedules, before + 1);
  });
}
