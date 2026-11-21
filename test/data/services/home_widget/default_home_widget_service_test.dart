import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/fakes/fake_holiday_repository.dart';
import 'package:izin_planla/data/fakes/fake_leave_repository.dart';
import 'package:izin_planla/data/fakes/fake_profile_repository.dart';
import 'package:izin_planla/data/fakes/fake_settings_repository.dart';
import 'package:izin_planla/data/fakes/sample_data.dart';
import 'package:izin_planla/data/services/home_widget/default_home_widget_service.dart';
import 'package:izin_planla/data/services/home_widget/home_widget_content.dart';
import 'package:izin_planla/data/services/home_widget/home_widget_gateway.dart';
import 'package:izin_planla/domain/day_count/balance_calculator.dart';
import 'package:izin_planla/domain/entitlement/entitlement_calculator.dart';
import 'package:izin_planla/domain/models/models.dart';

/// Records what the service sends to the widget.
class _RecordingGateway implements HomeWidgetGateway {
  final List<String> saved = [];
  final List<String> calls = [];

  /// The last saved content, decoded.
  Map<String, dynamic> get last =>
      jsonDecode(saved.last) as Map<String, dynamic>;

  /// Today's entry of the last saved content.
  Map<String, dynamic> get today =>
      (last['days'] as Map<String, dynamic>)['2026-11-21']
          as Map<String, dynamic>;

  @override
  Future<void> save(String key, String value) async {
    expect(key, HomeWidgetContent.storageKey);
    saved.add(value);
    calls.add('save');
  }

  @override
  Future<void> update() async => calls.add('update');

  @override
  Future<void> requestPin() async => calls.add('pin');
}

/// 20 days minus one per annual leave record, so changes are visible.
class _CountingBalanceCalculator implements BalanceCalculator {
  @override
  LeaveBalance balance({
    required Profile profile,
    required List<EntitlementPeriod> periods,
    required List<LeaveRecord> leaves,
    required List<Holiday> holidays,
    required DateTime today,
  }) {
    final used = leaves.where((l) => l.type == LeaveType.annual).length;
    return LeaveBalance(
      earned: 20,
      used: used.toDouble(),
      planned: 0,
      remaining: 20.0 - used,
    );
  }
}

class _NoEntitlementCalculator implements EntitlementCalculator {
  @override
  List<EntitlementPeriod> periods(Profile profile, {required DateTime until}) =>
      const [];

  @override
  NextAccrual? nextAccrual(Profile profile, DateTime today) => null;
}

LeaveRecord _leave(String id, {String profileId = SampleData.profileId}) =>
    LeaveRecord(
      id: id,
      profileId: profileId,
      type: LeaveType.annual,
      range: DateRange(
        start: DateTime.utc(2026, 12, 7),
        end: DateTime.utc(2026, 12, 7),
      ),
    );

void main() {
  late FakeSettingsRepository settings;
  late FakeProfileRepository profiles;
  late FakeLeaveRepository leaves;
  late _RecordingGateway gateway;
  late DefaultHomeWidgetService service;

  setUp(() {
    settings = FakeSettingsRepository();
    profiles = FakeProfileRepository();
    leaves = FakeLeaveRepository();
    gateway = _RecordingGateway();
    service = DefaultHomeWidgetService(
      settingsRepository: settings,
      profileRepository: profiles,
      leaveRepository: leaves,
      holidayRepository: FakeHolidayRepository(),
      entitlementCalculator: _NoEntitlementCalculator(),
      balanceCalculator: _CountingBalanceCalculator(),
      gateway: gateway,
      now: () => DateTime(2026, 11, 21, 9, 30),
    );
  });

  tearDown(() => service.dispose());

  group('refresh', () {
    test('saves the content, then redraws the widget', () async {
      await service.refresh();

      expect(gateway.calls, ['save', 'update']);
      expect(gateway.last['theme'], 'system');
      // SampleData has two annual leaves.
      expect(gateway.today['value'], '18');
      expect(gateway.today['caption'], 'gün izin hakkın kaldı');
      expect(gateway.today['holiday'], '41 gün sonra resmî tatil: Yılbaşı');
    });

    test('passes the light and dark theme from the settings', () async {
      for (final mode in [AppThemeMode.light, AppThemeMode.dark]) {
        await settings.save(
          const AppSettings(activeProfileId: SampleData.profileId)
              .copyWith(themeMode: mode),
        );
        await service.refresh();

        expect(gateway.last['theme'], mode.name);
      }
    });

    test('shows the setup prompt before a profile is active', () async {
      await settings.save(const AppSettings());

      await service.refresh();

      expect(gateway.today['value'], '');
      expect(
        gateway.today['caption'],
        'İzin hakkını görmek için uygulamayı aç',
      );
    });

    test('shows an overdrawn balance', () async {
      for (var i = 0; i < 21; i++) {
        await leaves.save(_leave('extra-$i'));
      }

      await service.refresh();

      expect(gateway.today['value'], '3');
      expect(gateway.today['caption'], 'gün fazla izin aldın');
    });
  });

  group('start', () {
    test('refreshes at once', () async {
      service.start();
      await pumpEventQueue();

      expect(gateway.saved, isNotEmpty);
      expect(gateway.today['value'], '18');
    });

    test('refreshes after a leave is added and after it is deleted', () async {
      service.start();
      await pumpEventQueue();

      await leaves.save(_leave('new'));
      await pumpEventQueue();
      expect(gateway.today['value'], '17');

      await leaves.delete('new');
      await pumpEventQueue();
      expect(gateway.today['value'], '18');
    });

    test('refreshes after the theme changes', () async {
      service.start();
      await pumpEventQueue();

      await settings.save(
        const AppSettings(
          activeProfileId: SampleData.profileId,
          themeMode: AppThemeMode.dark,
        ),
      );
      await pumpEventQueue();

      expect(gateway.last['theme'], 'dark');
    });

    test('follows the newly active profile', () async {
      final other = SampleData.profile.copyWith(id: 'other');
      await profiles.save(other);
      service.start();
      await pumpEventQueue();

      await settings.save(const AppSettings(activeProfileId: 'other'));
      await pumpEventQueue();
      expect(gateway.today['value'], '20');

      await leaves.save(_leave('for-other', profileId: 'other'));
      await pumpEventQueue();
      expect(gateway.today['value'], '19');
    });

    test('refreshes after the active profile is edited', () async {
      service.start();
      await pumpEventQueue();

      await profiles.save(SampleData.profile.copyWith(isTeacher: true));
      await pumpEventQueue();

      expect(gateway.today['caption'], 'Öğretmenlere yıllık izin verilmez');
    });

    test(
      'coalesces a burst of changes and ends with the newest data',
      () async {
        service.start();
        await pumpEventQueue();
        final before = gateway.saved.length;

        for (var i = 0; i < 5; i++) {
          await leaves.save(_leave('burst-$i'));
        }
        await pumpEventQueue();

        expect(gateway.saved.length - before, lessThan(5));
        expect(gateway.today['value'], '13');
      },
    );

    test('calling start twice does not double the refreshes', () async {
      service
        ..start()
        ..start();
      await pumpEventQueue();
      final before = gateway.saved.length;

      await leaves.save(_leave('once'));
      await pumpEventQueue();

      expect(gateway.saved.length - before, 1);
    });

    test('stops after dispose', () async {
      service.start();
      await pumpEventQueue();
      await service.dispose();
      final before = gateway.saved.length;

      await leaves.save(_leave('late'));
      await settings.save(const AppSettings(themeMode: AppThemeMode.dark));
      await pumpEventQueue();

      expect(gateway.saved, hasLength(before));
    });
  });

  test('requestPin writes the current values before pinning', () async {
    await service.requestPin();

    expect(gateway.calls, ['save', 'update', 'pin']);
  });
}
