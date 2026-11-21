import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/config/dependencies.dart';
import 'package:izin_planla/data/fakes/fake_profile_repository.dart';
import 'package:izin_planla/data/fakes/fake_settings_repository.dart';
import 'package:izin_planla/data/fakes/sample_data.dart';
import 'package:izin_planla/domain/bridge/bridge_planner.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/core/theme/app_theme.dart';
import 'package:izin_planla/ui/core/widgets/big_number_card.dart';
import 'package:izin_planla/ui/core/widgets/empty_state.dart';
import 'package:izin_planla/ui/core/widgets/week_strip.dart';
import 'package:izin_planla/ui/home/view_models/home_view_model.dart';
import 'package:izin_planla/ui/home/widgets/home_screen.dart';
import 'package:material_ui/material_ui.dart';

import '../../../config/fake_dependencies.dart';
import '../../core/golden_harness.dart' show AndroidNonlinear200;

/// Fixed "today" of every test: Friday 20 November 2026.
DateTime _now() => DateTime(2026, 11, 20, 9);

/// One bridge in April 2027: Friday off, then the weekend.
class _Planner implements BridgePlanner {
  static final suggestion = BridgeSuggestion(
    leaveDays: [DateTime.utc(2027, 4, 23)],
    vacation: DateRange(
      start: DateTime.utc(2027, 4, 23),
      end: DateTime.utc(2027, 4, 25),
    ),
    totalDaysOff: 3,
    leaveDaysUsed: 1,
  );

  @override
  List<BridgeSuggestion> suggestions({
    required int year,
    required Profile profile,
    required List<Holiday> holidays,
    double? budget,
    int maxLeaveDays = 5,
  }) => year == 2027 ? [suggestion] : const [];

  @override
  List<BridgeSuggestion> optimalPlan({
    required int year,
    required Profile profile,
    required List<Holiday> holidays,
    required double budget,
  }) => const [];
}

void main() {
  Future<void> pump(
    WidgetTester tester, {
    List<Override> overrides = const [],
    TextScaler textScaler = TextScaler.noScaling,
    double width = 360,
    bool dark = false,
  }) async {
    tester.view
      // Tall enough that the whole list is laid out, so overflow anywhere
      // in it is reported.
      ..physicalSize = Size(width, 6000)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: withFakeDependencies([
          homeViewModelProvider.overrideWith(() => HomeViewModel(clock: _now)),
          bridgePlannerProvider.overrideWithValue(_Planner()),
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
          home: const HomeScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<List<Override>> noProfile() async {
    final profiles = FakeProfileRepository();
    await profiles.delete(SampleData.profileId);
    final settings = FakeSettingsRepository();
    await settings.save(const AppSettings());
    return [
      profileRepositoryProvider.overrideWithValue(profiles),
      settingsRepositoryProvider.overrideWithValue(settings),
    ];
  }

  testWidgets('shows the balance, the countdowns and the bridge', (
    tester,
  ) async {
    await pump(tester);
    expect(find.text('İzin durumun'), findsOneWidget);
    expect(find.text('20 Kasım 2026, Cuma'), findsOneWidget);
    // Fake calculators: 7 anniversaries of 14 days, 5 used, 4 planned.
    expect(find.byType(BigNumberCard), findsOneWidget);
    expect(find.text('Kalan izin'), findsOneWidget);
    expect(
      find.text('Toplam 98 gün hak ettin, 5 gün kullandın, 4 gün planladın.'),
      findsOneWidget,
    );
    expect(find.text('İzin ekle'), findsOneWidget);
    // 15 March 2027 is 115 days away, 1 January 2027 is 42 days away.
    expect(find.text('115'), findsOneWidget);
    expect(
      find.text('15 Mart 2027, Pazartesi günü 20 gün eklenecek.'),
      findsOneWidget,
    );
    expect(find.text('42'), findsOneWidget);
    expect(find.text('Yılbaşı, 1 Ocak 2027, Cuma'), findsOneWidget);
    expect(find.text('Köprü önerisi'), findsOneWidget);
    expect(
      find.text('1 gün izinle 3 gün tatil, 23-25 Nisan 2027'),
      findsOneWidget,
    );
    expect(find.byType(WeekStrip), findsOneWidget);
    expect(find.text('İstatistikler'), findsOneWidget);
    expect(find.text('İzin kuralları'), findsOneWidget);
  });

  testWidgets('says how to start when there is no profile', (tester) async {
    await pump(tester, overrides: await noProfile());
    expect(find.byType(EmptyState), findsOneWidget);
    expect(
      find.text('İzin hakkını görmek için birkaç soruyu cevapla.'),
      findsOneWidget,
    );
    expect(find.text('Kuruluma başla'), findsOneWidget);
    expect(find.byType(BigNumberCard), findsNothing);
  });

  testWidgets('explains instead of counting for a teacher', (tester) async {
    final profiles = FakeProfileRepository();
    await profiles.save(
      SampleData.profile.copyWith(
        employmentType: EmploymentType.civilServant,
        isTeacher: true,
      ),
    );
    await pump(
      tester,
      overrides: [profileRepositoryProvider.overrideWithValue(profiles)],
    );
    expect(find.text('Yıllık izin hesabı yok'), findsOneWidget);
    expect(find.byType(BigNumberCard), findsNothing);
    expect(find.text('Yeni izin hakkı'), findsNothing);
    expect(find.text('Köprü önerisi'), findsNothing);
  });

  testWidgets('shows a negative balance plainly', (tester) async {
    final profiles = FakeProfileRepository();
    await profiles.save(
      SampleData.profile.copyWith(employmentStartDate: DateTime.utc(2026)),
    );
    await pump(
      tester,
      overrides: [profileRepositoryProvider.overrideWithValue(profiles)],
    );
    // Nothing earned yet, 9 days taken or planned.
    expect(find.textContaining('-9'), findsWidgets);
    expect(
      find.text('Hakkından 9 gün fazla izin kullandın veya planladın.'),
      findsOneWidget,
    );
    // No balance left for a bridge.
    expect(find.text('Köprü önerisi'), findsNothing);
  });

  testWidgets('names the person when there are several', (tester) async {
    final profiles = FakeProfileRepository();
    await profiles.save(
      SampleData.profile.copyWith(id: 'second', name: 'Ayşe'),
    );
    await pump(
      tester,
      overrides: [profileRepositoryProvider.overrideWithValue(profiles)],
    );
    expect(find.text('Örnek Kişi'), findsOneWidget);
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
        await pump(tester, textScaler: scaler, width: width);
        expect(tester.takeException(), isNull);
        expect(find.text('Köprü önerisi'), findsOneWidget);
      });

      testWidgets('empty, text $size, ${width.toInt()} wide: nothing '
          'overflows', (tester) async {
        await pump(
          tester,
          overrides: await noProfile(),
          textScaler: scaler,
          width: width,
        );
        expect(tester.takeException(), isNull);
      });
    }
  }

  for (final dark in [false, true]) {
    testWidgets('${dark ? 'dark' : 'light'}: meets accessibility '
        'guidelines', (tester) async {
      final semantics = tester.ensureSemantics();
      await pump(tester, dark: dark);
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      semantics.dispose();
    });
  }

  testWidgets('empty state meets accessibility guidelines', (tester) async {
    final semantics = tester.ensureSemantics();
    await pump(tester, overrides: await noProfile());
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    semantics.dispose();
  });

  testWidgets('screen reader labels', (tester) async {
    final semantics = tester.ensureSemantics();
    await pump(tester);
    // People are managed in the settings, the home page has no button.
    expect(find.byTooltip('Kişiler'), findsNothing);
    expect(
      find.bySemanticsLabel('23 Nisan 2027, Cuma, Önerilen izin'),
      findsOneWidget,
    );
    expect(
      tester.getSemantics(find.text('İzin ekle')),
      isSemantics(label: 'İzin ekle', isButton: true),
    );
    semantics.dispose();
  });
}
