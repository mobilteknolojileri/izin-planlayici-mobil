import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:izin_planla/config/dependencies.dart';
import 'package:izin_planla/data/fakes/fake_profile_repository.dart';
import 'package:izin_planla/data/fakes/fake_settings_repository.dart';
import 'package:izin_planla/data/fakes/sample_data.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/routing/routes.dart';
import 'package:izin_planla/ui/core/theme/app_theme.dart';
import 'package:izin_planla/ui/core/widgets/primary_button.dart';
import 'package:izin_planla/ui/onboarding/view_models/onboarding_view_model.dart';
import 'package:izin_planla/ui/onboarding/widgets/onboarding_screen.dart';
import 'package:material_ui/material_ui.dart';

import '../../../config/fake_dependencies.dart';
import '../../core/golden_harness.dart' show AndroidNonlinear200;

DateTime _now() => DateTime(2026, 11, 20, 9);

void main() {
  late FakeProfileRepository profiles;
  late FakeSettingsRepository settings;

  setUp(() async {
    profiles = FakeProfileRepository();
    await profiles.delete(SampleData.profileId);
    settings = FakeSettingsRepository();
    await settings.save(const AppSettings());
  });

  /// Pumps the setup inside a router, so finishing can go home.
  Future<ProviderContainer> pump(
    WidgetTester tester, {
    TextScaler textScaler = TextScaler.noScaling,
    double width = 360,
    bool dark = false,
  }) async {
    tester.view
      ..physicalSize = Size(width, 3000)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final container = ProviderContainer(
      overrides: withFakeDependencies([
        onboardingViewModelProvider.overrideWith(
          () => OnboardingViewModel(clock: _now),
        ),
        profileRepositoryProvider.overrideWithValue(profiles),
        settingsRepositoryProvider.overrideWithValue(settings),
      ]),
    );
    addTearDown(container.dispose);
    final router = GoRouter(
      initialLocation: Routes.onboarding,
      routes: [
        GoRoute(path: Routes.home, builder: (_, _) => const Text('home')),
        GoRoute(
          path: Routes.onboarding,
          builder: (_, _) => const OnboardingScreen(),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
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
    return container;
  }

  OnboardingViewModel viewModel(ProviderContainer container) =>
      container.read(onboardingViewModelProvider.notifier);

  /// Answers every question of a worker and stays on the last step.
  Future<void> answerAll(WidgetTester tester, ProviderContainer c) async {
    viewModel(c)
      ..chooseEmploymentType(EmploymentType.laborLaw)
      ..next()
      ..chooseStartDate(DateTime.utc(2019, 3, 15))
      ..next()
      ..chooseBirthDate(DateTime.utc(1990, 6))
      ..next()
      ..chooseSaturday(works: false);
    await tester.pumpAndSettle();
  }

  PrimaryButton button(WidgetTester tester) =>
      tester.widget<PrimaryButton>(find.byType(PrimaryButton));

  testWidgets('starts with one question and a disabled button', (tester) async {
    await pump(tester);
    expect(find.text('Adım 1/4'), findsOneWidget);
    expect(find.text('Nasıl çalışıyorsun?'), findsOneWidget);
    expect(
      find.text('İzin hakkı işçide ve memurda farklı hesaplanır.'),
      findsOneWidget,
    );
    expect(button(tester).onPressed, isNull);
  });

  testWidgets('an answer enables the button and moves on', (tester) async {
    await pump(tester);
    await tester.tap(find.text('İşçiyim'));
    await tester.pumpAndSettle();
    expect(button(tester).onPressed, isNotNull);
    await tester.tap(find.text('Devam'));
    await tester.pumpAndSettle();
    expect(find.text('Adım 2/4'), findsOneWidget);
    expect(find.text('Bu iş yerinde ne zaman başladın?'), findsOneWidget);
    // No date yet, so the button waits.
    expect(button(tester).onPressed, isNull);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('Adım 1/4'), findsOneWidget);
  });

  testWidgets('a civil servant is not asked the birth date', (tester) async {
    final container = await pump(tester);
    await tester.tap(find.text('Devlet memuruyum'));
    await tester.pumpAndSettle();
    expect(find.text('Adım 1/2'), findsOneWidget);
    viewModel(container)
      ..next()
      ..chooseStartDate(DateTime.utc(2015, 2));
    await tester.pumpAndSettle();
    expect(find.text('Adım 2/2'), findsOneWidget);
    expect(find.text('Doğum tarihin ne?'), findsNothing);
    await tester.tap(find.text('Bitir'));
    await tester.pumpAndSettle();
    final saved = (await profiles.watchAll().first).single;
    expect(saved.employmentType, EmploymentType.civilServant);
    expect(saved.birthDate, isNull);
  });

  testWidgets('finishing saves the profile and makes it active', (
    tester,
  ) async {
    final container = await pump(tester);
    await answerAll(tester, container);
    expect(find.text('Adım 4/4'), findsOneWidget);
    expect(find.text('Cumartesi çalışıyor musun?'), findsOneWidget);
    expect(find.text('Gelişmiş (isteğe bağlı)'), findsOneWidget);
    await tester.tap(find.text('Bitir'));
    await tester.pumpAndSettle();
    expect(find.text('home'), findsOneWidget);
    final saved = await profiles.watchAll().first;
    expect(saved, hasLength(1));
    expect(saved.single.name, 'Ben');
    expect(saved.single.employmentStartDate, DateTime.utc(2019, 3, 15));
    expect(saved.single.workSchedule.workDays, [1, 2, 3, 4, 5]);
    expect((await settings.watch().first).activeProfileId, saved.single.id);
  });

  testWidgets('a wrong number in the advanced part blocks finishing', (
    tester,
  ) async {
    final container = await pump(tester);
    await answerAll(tester, container);
    await tester.tap(find.text('Gelişmiş (isteğe bağlı)'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(3), '4,5,');
    await tester.pumpAndSettle();
    expect(find.text('Sayı yaz, örneğin 4 veya 4,5.'), findsOneWidget);
    expect(button(tester).onPressed, isNull);
  });

  final scalers = <String, TextScaler>{
    'x2 linear': const TextScaler.linear(2),
    'x2 android': const AndroidNonlinear200(),
  };
  for (final MapEntry(key: size, value: scaler) in scalers.entries) {
    for (final width in [320.0, 360.0]) {
      testWidgets('every step, text $size, ${width.toInt()} wide: nothing '
          'overflows', (tester) async {
        final container = await pump(tester, textScaler: scaler, width: width);
        expect(tester.takeException(), isNull);
        viewModel(container)
          ..chooseEmploymentType(EmploymentType.laborLaw)
          ..next();
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        viewModel(container)
          ..chooseStartDate(DateTime.utc(2019, 3, 15))
          ..next();
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        viewModel(container)
          ..chooseBirthDate(DateTime.utc(1990, 6))
          ..next();
        await tester.pumpAndSettle();
        await tester.tap(find.text('Gelişmiş (isteğe bağlı)'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text('Adım 4/4'), findsOneWidget);
      });
    }
  }

  for (final dark in [false, true]) {
    testWidgets('${dark ? 'dark' : 'light'}: first and last step meet '
        'accessibility guidelines', (tester) async {
      final semantics = tester.ensureSemantics();
      final container = await pump(tester, dark: dark);
      await tester.tap(find.text('İşçiyim'));
      await tester.pumpAndSettle();
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await answerAll(tester, container);
      await tester.tap(find.text('Gelişmiş (isteğe bağlı)'));
      await tester.pumpAndSettle();
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      semantics.dispose();
    });
  }

  testWidgets('screen reader hears the chosen answer', (tester) async {
    final semantics = tester.ensureSemantics();
    await pump(tester);
    await tester.tap(find.text('İşçiyim'));
    await tester.pumpAndSettle();
    expect(
      tester.getSemantics(find.text('İşçiyim')),
      isSemantics(isSelected: true, isButton: true),
    );
    semantics.dispose();
  });
}
