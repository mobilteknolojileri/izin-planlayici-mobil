import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/config/dependencies.dart';
import 'package:izin_planla/data/fakes/fake_leave_repository.dart';
import 'package:izin_planla/data/fakes/fake_profile_repository.dart';
import 'package:izin_planla/data/fakes/fake_settings_repository.dart';
import 'package:izin_planla/data/fakes/sample_data.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/core/theme/app_theme.dart';
import 'package:izin_planla/ui/core/widgets/empty_state.dart';
import 'package:izin_planla/ui/people/view_models/people_view_model.dart';
import 'package:izin_planla/ui/people/widgets/people_form_page.dart';
import 'package:izin_planla/ui/people/widgets/people_screen.dart';
import 'package:izin_planla/ui/people/widgets/profile_advanced_fields.dart';
import 'package:material_ui/material_ui.dart';

import '../../../config/fake_dependencies.dart';
import '../../core/golden_harness.dart' show AndroidNonlinear200;

DateTime _now() => DateTime(2026, 11, 20, 9);

void main() {
  late FakeProfileRepository profiles;
  late FakeSettingsRepository settings;
  late FakeLeaveRepository leaves;

  setUp(() {
    profiles = FakeProfileRepository();
    settings = FakeSettingsRepository();
    leaves = FakeLeaveRepository();
  });

  Future<void> pump(
    WidgetTester tester, {
    Widget home = const PeopleScreen(),
    TextScaler textScaler = TextScaler.noScaling,
    double width = 360,
    bool dark = false,
  }) async {
    tester.view
      ..physicalSize = Size(width, 4000)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final overrides = <Override>[
      peopleViewModelProvider.overrideWith(() => PeopleViewModel(clock: _now)),
      profileRepositoryProvider.overrideWithValue(profiles),
      settingsRepositoryProvider.overrideWithValue(settings),
      leaveRepositoryProvider.overrideWithValue(leaves),
    ];
    await tester.pumpWidget(
      ProviderScope(
        overrides: withFakeDependencies(overrides),
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
          home: home,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> addSecondPerson() => profiles.save(
    SampleData.profile.copyWith(
      id: 'second',
      name: 'Ayşe',
      employmentType: EmploymentType.civilServant,
    ),
  );

  testWidgets('lists everyone and marks the active person', (tester) async {
    await addSecondPerson();
    await pump(tester);
    expect(find.text('Kişiler'), findsOneWidget);
    expect(find.text('Örnek Kişi'), findsOneWidget);
    expect(find.text('Ayşe'), findsOneWidget);
    expect(
      find.text('Seçili\nİşçi, İş Kanunu\n15 Mart 2019, Cuma'),
      findsOneWidget,
    );
    expect(
      find.text('Memur, Devlet Memurları Kanunu\n15 Mart 2019, Cuma'),
      findsOneWidget,
    );
    expect(find.text('Kişi ekle'), findsOneWidget);
  });

  testWidgets('tapping a person makes them active', (tester) async {
    await addSecondPerson();
    await pump(tester);
    await tester.tap(find.text('Ayşe'));
    await tester.pumpAndSettle();
    expect((await settings.watch().first).activeProfileId, 'second');
    expect(
      find.text('Seçili\nMemur, Devlet Memurları Kanunu\n15 Mart 2019, Cuma'),
      findsOneWidget,
    );
  });

  testWidgets('shows the empty state when nobody is added', (tester) async {
    await profiles.delete(SampleData.profileId);
    await pump(tester);
    expect(find.byType(EmptyState), findsOneWidget);
    expect(find.text('Henüz kimseyi eklemedin.'), findsOneWidget);
  });

  testWidgets('the form asks for the missing answers', (tester) async {
    await pump(tester);
    await tester.tap(find.text('Kişi ekle'));
    await tester.pumpAndSettle();
    expect(find.text('Yeni kişi'), findsOneWidget);
    await tester.tap(find.text('Kaydet'));
    await tester.pumpAndSettle();
    expect(find.text('Bir ad yaz.'), findsOneWidget);
    expect(find.text('Tarihi seç.'), findsNWidgets(2));
    expect(find.byType(PeopleFormPage), findsOneWidget);
  });

  testWidgets('the form saves an edited person', (tester) async {
    await pump(tester);
    await tester.tap(find.byTooltip('Örnek Kişi bilgilerini düzenle'));
    await tester.pumpAndSettle();
    expect(find.text('Kişiyi düzenle'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, 'Mehtap');
    await tester.tap(find.text('Kaydet'));
    await tester.pumpAndSettle();
    expect(find.byType(PeopleFormPage), findsNothing);
    expect(find.text('Mehtap'), findsOneWidget);
    expect((await profiles.findById(SampleData.profileId))?.name, 'Mehtap');
  });

  testWidgets('a delete can be undone with the leave records', (tester) async {
    await addSecondPerson();
    await pump(tester);
    await tester.tap(find.byTooltip('Örnek Kişi bilgilerini düzenle'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Kişiyi sil'));
    await tester.pumpAndSettle();
    expect(find.text('Örnek Kişi silindi.'), findsOneWidget);
    expect(find.text('Örnek Kişi'), findsNothing);
    expect((await settings.watch().first).activeProfileId, 'second');
    await tester.tap(find.text('Geri al'));
    await tester.pumpAndSettle();
    expect(find.text('Örnek Kişi'), findsOneWidget);
    expect(
      (await settings.watch().first).activeProfileId,
      SampleData.profileId,
    );
    expect(
      await leaves.watchForProfile(SampleData.profileId).first,
      hasLength(2),
    );
  });

  final scalers = <String, TextScaler>{
    'x2 linear': const TextScaler.linear(2),
    'x2 android': const AndroidNonlinear200(),
  };
  for (final MapEntry(key: size, value: scaler) in scalers.entries) {
    for (final width in [320.0, 360.0]) {
      testWidgets('list, text $size, ${width.toInt()} wide: nothing '
          'overflows', (tester) async {
        await addSecondPerson();
        await pump(tester, textScaler: scaler, width: width);
        expect(tester.takeException(), isNull);
      });

      testWidgets('empty, text $size, ${width.toInt()} wide: nothing '
          'overflows', (tester) async {
        await profiles.delete(SampleData.profileId);
        await pump(tester, textScaler: scaler, width: width);
        expect(tester.takeException(), isNull);
      });

      testWidgets('form, text $size, ${width.toInt()} wide: nothing '
          'overflows', (tester) async {
        await pump(
          tester,
          home: PeopleFormPage(
            today: DateTime.utc(2026, 11, 20),
            profile: SampleData.profile,
          ),
          textScaler: scaler,
          width: width,
        );
        await tester.tap(find.byType(ExpansionTile));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.byType(ProfileAdvancedFields), findsOneWidget);
      });
    }
  }

  for (final dark in [false, true]) {
    testWidgets('${dark ? 'dark' : 'light'}: list meets accessibility '
        'guidelines', (tester) async {
      final semantics = tester.ensureSemantics();
      await addSecondPerson();
      await pump(tester, dark: dark);
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      semantics.dispose();
    });

    testWidgets('${dark ? 'dark' : 'light'}: form meets accessibility '
        'guidelines', (tester) async {
      final semantics = tester.ensureSemantics();
      await pump(
        tester,
        home: PeopleFormPage(
          today: DateTime.utc(2026, 11, 20),
          profile: SampleData.profile,
        ),
        dark: dark,
      );
      await tester.tap(find.byType(ExpansionTile));
      await tester.pumpAndSettle();
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      semantics.dispose();
    });
  }

  testWidgets('empty state meets accessibility guidelines', (tester) async {
    final semantics = tester.ensureSemantics();
    await profiles.delete(SampleData.profileId);
    await pump(tester);
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    semantics.dispose();
  });

  testWidgets('screen reader hears which person is selected', (tester) async {
    final semantics = tester.ensureSemantics();
    await addSecondPerson();
    await pump(tester);
    expect(
      tester.getSemantics(find.text('Örnek Kişi')),
      matchesSemantics(
        isSelected: true,
        hasSelectedState: true,
        isInMutuallyExclusiveGroup: true,
        isButton: true,
        hasTapAction: true,
        hasFocusAction: true,
        isFocusable: true,
        hasEnabledState: true,
        isEnabled: true,
        label: 'Örnek Kişi\nSeçili\nİşçi, İş Kanunu\n15 Mart 2019, Cuma',
      ),
    );
    semantics.dispose();
  });
}
