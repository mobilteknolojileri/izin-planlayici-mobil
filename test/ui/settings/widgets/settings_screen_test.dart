import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:izin_planla/config/dependencies.dart';
import 'package:izin_planla/data/fakes/fake_export_service.dart';
import 'package:izin_planla/data/fakes/fake_profile_repository.dart';
import 'package:izin_planla/data/fakes/fake_settings_repository.dart';
import 'package:izin_planla/data/fakes/sample_data.dart';
import 'package:izin_planla/data/repositories/backup_codec.dart';
import 'package:izin_planla/data/repositories/backup_exception.dart';
import 'package:izin_planla/data/services/export/export_failure.dart';
import 'package:izin_planla/data/services/export/export_failure_reason.dart';
import 'package:izin_planla/data/services/notifications/notification_service.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/core/theme/app_theme.dart';
import 'package:izin_planla/ui/settings/widgets/settings_screen.dart';
import 'package:izin_planla/utils/result.dart';
import 'package:material_ui/material_ui.dart';

import '../../../config/fake_dependencies.dart';
import '../../core/golden_harness.dart' show AndroidNonlinear200;

class _Notifications implements NotificationService {
  new({required this.granted});

  final bool granted;
  int rescheduled = 0;

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> requestPermission() async => granted;

  @override
  Future<void> reschedule() async => rescheduled++;

  @override
  Future<void> cancelAll() async {}
}

class _Codec implements BackupCodec {
  new({this.restoreResult = const Result.ok(null)});

  final Result<void> restoreResult;
  final restored = <String>[];
  int resets = 0;

  @override
  Future<Result<String>> exportJson() async => const Result.ok('snapshot');

  @override
  Future<Result<void>> restoreJson(String json) async {
    restored.add(json);
    return restoreResult;
  }

  @override
  Future<Result<void>> resetAll() async {
    resets++;
    return const Result.ok(null);
  }
}

class _Export extends FakeExportService {
  new({this.pick = const Result.ok('{}')});

  /// What picking a backup file gives.
  final Result<String?> pick;

  @override
  Future<Result<String?>> pickBackupFile() async => pick;
}

void main() {
  Future<({FakeSettingsRepository settings, FakeProfileRepository profiles})>
  pumpScreen(
    WidgetTester tester, {
    bool noProfile = false,
    bool granted = true,
    _Codec? codec,
    Result<String?> pick = const Result.ok('{}'),
    bool dark = false,
    TextScaler textScaler = TextScaler.noScaling,
    double width = 360,
    double height = 4800,
  }) async {
    tester.view
      ..physicalSize = Size(width, height)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final profiles = FakeProfileRepository();
    final settings = FakeSettingsRepository();
    if (noProfile) {
      await profiles.delete(SampleData.profileId);
      await settings.save(const AppSettings());
    }
    Widget stub(String name) => Scaffold(body: Center(child: Text(name)));
    final router = GoRouter(
      initialLocation: '/settings',
      routes: [
        GoRoute(path: '/', builder: (_, _) => stub('home')),
        GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
        for (final name in ['onboarding', 'people', 'stats', 'guide', 'about'])
          GoRoute(path: '/$name', builder: (_, _) => stub(name)),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: withFakeDependencies([
          profileRepositoryProvider.overrideWithValue(profiles),
          settingsRepositoryProvider.overrideWithValue(settings),
          notificationServiceProvider.overrideWithValue(
            _Notifications(granted: granted),
          ),
          backupCodecProvider.overrideWithValue(codec ?? _Codec()),
          exportServiceProvider.overrideWithValue(_Export(pick: pick)),
        ]),
        child: MaterialApp.router(
          theme: dark ? AppTheme.dark : AppTheme.light,
          locale: const Locale('tr'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: textScaler),
            child: child!,
          ),
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
    return (settings: settings, profiles: profiles);
  }

  Future<AppSettings> current(FakeSettingsRepository settings) =>
      settings.watch().first;

  testWidgets('filled: every section is shown', (tester) async {
    await pumpScreen(tester);
    expect(find.text('Örnek Kişi seçili. Toplam 1 kişi.'), findsOneWidget);
    expect(find.text('Çalışma düzeni'), findsOneWidget);
    expect(find.text('Pazartesi'), findsOneWidget);
    expect(find.text('Çalışmadığın cumartesi izinden düşsün'), findsOne);
    expect(find.text('Yarım gün düşsün'), findsOneWidget);
    expect(find.text('8 saat'), findsOneWidget);
    expect(find.text('Telefonun ayarı'), findsOneWidget);
    expect(find.text('Resmî tatil ve köprü'), findsOneWidget);
    expect(find.text('Yedekle'), findsOneWidget);
    expect(find.text('Dışa aktar'), findsOneWidget);
    expect(find.text('Bütün verileri sil'), findsOneWidget);
    expect(find.text('Mevzuat rehberi'), findsOneWidget);
  });

  testWidgets('theme choice is saved', (tester) async {
    final repos = await pumpScreen(tester);
    await tester.tap(find.text('Koyu'));
    await tester.pumpAndSettle();
    expect((await current(repos.settings)).themeMode, AppThemeMode.dark);
  });

  testWidgets('work days, hours and the Saturday setting are saved', (
    tester,
  ) async {
    final repos = await pumpScreen(tester);
    await tester.tap(find.text('Cumartesi'));
    await tester.pumpAndSettle();
    // Saturday is a work day now, the Saturday setting no longer applies.
    expect(find.text('Çalışmadığın cumartesi izinden düşsün'), findsNothing);
    await tester.tap(find.byTooltip('Yarım saat artır'));
    await tester.pumpAndSettle();
    expect(find.text('8,5 saat'), findsOneWidget);
    final profile = await repos.profiles.findById(SampleData.profileId);
    expect(profile!.workSchedule.workDays, [1, 2, 3, 4, 5, 6]);
    expect(profile.workSchedule.dailyWorkingHours, 8.5);
  });

  testWidgets('a reminder asks for permission and shows its days', (
    tester,
  ) async {
    final repos = await pumpScreen(tester);
    await tester.tap(find.text('Resmî tatil ve köprü'));
    await tester.pumpAndSettle();
    expect(
      (await current(repos.settings)).notifications.holidayReminder,
      isTrue,
    );
    expect(find.text('7 gün önce'), findsOneWidget);
  });

  testWidgets('a denied permission keeps the reminder off', (tester) async {
    final repos = await pumpScreen(tester, granted: false);
    await tester.tap(find.text('Yeni izin hakkın doğunca'));
    await tester.pumpAndSettle();
    expect(
      find.text('Bildirim izni verilmedi. Telefonun ayarlarından açabilirsin.'),
      findsOneWidget,
    );
    expect(
      (await current(repos.settings)).notifications.accrualReminder,
      isFalse,
    );
  });

  testWidgets('a backup from a newer app is refused with its own text', (
    tester,
  ) async {
    final codec = _Codec(
      restoreResult: const Result.error(NewerBackupException(3, 1)),
    );
    await pumpScreen(tester, codec: codec);
    await tester.tap(find.text('Yedekten geri yükle'));
    await tester.pumpAndSettle();
    expect(find.text('Yedek geri yüklensin mi?'), findsOneWidget);
    await tester.tap(find.text('Geri yükle'));
    await tester.pumpAndSettle();
    expect(codec.restored, ['{}']);
    expect(find.textContaining('daha yeni bir sürümüyle'), findsOneWidget);
  });

  for (final (reason, text) in [
    (ExportFailureReason.checksumMismatch, 'geçerli bir İzin Planla yedeği'),
    (ExportFailureReason.notBackup, 'geçerli bir İzin Planla yedeği'),
    (ExportFailureReason.newerVersion, 'daha yeni bir sürümüyle'),
    (ExportFailureReason.pickFailed, 'İşlem tamamlanamadı'),
  ]) {
    testWidgets('a picked file with ${reason.name} says why at once', (
      tester,
    ) async {
      final codec = _Codec();
      await pumpScreen(
        tester,
        codec: codec,
        pick: Result.error(ExportFailure(reason)),
      );
      await tester.tap(find.text('Yedekten geri yükle'));
      await tester.pumpAndSettle();
      expect(find.text('Yedek geri yüklensin mi?'), findsNothing);
      expect(find.textContaining(text), findsOneWidget);
      expect(codec.restored, isEmpty);
    });
  }

  testWidgets('an invalid backup is refused with its own text', (tester) async {
    final codec = _Codec(
      restoreResult: const Result.error(InvalidBackupException('broken')),
    );
    await pumpScreen(tester, codec: codec);
    await tester.tap(find.text('Yedekten geri yükle'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Geri yükle'));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Bu dosya geçerli bir İzin Planla yedeği değil. '
        'Verilerin değişmedi.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('reset deletes everything, opens setup and can be undone', (
    tester,
  ) async {
    final codec = _Codec();
    await pumpScreen(tester, codec: codec);
    await tester.tap(find.text('Bütün verileri sil'));
    await tester.pumpAndSettle();
    // "Sil" stays off until the confirm word is typed.
    await tester.tap(find.text('Sil'));
    await tester.pumpAndSettle();
    expect(codec.resets, 0);
    await tester.enterText(find.byType(TextField), 'SİL');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sil'));
    await tester.pumpAndSettle();
    expect(codec.resets, 1);
    expect(find.text('onboarding'), findsOneWidget);
    expect(find.text('Bütün veriler silindi.'), findsOneWidget);
    await tester.tap(find.text('Geri al'));
    await tester.pumpAndSettle();
    expect(codec.restored, ['snapshot']);
    expect(find.text('home'), findsOneWidget);
  });

  testWidgets('export asks for the format, then shares', (tester) async {
    await pumpScreen(tester);
    await tester.tap(find.text('Dışa aktar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('CSV'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cihaza kaydet'));
    await tester.pumpAndSettle();
    expect(find.text('Dosya kaydedildi.'), findsOneWidget);
  });

  testWidgets('info rows open their screens', (tester) async {
    await pumpScreen(tester);
    await tester.tap(find.text('Hakkında'));
    await tester.pumpAndSettle();
    expect(find.text('about'), findsOneWidget);
  });

  testWidgets('empty: without a person there is no work schedule', (
    tester,
  ) async {
    await pumpScreen(tester, noProfile: true);
    expect(find.text('Henüz kişi eklemedin.'), findsOneWidget);
    expect(find.text('Çalışma düzeni'), findsNothing);
    expect(find.text('Dışa aktar'), findsNothing);
  });

  final scalers = <String, TextScaler>{
    'x2 linear': const TextScaler.linear(2),
    'x2 android': const AndroidNonlinear200(),
  };
  for (final dark in [false, true]) {
    final theme = dark ? 'dark' : 'light';
    for (final MapEntry(key: size, value: scaler) in scalers.entries) {
      for (final width in [320.0, 360.0]) {
        testWidgets('$theme, text $size, ${width.toInt()} wide: nothing '
            'overflows', (tester) async {
          await pumpScreen(
            tester,
            dark: dark,
            textScaler: scaler,
            width: width,
            height: 12000,
          );
          expect(tester.takeException(), isNull);
          await tester.scrollUntilVisible(
            find.text('Dışa aktar'),
            400,
            scrollable: find.byType(Scrollable).first,
          );
          await tester.tap(find.text('Dışa aktar'));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        });
      }
    }

    testWidgets('$theme: meets accessibility guidelines', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpScreen(tester, dark: dark);
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      semantics.dispose();
    });
  }
}
