import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:izin_planla/config/dependencies.dart';
import 'package:izin_planla/data/fakes/fake_calculators.dart';
import 'package:izin_planla/data/fakes/fake_leave_repository.dart';
import 'package:izin_planla/data/fakes/fake_profile_repository.dart';
import 'package:izin_planla/data/fakes/fake_settings_repository.dart';
import 'package:izin_planla/data/fakes/sample_data.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/calendar/view_models/calendar_view_model.dart';
import 'package:izin_planla/ui/calendar/widgets/calendar_screen.dart';
import 'package:izin_planla/ui/core/theme/app_theme.dart';
import 'package:izin_planla/ui/core/widgets/legend_row.dart';
import 'package:material_ui/material_ui.dart';

import '../../../config/fake_dependencies.dart';
import '../../core/golden_harness.dart' show AndroidNonlinear200;

/// Sample planner that remembers the `after` day of every plan request.
class _Planner extends FakeBridgePlanner {
  final after = <DateTime?>[];

  @override
  List<BridgeSuggestion> optimalPlan({
    required int year,
    required Profile profile,
    required List<Holiday> holidays,
    required double budget,
    DateTime? after,
  }) {
    this.after.add(after);
    return super.optimalPlan(
      year: year,
      profile: profile,
      holidays: holidays,
      budget: budget,
      after: after,
    );
  }
}

void main() {
  final today = DateTime.utc(2026, 10, 20);

  Future<List<String>> pumpScreen(
    WidgetTester tester, {
    bool empty = false,
    _Planner? planner,
    bool dark = false,
    TextScaler textScaler = TextScaler.noScaling,
    double width = 360,
    double height = 2800,
  }) async {
    tester.view
      ..physicalSize = Size(width, height)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final profiles = FakeProfileRepository();
    final leaves = FakeLeaveRepository();
    final settings = FakeSettingsRepository();
    if (empty) {
      await profiles.delete(SampleData.profileId);
      for (final leave in SampleData.leaves) {
        await leaves.delete(leave.id);
      }
      await settings.save(const AppSettings());
    } else {
      await profiles.save(
        Profile(
          id: 'second',
          name: 'Ayşe',
          employmentType: EmploymentType.civilServant,
          employmentStartDate: DateTime.utc(2015, 2),
          birthDate: DateTime.utc(1985, 5, 5),
        ),
      );
      await leaves.save(
        LeaveRecord(
          id: 'second-leave',
          profileId: 'second',
          type: LeaveType.sick,
          range: DateRange(
            start: DateTime.utc(2026, 10, 13),
            end: DateTime.utc(2026, 10, 14),
          ),
        ),
      );
    }
    final pushed = <String>[];
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const CalendarScreen()),
        GoRoute(
          path: '/leave-form',
          builder: (_, state) {
            pushed.add(state.uri.toString());
            return const Scaffold(body: SizedBox.shrink());
          },
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: withFakeDependencies([
          calendarTodayProvider.overrideWithValue(today),
          profileRepositoryProvider.overrideWithValue(profiles),
          leaveRepositoryProvider.overrideWithValue(leaves),
          settingsRepositoryProvider.overrideWithValue(settings),
          if (planner != null) bridgePlannerProvider.overrideWithValue(planner),
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
            // Same bridge as the app, table_calendar still uses the old
            // Material library.
            // ignore: deprecated_member_use
            child: MaterialUiCompatibilityBridge(child: child!),
          ),
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
    return pushed;
  }

  testWidgets('suggests only days after today', (tester) async {
    final planner = _Planner();
    await pumpScreen(tester, planner: planner);
    expect(planner.after, isNotEmpty);
    expect(planner.after.toSet(), {today});
  });

  testWidgets('month view marks holidays, eves, leave and bridges', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pumpScreen(tester);
    expect(find.text('Ekim 2026'), findsOneWidget);
    expect(find.byType(LegendRow), findsOneWidget);
    expect(
      find.bySemanticsLabel(
        RegExp('^Perşembe, 29 Ekim 2026\nResmî tatil: Cumhuriyet Bayramı'),
      ),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel(RegExp('^Çarşamba, 28 Ekim 2026\n.*Arifesi')),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel(RegExp('^Cuma, 30 Ekim 2026\n1 gün izinle 4 gün')),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel(RegExp('^Salı, 20 Ekim 2026\nBugün')),
      findsOneWidget,
    );
    semantics.dispose();
  });

  testWidgets('tapping a day shows its details', (tester) async {
    await pumpScreen(tester);
    await tester.tap(find.bySemanticsLabel(RegExp(', 29 Ekim 2026\n')));
    await tester.pumpAndSettle();
    expect(find.text('29 Ekim 2026, Perşembe'), findsOneWidget);
    expect(find.text('Resmî tatil: Cumhuriyet Bayramı'), findsOneWidget);
    expect(find.text('Bu güne izin ekle'), findsOneWidget);
  });

  testWidgets('next month button moves the calendar', (tester) async {
    await pumpScreen(tester);
    await tester.tap(find.byTooltip('Sonraki ay'));
    await tester.pumpAndSettle();
    expect(find.text('Kasım 2026'), findsOneWidget);
  });

  testWidgets('a selected range opens the leave form with its dates', (
    tester,
  ) async {
    final pushed = await pumpScreen(tester);
    await tester.tap(find.text('Aralık seç'));
    await tester.pumpAndSettle();
    expect(find.text('İznin ilk gününe, sonra son gününe dokun.'), findsOne);
    await tester.tap(find.bySemanticsLabel(RegExp(', 21 Ekim 2026\n')));
    await tester.pumpAndSettle();
    expect(find.text('Şimdi iznin son gününe dokun.'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel(RegExp(', 23 Ekim 2026\n')));
    await tester.pumpAndSettle();
    expect(
      find.text('Seçtiğin aralık 21-23 Ekim 2026, toplam 3 gün.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Bu tarihlere izin ekle'));
    await tester.pumpAndSettle();
    expect(pushed, ['/leave-form?start=2026-10-21&end=2026-10-23']);
  });

  testWidgets('everyone view names the people on leave', (tester) async {
    await pumpScreen(tester);
    await tester.tap(find.text('Herkesi göster'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel(RegExp(', 13 Ekim 2026\n')));
    await tester.pumpAndSettle();
    expect(
      find.text('Ayşe: Hastalık ve rapor, 13-14 Ekim 2026'),
      findsOneWidget,
    );
  });

  testWidgets('year view opens a month', (tester) async {
    await pumpScreen(tester);
    await tester.tap(find.text('Yıllık'));
    await tester.pumpAndSettle();
    expect(find.text('2026'), findsOneWidget);
    expect(
      find.bySemanticsLabel(RegExp('^Temmuz 2026, 5 gün izin')),
      findsOneWidget,
    );
    await tester.tap(find.bySemanticsLabel(RegExp('^Aralık 2026')));
    await tester.pumpAndSettle();
    expect(find.text('Aralık 2026'), findsOneWidget);
  });

  testWidgets('empty: without people the calendar still shows holidays', (
    tester,
  ) async {
    await pumpScreen(tester, empty: true);
    expect(find.text('Herkesi göster'), findsNothing);
    expect(
      find.bySemanticsLabel(RegExp('^Perşembe, 29 Ekim 2026\nResmî tatil')),
      findsOneWidget,
    );
    expect(find.text('Çalışma günü'), findsWidgets);
  });

  final scalers = <String, TextScaler>{
    'x2 linear': const TextScaler.linear(2),
    'x2 android': const AndroidNonlinear200(),
  };
  for (final dark in [false, true]) {
    final theme = dark ? 'dark' : 'light';
    for (final MapEntry(key: size, value: scaler) in scalers.entries) {
      for (final width in [320.0, 360.0]) {
        testWidgets('$theme, text $size, ${width.toInt()} wide: month and '
            'year views do not overflow', (tester) async {
          await pumpScreen(
            tester,
            dark: dark,
            textScaler: scaler,
            width: width,
          );
          expect(tester.takeException(), isNull);
          await tester.tap(find.text('Yıllık'));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        });
      }
    }

    testWidgets('$theme: month view meets accessibility guidelines', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      // At 360 dp the seven day columns are exactly 48 dp wide.
      await pumpScreen(tester, dark: dark);
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      semantics.dispose();
    });

    testWidgets('$theme: year view meets accessibility guidelines', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await pumpScreen(tester, dark: dark);
      await tester.tap(find.text('Yıllık'));
      await tester.pumpAndSettle();
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      semantics.dispose();
    });
  }
}
