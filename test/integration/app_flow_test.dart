import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;
import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/config/dependencies.dart';
import 'package:izin_planla/data/database/app_database.dart';
import 'package:izin_planla/data/fakes/fake_notification_service.dart';
import 'package:izin_planla/data/services/home_widget/default_home_widget_service.dart';
import 'package:izin_planla/data/services/home_widget/home_widget_content.dart';
import 'package:izin_planla/data/services/home_widget/home_widget_gateway.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/ui/bridge/view_models/bridge_state.dart';
import 'package:izin_planla/ui/bridge/view_models/bridge_view_model.dart';
import 'package:izin_planla/ui/home/view_models/home_state.dart';
import 'package:izin_planla/ui/home/view_models/home_view_model.dart';
import 'package:izin_planla/ui/leave_form/view_models/leave_form_save_result.dart';
import 'package:izin_planla/ui/leave_form/view_models/leave_form_state.dart';
import 'package:izin_planla/ui/leave_form/view_models/leave_form_view_model.dart';
import 'package:izin_planla/ui/onboarding/view_models/onboarding_view_model.dart';
import 'package:izin_planla/utils/result.dart';

/// Records what the home screen widget would show.
class _RecordingWidgetGateway implements HomeWidgetGateway {
  final List<String> saved = [];

  @override
  Future<void> save(String key, String value) async {
    expect(key, HomeWidgetContent.storageKey);
    saved.add(value);
  }

  @override
  Future<void> update() async {}

  @override
  Future<void> requestPin() async {}
}

/// The main scenarios of task 16 on the real database (in memory), the
/// bundled holidays and the real calculators. Only the plugins are
/// replaced: notifications by a fake, the widget by a recording gateway.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late _RecordingWidgetGateway widget;

  setUp(() {
    widget = _RecordingWidgetGateway();
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWith((ref) {
          final database = AppDatabase(NativeDatabase.memory());
          ref.onDispose(database.close);
          return database;
        }),
        notificationServiceProvider.overrideWithValue(
          FakeNotificationService(),
        ),
        homeWidgetClicksProvider.overrideWithValue(const Stream.empty()),
        homeWidgetServiceProvider.overrideWith((ref) {
          final service = DefaultHomeWidgetService(
            settingsRepository: ref.watch(settingsRepositoryProvider),
            profileRepository: ref.watch(profileRepositoryProvider),
            leaveRepository: ref.watch(leaveRepositoryProvider),
            holidayRepository: ref.watch(holidayRepositoryProvider),
            entitlementCalculator: ref.watch(entitlementCalculatorProvider),
            balanceCalculator: ref.watch(balanceCalculatorProvider),
            gateway: widget,
          )..start();
          ref.onDispose(service.dispose);
          return service;
        }),
      ],
    );
    addTearDown(container.dispose);
  });

  /// Waits until [provider] gives a state that [done] accepts.
  Future<T> settle<T>(
    ProviderListenable<T> provider,
    bool Function(T state) done,
  ) async {
    final subscription = container.listen<T>(provider, (_, _) {});
    addTearDown(subscription.close);
    for (var i = 0; i < 200; i++) {
      final state = subscription.read();
      if (done(state)) return state;
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    fail('$provider did not settle, last state: ${subscription.read()}');
  }

  Future<HomeReady> home() async =>
      await settle<HomeState>(homeViewModelProvider, (s) => s is HomeReady)
          as HomeReady;

  /// Runs the onboarding of a worker who started on 2 March 2020.
  Future<void> onboard() async {
    final onboarding = container.read(onboardingViewModelProvider.notifier);
    container.listen(onboardingViewModelProvider, (_, _) {});
    onboarding
      ..chooseEmploymentType(EmploymentType.laborLaw)
      ..next()
      ..chooseStartDate(DateTime.utc(2020, 3, 2))
      ..next()
      ..chooseBirthDate(DateTime.utc(1990, 6, 15))
      ..next()
      ..chooseSaturday(works: false);
    expect(await onboarding.finish('Ben'), isTrue);
  }

  /// A Monday to Wednesday at least two weeks ahead with no holiday or
  /// eve, so the leave costs exactly three days.
  Future<DateRange> futureWorkdays() async {
    final holidays = {
      for (final h in await container.read(holidayRepositoryProvider).all())
        h.date,
    };
    final now = DateTime.now();
    var day = DateTime.utc(now.year, now.month, now.day + 14);
    while (day.weekday != DateTime.monday) {
      day = day.add(const Duration(days: 1));
    }
    while ([
      0,
      1,
      2,
    ].any((i) => holidays.contains(day.add(Duration(days: i))))) {
      day = day.add(const Duration(days: 7));
    }
    return DateRange(start: day, end: day.add(const Duration(days: 2)));
  }

  test('onboarding shows the earned leave on the home page', () async {
    expect(
      await container.read(profileRepositoryProvider).watchAll().first,
      isEmpty,
    );
    await onboard();
    final state = await home();
    // Six full years of service by now: 14 days a year under 4857.
    expect(state.profileName, 'Ben');
    expect(state.balance!.earned, greaterThanOrEqualTo(6 * 14));
    expect(state.balance!.remaining, state.balance!.earned);
    expect(state.nextAccrual, isNotNull);
  });

  test('a new leave lowers the balance and updates the widget', () async {
    await onboard();
    // The app reads the widget service at start, it then follows the data.
    container.read(homeWidgetServiceProvider);
    final before = (await home()).balance!;
    final range = await futureWorkdays();
    final args = (leaveId: null, start: range.start, end: range.end);
    container.listen(leaveFormViewModelProvider(args), (_, _) {});
    await settle<LeaveFormState>(
      leaveFormViewModelProvider(args),
      (s) => s is LeaveFormReady,
    );
    final saved = await container
        .read(leaveFormViewModelProvider(args).notifier)
        .save();
    expect(saved, isA<LeaveFormSaved>());

    final after = await settle<HomeState>(
      homeViewModelProvider,
      (s) => s is HomeReady && s.balance!.planned > before.planned,
    ) as HomeReady;
    expect(after.balance!.planned - before.planned, 3);
    expect(after.balance!.remaining, before.remaining - 3);

    // The widget content written last carries the new remaining days.
    final remaining = after.balance!.remaining.toInt().toString();
    bool shown() =>
        widget.saved.isNotEmpty && widget.saved.last.contains(remaining);
    for (var i = 0; i < 200 && !shown(); i++) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    final content = jsonDecode(widget.saved.last) as Map<String, dynamic>;
    expect(jsonEncode(content['days']), contains(remaining));
  });

  test('planning a bridge adds one planned annual leave', () async {
    await onboard();
    final state = await settle<BridgeState>(
      bridgeViewModelProvider,
      (s) => s.content.value?.items.isNotEmpty ?? false,
    );
    final suggestion = state.content.value!.items.first.suggestion;
    final id = await container
        .read(bridgeViewModelProvider.notifier)
        .plan(suggestion);
    expect(id, isNotNull);
    final profile =
        (await container.read(profileRepositoryProvider).watchAll().first)
            .single;
    final leaves = await container
        .read(leaveRepositoryProvider)
        .watchForProfile(profile.id)
        .first;
    final record = leaves.singleWhere((r) => r.id == id);
    final days = [...suggestion.leaveDays]..sort();
    expect(record.type, LeaveType.annual);
    expect(record.range, DateRange(start: days.first, end: days.last));
  });

  test('backup, reset and restore give back the same data', () async {
    await onboard();
    final range = await futureWorkdays();
    final profile =
        (await container.read(profileRepositoryProvider).watchAll().first)
            .single;
    await container
        .read(leaveRepositoryProvider)
        .save(
          LeaveRecord(
            id: 'leave-1',
            profileId: profile.id,
            type: LeaveType.annual,
            range: range,
            note: 'Tatil',
          ),
        );
    final codec = container.read(backupCodecProvider);
    final backup = await codec.exportJson();
    final json = (backup as Ok<String>).value;

    expect(await codec.resetAll(), isA<Ok<void>>());
    expect(
      await container.read(profileRepositoryProvider).watchAll().first,
      isEmpty,
    );

    expect(await codec.restoreJson(json), isA<Ok<void>>());
    final again = await codec.exportJson();
    expect((again as Ok<String>).value, json);
  });
}
