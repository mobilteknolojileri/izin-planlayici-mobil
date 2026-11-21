import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:izin_planla/config/dependencies.dart';
import 'package:izin_planla/data/fakes/fake_leave_repository.dart';
import 'package:izin_planla/data/fakes/fake_profile_repository.dart';
import 'package:izin_planla/data/fakes/fake_settings_repository.dart';
import 'package:izin_planla/data/fakes/sample_data.dart';
import 'package:izin_planla/domain/day_count/year_summary_calculator.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/core/theme/app_theme.dart';
import 'package:izin_planla/ui/stats/view_models/stats_view_model.dart';
import 'package:izin_planla/ui/stats/widgets/stats_screen.dart';
import 'package:material_ui/material_ui.dart';

import '../../../config/fake_dependencies.dart';
import '../../core/golden_harness.dart' show AndroidNonlinear200;

/// Fixed statistics that depend on the year, with leave in two months and
/// of two types.
class _Calculator implements YearSummaryCalculator {
  const new();

  @override
  YearSummary summary({
    required int year,
    required Profile profile,
    required List<EntitlementPeriod> periods,
    required List<LeaveRecord> leaves,
    required List<Holiday> holidays,
  }) => YearSummary(
    year: year,
    earned: 14,
    used: year == 2026 ? 9 : 4.5,
    totalDaysOff: year == 2026 ? 130 : 120,
    usedByType: const {LeaveType.annual: 9, LeaveType.sick: 2},
    usedByMonth: const {7: 5, 12: 4},
  );
}

void main() {
  Future<List<String>> pumpScreen(
    WidgetTester tester, {
    bool noLeaves = false,
    bool noProfile = false,
    bool twoPeople = false,
    bool dark = false,
    TextScaler textScaler = TextScaler.noScaling,
    double width = 360,
  }) async {
    tester.view
      ..physicalSize = Size(width, 3600)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final profiles = FakeProfileRepository();
    final leaves = FakeLeaveRepository();
    final settings = FakeSettingsRepository();
    if (noProfile) {
      await profiles.delete(SampleData.profileId);
      await settings.save(const AppSettings());
    }
    if (noLeaves || noProfile) {
      for (final leave in SampleData.leaves) {
        await leaves.delete(leave.id);
      }
    }
    if (twoPeople) {
      await profiles.save(
        Profile(
          id: 'second',
          name: 'Ayşe',
          employmentType: EmploymentType.civilServant,
          employmentStartDate: DateTime.utc(2024, 2),
          birthDate: DateTime.utc(1985, 5, 5),
        ),
      );
    }
    final pushed = <String>[];
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const StatsScreen()),
        GoRoute(
          path: '/leave-form',
          builder: (_, state) {
            pushed.add(state.uri.toString());
            return const Scaffold(body: SizedBox.shrink());
          },
        ),
        GoRoute(
          path: '/onboarding',
          builder: (_, _) => const Scaffold(body: Text('onboarding')),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: withFakeDependencies([
          statsTodayProvider.overrideWithValue(DateTime.utc(2026, 11, 20)),
          profileRepositoryProvider.overrideWithValue(profiles),
          leaveRepositoryProvider.overrideWithValue(leaves),
          settingsRepositoryProvider.overrideWithValue(settings),
          yearSummaryCalculatorProvider.overrideWithValue(const _Calculator()),
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
            // Same bridge as the app, fl_chart still uses the old Material
            // library.
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

  testWidgets('filled: days off, earned and used, charts with text', (
    tester,
  ) async {
    await pumpScreen(tester);
    expect(find.text('İstatistik'), findsOneWidget);
    expect(find.text('2026 yılında tatil'), findsOneWidget);
    expect(find.text('İzin, resmî tatil ve hafta sonu birlikte.'), findsOne);
    expect(find.text('Hak edilen'), findsWidgets);
    expect(
      find.text('2026: hak edilen 14 gün, kullanılan 9 gün'),
      findsOneWidget,
    );
    expect(
      find.text('2025: hak edilen 14 gün, kullanılan 4,5 gün'),
      findsOneWidget,
    );
    expect(find.text('Temmuz: 5 gün'), findsOneWidget);
    expect(find.text('Aralık: 4 gün'), findsOneWidget);
    expect(find.text('Yıllık izin'), findsOneWidget);
    expect(find.text('Hastalık ve rapor'), findsOneWidget);
    expect(
      find.bySemanticsLabel(RegExp('^Yıllara göre hak edilen')),
      findsOneWidget,
    );
    expect(find.bySemanticsLabel('Yıllık izin: 9 gün'), findsOneWidget);
    // Only one person, no person filter.
    expect(find.text('Herkes'), findsNothing);
  });

  testWidgets('year chips change the year', (tester) async {
    await pumpScreen(tester);
    await tester.tap(find.widgetWithText(ChoiceChip, '2024'));
    await tester.pumpAndSettle();
    expect(find.text('2024 yılında tatil'), findsOneWidget);
  });

  testWidgets('person filter sums everyone', (tester) async {
    await pumpScreen(tester, twoPeople: true);
    expect(find.text('Ayşe'), findsOneWidget);
    await tester.tap(find.text('Herkes'));
    await tester.pumpAndSettle();
    expect(
      find.text('Herkesin izin, resmî tatil ve hafta sonu günleri birlikte.'),
      findsOneWidget,
    );
    expect(find.text('260 gün', findRichText: true), findsOneWidget);
  });

  testWidgets('empty: no leave shows the empty state with one button', (
    tester,
  ) async {
    final pushed = await pumpScreen(tester, noLeaves: true);
    expect(
      find.text(
        'Henüz izin eklemedin. İzin ekleyince özetini burada görürsün.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('İzin ekle'));
    await tester.pumpAndSettle();
    expect(pushed, ['/leave-form']);
  });

  testWidgets('empty: without a person the screen asks for setup', (
    tester,
  ) async {
    await pumpScreen(tester, noProfile: true);
    expect(
      find.text('İstatistiği görmek için önce kurulumu tamamla.'),
      findsOneWidget,
    );
  });

  final scalers = <String, TextScaler>{
    'x2 linear': const TextScaler.linear(2),
    'x2 android': const AndroidNonlinear200(),
  };
  for (final dark in [false, true]) {
    final theme = dark ? 'dark' : 'light';
    for (final MapEntry(key: size, value: scaler) in scalers.entries) {
      for (final width in [320.0, 360.0]) {
        for (final empty in [false, true]) {
          testWidgets('$theme, text $size, ${width.toInt()} wide, '
              '${empty ? 'empty' : 'filled'}: nothing overflows', (
            tester,
          ) async {
            await pumpScreen(
              tester,
              dark: dark,
              textScaler: scaler,
              width: width,
              noLeaves: empty,
              twoPeople: true,
            );
            expect(tester.takeException(), isNull);
          });
        }
      }
    }

    testWidgets('$theme: meets accessibility guidelines', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpScreen(tester, dark: dark, twoPeople: true);
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      semantics.dispose();
    });
  }
}
