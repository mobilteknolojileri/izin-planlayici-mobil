import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:izin_planla/config/dependencies.dart';
import 'package:izin_planla/data/fakes/fake_leave_repository.dart';
import 'package:izin_planla/data/fakes/fake_profile_repository.dart';
import 'package:izin_planla/data/fakes/fake_settings_repository.dart';
import 'package:izin_planla/data/fakes/sample_data.dart';
import 'package:izin_planla/domain/bridge/bridge_planner.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/bridge/view_models/bridge_view_model.dart';
import 'package:izin_planla/ui/bridge/widgets/bridge_screen.dart';
import 'package:izin_planla/ui/core/theme/app_theme.dart';
import 'package:izin_planla/utils/result.dart';
import 'package:material_ui/material_ui.dart';

import '../../../config/fake_dependencies.dart';
import '../../core/golden_harness.dart' show AndroidNonlinear200;

/// Planner with two suggestions in 2026, or none.
class _Planner implements BridgePlanner {
  const new({this.empty = false});

  final bool empty;

  static final _long = BridgeSuggestion(
    leaveDays: [DateTime.utc(2026, 10, 26), DateTime.utc(2026, 10, 27)],
    vacation: DateRange(
      start: DateTime.utc(2026, 10, 24),
      end: DateTime.utc(2026, 11),
    ),
    totalDaysOff: 9,
    leaveDaysUsed: 3,
    holidayNames: const ['Cumhuriyet Bayramı Arifesi', 'Cumhuriyet Bayramı'],
  );

  static final _short = BridgeSuggestion(
    leaveDays: [DateTime.utc(2026, 10, 30)],
    vacation: DateRange(
      start: DateTime.utc(2026, 10, 29),
      end: DateTime.utc(2026, 11),
    ),
    totalDaysOff: 4,
    leaveDaysUsed: 1,
    holidayNames: const ['Cumhuriyet Bayramı'],
  );

  @override
  List<BridgeSuggestion> suggestions({
    required int year,
    required Profile profile,
    required List<Holiday> holidays,
    double? budget,
    int maxLeaveDays = 5,
  }) => empty ? const [] : [_long, _short];

  @override
  List<BridgeSuggestion> optimalPlan({
    required int year,
    required Profile profile,
    required List<Holiday> holidays,
    required double budget,
  }) => empty ? const [] : [_short];
}

/// Leave storage that remembers what the screen saved and deleted.
class _Leaves extends FakeLeaveRepository {
  final saved = <LeaveRecord>[];
  final deleted = <String>[];

  @override
  Future<Result<void>> save(LeaveRecord record) {
    saved.add(record);
    return super.save(record);
  }

  @override
  Future<Result<void>> delete(String id) {
    deleted.add(id);
    return super.delete(id);
  }
}

void main() {
  Future<_Leaves> pumpScreen(
    WidgetTester tester, {
    bool noSuggestions = false,
    bool noProfile = false,
    bool dark = false,
    TextScaler textScaler = TextScaler.noScaling,
    double width = 360,
  }) async {
    tester.view
      ..physicalSize = Size(width, 3200)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final profiles = FakeProfileRepository();
    final settings = FakeSettingsRepository();
    final leaves = _Leaves();
    if (noProfile) {
      await profiles.delete(SampleData.profileId);
      await settings.save(const AppSettings());
    }
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const BridgeScreen()),
        GoRoute(
          path: '/onboarding',
          builder: (_, _) => const Scaffold(body: Text('onboarding')),
        ),
        GoRoute(
          path: '/calendar',
          builder: (_, _) => const Scaffold(body: Text('calendar')),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: withFakeDependencies([
          bridgeTodayProvider.overrideWithValue(DateTime.utc(2026, 10, 20)),
          profileRepositoryProvider.overrideWithValue(profiles),
          settingsRepositoryProvider.overrideWithValue(settings),
          leaveRepositoryProvider.overrideWithValue(leaves),
          bridgePlannerProvider.overrideWithValue(
            _Planner(empty: noSuggestions),
          ),
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
    return leaves;
  }

  testWidgets('filled: plan, suggestions with week strips and one sentence', (
    tester,
  ) async {
    await pumpScreen(tester);
    expect(find.text('2026 için en iyi plan'), findsOneWidget);
    expect(
      find.text('Toplam 1 gün izinle 1 ayrı tatil yaparsın.'),
      findsOneWidget,
    );
    expect(
      find.text('3 gün izinle 9 gün tatil, 24 Ekim-1 Kasım 2026'),
      findsOne,
    );
    expect(
      find.text('1 gün izinle 4 gün tatil, 29 Ekim-1 Kasım 2026'),
      findsOne,
    );
    // Day numbers and the eve suffix are not repeated in the title.
    expect(find.text('Cumhuriyet Bayramı'), findsNWidgets(2));
    expect(find.text('En iyi planda'), findsOneWidget);
    expect(
      find.bySemanticsLabel('30 Ekim 2026, Cuma, Önerilen izin'),
      findsWidgets,
    );
    expect(find.text('2027'), findsOneWidget);
  });

  testWidgets('sorting by date puts the earlier break first', (tester) async {
    await pumpScreen(tester);
    await tester.tap(find.text('Tarihe göre'));
    await tester.pumpAndSettle();
    final long = tester
        .getTopLeft(find.text('3 gün izinle 9 gün tatil, 24 Ekim-1 Kasım 2026'))
        .dy;
    final short = tester
        .getTopLeft(find.text('1 gün izinle 4 gün tatil, 29 Ekim-1 Kasım 2026'))
        .dy;
    expect(long, lessThan(short));
  });

  testWidgets('budget buttons change the budget', (tester) async {
    await pumpScreen(tester);
    final before = tester
        .widget<Text>(find.textContaining(RegExp(r'^\d+ gün$')).first)
        .data;
    await tester.tap(find.byTooltip('Bütçeyi bir gün azalt'));
    await tester.pumpAndSettle();
    final after = tester
        .widget<Text>(find.textContaining(RegExp(r'^\d+ gün$')).first)
        .data;
    expect(after, isNot(before));
  });

  testWidgets('Planla saves one planned annual leave and can be undone', (
    tester,
  ) async {
    final leaves = await pumpScreen(tester);
    await tester.tap(find.text('Planla').first);
    await tester.pumpAndSettle();
    expect(find.text('İzin planına eklendi.'), findsOneWidget);
    final added = leaves.saved.single;
    expect(added.type, LeaveType.annual);
    // The most efficient suggestion comes first: leave on 30 October.
    expect(added.range.start, DateTime.utc(2026, 10, 30));
    expect(added.range.end, DateTime.utc(2026, 10, 30));
    expect(find.text('Planlandı'), findsOneWidget);
    await tester.tap(find.text('Geri al'));
    await tester.pumpAndSettle();
    expect(leaves.deleted, [added.id]);
    expect(find.text('Planlandı'), findsNothing);
  });

  testWidgets('empty: no suggestion shows the empty state', (tester) async {
    await pumpScreen(tester, noSuggestions: true);
    expect(find.text('Bu yıl için köprü önerisi yok.'), findsOneWidget);
    expect(find.text('Bu bütçeyle köprü yapılamıyor.'), findsOneWidget);
    await tester.tap(find.text('Takvimi aç'));
    await tester.pumpAndSettle();
    expect(find.text('calendar'), findsOneWidget);
  });

  testWidgets('empty: without a person the screen asks for setup', (
    tester,
  ) async {
    await pumpScreen(tester, noProfile: true);
    expect(
      find.text('Köprü önerilerini görmek için önce kurulumu tamamla.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Kuruluma başla'));
    await tester.pumpAndSettle();
    expect(find.text('onboarding'), findsOneWidget);
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
              noSuggestions: empty,
            );
            expect(tester.takeException(), isNull);
          });
        }
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
