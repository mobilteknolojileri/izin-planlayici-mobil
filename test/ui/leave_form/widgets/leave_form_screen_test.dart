import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/config/dependencies.dart';
import 'package:izin_planla/data/fakes/fake_leave_repository.dart';
import 'package:izin_planla/data/fakes/fake_profile_repository.dart';
import 'package:izin_planla/data/fakes/fake_settings_repository.dart';
import 'package:izin_planla/data/fakes/sample_data.dart';
import 'package:izin_planla/domain/day_count/split_rule_checker.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/core/theme/app_theme.dart';
import 'package:izin_planla/ui/core/widgets/day_breakdown_list.dart';
import 'package:izin_planla/ui/core/widgets/empty_state.dart';
import 'package:izin_planla/ui/leave_form/view_models/leave_form_view_model.dart';
import 'package:izin_planla/ui/leave_form/widgets/leave_form_screen.dart';
import 'package:material_ui/material_ui.dart';

import '../../../config/fake_dependencies.dart';
import '../../core/golden_harness.dart' show AndroidNonlinear200;

DateTime _now() => DateTime(2026, 11, 20, 9);

/// Warns about the split rule whenever it is asked.
class _SplitWarning implements SplitRuleChecker {
  @override
  List<LeaveWarning> check({
    required Profile profile,
    required List<EntitlementPeriod> periods,
    required List<LeaveRecord> leaves,
    required List<Holiday> holidays,
  }) => const [LeaveWarning(type: LeaveWarningType.splitRule)];
}

void main() {
  late FakeLeaveRepository leaves;

  setUp(() => leaves = FakeLeaveRepository());

  Future<void> pump(
    WidgetTester tester, {
    LeaveFormScreen screen = const LeaveFormScreen(),
    List<Override> overrides = const [],
    TextScaler textScaler = TextScaler.noScaling,
    double width = 360,
    bool dark = false,
  }) async {
    tester.view
      ..physicalSize = Size(width, 8000)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: withFakeDependencies([
          leaveFormViewModelProvider.overrideWith2(
            (args) => LeaveFormViewModel(args, clock: _now),
          ),
          leaveRepositoryProvider.overrideWithValue(leaves),
          ...overrides,
        ]),
        child: MaterialApp(
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
          home: screen,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Monday 23 to Friday 27 November 2026.
  final week = LeaveFormScreen(
    start: DateTime.utc(2026, 11, 23),
    end: DateTime.utc(2026, 11, 27),
  );

  testWidgets('an empty form asks for a date before saving', (tester) async {
    await pump(tester);
    expect(find.text('İzin ekle'), findsOneWidget);
    expect(find.text('Yıllık izin'), findsOneWidget);
    expect(
      find.text('Tarihi seçince kaç gün düşüleceğini burada görürsün.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Kaydet'));
    await tester.pumpAndSettle();
    expect(find.text('Tarihi seç.'), findsOneWidget);
    expect(
      await leaves.watchForProfile(SampleData.profileId).first,
      hasLength(2),
    );
  });

  testWidgets('a chosen range shows the days at once, day by day', (
    tester,
  ) async {
    await pump(tester, screen: week);
    expect(find.text('Yıllık izninden 5 gün düşülecek.'), findsOneWidget);
    // 98 earned, 9 already taken or planned, 5 more.
    expect(find.text('Bu izinden sonra 84 gün iznin kalır.'), findsOneWidget);
    expect(find.byType(DayBreakdownList), findsOneWidget);
    // Once in the start field, once in the breakdown.
    expect(find.text('23 Kasım 2026, Pazartesi'), findsNWidgets(2));
    expect(find.text('Dikkat'), findsNothing);
  });

  testWidgets('saving adds the leave', (tester) async {
    await pump(tester, screen: week);
    await tester.tap(find.text('Kaydet'));
    await tester.pumpAndSettle();
    final saved = await leaves.watchForProfile(SampleData.profileId).first;
    expect(saved, hasLength(3));
    expect(
      saved.last.range,
      DateRange(
        start: DateTime.utc(2026, 11, 23),
        end: DateTime.utc(2026, 11, 27),
      ),
    );
  });

  testWidgets('warns when the balance goes below zero', (tester) async {
    await pump(
      tester,
      screen: LeaveFormScreen(
        start: DateTime.utc(2026, 11, 23),
        end: DateTime.utc(2027, 6, 30),
      ),
    );
    expect(find.text('Dikkat'), findsOneWidget);
    expect(find.textContaining('gün eksiye düşer'), findsOneWidget);
  });

  testWidgets('shows the split rule warning', (tester) async {
    await pump(
      tester,
      screen: week,
      overrides: [splitRuleCheckerProvider.overrideWithValue(_SplitWarning())],
    );
    expect(
      find.text(
        'Yıllık izni bölerek kullanıyorsan parçalardan biri en az 10 gün '
        'olmalı.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('a leave that does not reduce the balance says so', (
    tester,
  ) async {
    await pump(tester, screen: week);
    await tester.tap(find.text('Yıllık izin'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Evlenme izni'));
    await tester.pumpAndSettle();
    expect(find.text('Bu izin yıllık izninden düşmez.'), findsOneWidget);
    // The fake advisor suggests 3 days for marriage.
    expect(find.text('Kanuna göre bu izin 3 gün.'), findsOneWidget);
    expect(find.byType(DayBreakdownList), findsNothing);
  });

  testWidgets('hourly leave cannot be longer than a working day', (
    tester,
  ) async {
    await pump(tester, screen: week);
    await tester.tap(find.text('Saatlik'));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Kanunda yarım gün ve saatlik izin yok. Bu kayıt iş yerinin '
        'uygulamasına göre tutulur.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Kaydet'));
    await tester.pumpAndSettle();
    expect(find.text('Saati yaz, örneğin 2 veya 1,5.'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, '10');
    await tester.pumpAndSettle();
    expect(
      find.text('Günlük çalışma saatin 8. Daha uzun izin için tam gün seç.'),
      findsOneWidget,
    );
    await tester.enterText(find.byType(TextFormField).first, '2');
    await tester.pumpAndSettle();
    expect(find.text('Yıllık izninden 2 saat düşülecek.'), findsOneWidget);
  });

  testWidgets('an "other" leave needs a name', (tester) async {
    await pump(tester, screen: week);
    await tester.tap(find.text('Yıllık izin'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Diğer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kaydet'));
    await tester.pumpAndSettle();
    expect(find.text('İzne bir ad ver.'), findsOneWidget);
  });

  testWidgets('edits an existing leave and deletes it with undo', (
    tester,
  ) async {
    await pump(
      tester,
      screen: const LeaveFormScreen(leaveId: 'sample-leave-1'),
    );
    expect(find.text('İzni düzenle'), findsOneWidget);
    expect(find.text('6 Temmuz 2026, Pazartesi'), findsWidgets);
    await tester.tap(find.byTooltip('İzni sil'));
    await tester.pumpAndSettle();
    expect(find.text('İzin silindi.'), findsOneWidget);
    expect(
      await leaves.watchForProfile(SampleData.profileId).first,
      hasLength(1),
    );
    await tester.tap(find.text('Geri al'));
    await tester.pumpAndSettle();
    expect(
      await leaves.watchForProfile(SampleData.profileId).first,
      hasLength(2),
    );
  });

  testWidgets('says how to start when there is no profile', (tester) async {
    final profiles = FakeProfileRepository();
    await profiles.delete(SampleData.profileId);
    final settings = FakeSettingsRepository();
    await settings.save(const AppSettings());
    await pump(
      tester,
      overrides: [
        profileRepositoryProvider.overrideWithValue(profiles),
        settingsRepositoryProvider.overrideWithValue(settings),
      ],
    );
    expect(find.byType(EmptyState), findsOneWidget);
    expect(
      find.text('İzin eklemek için önce kurulumu tamamla.'),
      findsOneWidget,
    );
  });

  test('location carries the leave or the range in the query', () {
    expect(LeaveFormScreen.location(leaveId: 'a1'), '/leave-form?id=a1');
    expect(
      LeaveFormScreen.location(
        start: DateTime.utc(2026, 11, 23),
        end: DateTime.utc(2026, 11, 27),
      ),
      '/leave-form?start=2026-11-23&end=2026-11-27',
    );
  });

  final scalers = <String, TextScaler>{
    'x2 linear': const TextScaler.linear(2),
    'x2 android': const AndroidNonlinear200(),
  };
  for (final MapEntry(key: size, value: scaler) in scalers.entries) {
    for (final width in [320.0, 360.0]) {
      testWidgets('text $size, ${width.toInt()} wide: nothing overflows', (
        tester,
      ) async {
        await pump(
          tester,
          screen: week,
          overrides: [
            splitRuleCheckerProvider.overrideWithValue(_SplitWarning()),
          ],
          textScaler: scaler,
          width: width,
        );
        expect(tester.takeException(), isNull);
        expect(find.byType(DayBreakdownList), findsOneWidget);
        await tester.tap(find.text('Saatlik'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets('empty form, text $size, ${width.toInt()} wide: nothing '
          'overflows', (tester) async {
        await pump(tester, textScaler: scaler, width: width);
        await tester.tap(find.text('Kaydet'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }

  for (final dark in [false, true]) {
    testWidgets('${dark ? 'dark' : 'light'}: meets accessibility '
        'guidelines', (tester) async {
      final semantics = tester.ensureSemantics();
      await pump(
        tester,
        screen: week,
        overrides: [
          splitRuleCheckerProvider.overrideWithValue(_SplitWarning()),
        ],
        dark: dark,
      );
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      semantics.dispose();
    });
  }

  testWidgets('empty form with errors meets accessibility guidelines', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pump(tester);
    await tester.tap(find.text('Kaydet'));
    await tester.pumpAndSettle();
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    semantics.dispose();
  });

  testWidgets('screen reader hears the date fields as buttons', (tester) async {
    final semantics = tester.ensureSemantics();
    await pump(tester, screen: week);
    expect(
      tester.getSemantics(find.text('Başlangıç')),
      isSemantics(label: 'Başlangıç\n23 Kasım 2026, Pazartesi', isButton: true),
    );
    semantics.dispose();
  });
}
