import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/config/dependencies.dart';
import 'package:izin_planla/data/fakes/fake_profile_repository.dart';
import 'package:izin_planla/data/fakes/fake_settings_repository.dart';
import 'package:izin_planla/data/fakes/sample_data.dart';
import 'package:izin_planla/domain/entitlement/entitlement_calculator.dart';
import 'package:izin_planla/domain/entitlement/entitlement_rule.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/core/theme/app_theme.dart';
import 'package:izin_planla/ui/core/widgets/empty_state.dart';
import 'package:izin_planla/ui/explain/view_models/explain_view_model.dart';
import 'package:izin_planla/ui/explain/widgets/explain_screen.dart';
import 'package:material_ui/material_ui.dart';

import '../../../config/fake_dependencies.dart';
import '../../core/golden_harness.dart' show AndroidNonlinear200;

DateTime _now() => DateTime(2026, 11, 20, 9);

/// Two accruals with rules, one of them with a code the screen does not
/// know.
class _Calculator implements EntitlementCalculator {
  @override
  List<EntitlementPeriod> periods(
    Profile profile, {
    required DateTime until,
  }) => [
    EntitlementPeriod(
      accrualDate: DateTime.utc(2025, 3, 15),
      days: 14,
      rules: [
        EntitlementRule.laborSeniorityUpToFive.apply({
          'serviceYears': '6',
          'days': '14',
        }),
      ],
    ),
    EntitlementPeriod(
      accrualDate: DateTime.utc(2026, 3, 15),
      days: 20,
      rules: [
        EntitlementRule.laborSeniorityFiveToFifteen.apply({
          'serviceYears': '7',
          'days': '20',
        }),
        EntitlementRule.laborPriorService.apply({
          'years': '1',
          'months': '2',
          'days': '3',
          'serviceStart': '2018-01-12',
        }),
        const AppliedRule(code: 'futureRule', legalReference: '4857 md. 99'),
      ],
    ),
  ];

  @override
  NextAccrual? nextAccrual(Profile profile, DateTime today) =>
      NextAccrual(date: DateTime.utc(2027, 3, 15), days: 20);
}

void main() {
  Future<void> pump(
    WidgetTester tester, {
    List<Override> overrides = const [],
    EntitlementCalculator? calculator,
    TextScaler textScaler = TextScaler.noScaling,
    double width = 360,
    bool dark = false,
  }) async {
    tester.view
      // Tall enough that the whole list is laid out, so overflow anywhere
      // in it is reported.
      ..physicalSize = Size(width, 12000)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: withFakeDependencies([
          explainViewModelProvider.overrideWith(
            () => ExplainViewModel(clock: _now),
          ),
          entitlementCalculatorProvider.overrideWithValue(
            calculator ?? _Calculator(),
          ),
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
          home: const ExplainScreen(),
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

  testWidgets('shows every accrual with its rule and article', (tester) async {
    await pump(tester);
    expect(find.text('Nasıl hesaplandı?'), findsOneWidget);
    expect(find.text('Hesabın özeti'), findsOneWidget);
    // 14 + 20 earned, 5 used, 4 planned.
    expect(find.text('34 gün'), findsOneWidget);
    expect(find.text('25 gün'), findsOneWidget);
    expect(
      find.text('15 Mart 2027, Pazartesi günü 20 gün eklenecek.'),
      findsOneWidget,
    );
    expect(find.text('Hak edişlerin'), findsOneWidget);
    expect(find.text('15 Mart 2026, Pazar'), findsOneWidget);
    expect(find.text('20 gün hak ettin'), findsOneWidget);
    expect(
      find.text(
        'Bu iş yerinde 7 yılını doldurdun. Kıdemi 5 yıldan fazla, '
        '15 yıldan az olanın izni 20 gündür.',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'Aynı işverendeki önceki 1 yıl 2 ay 3 gün çalışman eklendi. Bu yüzden '
        '12 Ocak 2018, Cuma günü başlamış sayılırsın.',
      ),
      findsOneWidget,
    );
    expect(find.text('4857 md. 53/4'), findsNWidgets(2));
    // An unknown code still says which article applied.
    expect(find.text('4857 md. 99 uygulandı.'), findsOneWidget);
    expect(find.text('Bilmen gerekenler'), findsOneWidget);
    expect(
      find.text(
        'Devamsızlık girmediğin için hesap, ara vermeden çalıştığın '
        'varsayımıyla yapıldı.',
      ),
      findsOneWidget,
    );
    expect(
      find.text('Arife ve 28 Ekim sabahı izninden yarım gün düşer.'),
      findsOneWidget,
    );
    expect(
      find.text(
        'Çalışmadığın cumartesiler izninden düşer. Yargıtayın güncel görüşü '
        'budur.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('says how to start when there is no profile', (tester) async {
    await pump(tester, overrides: await noProfile());
    expect(find.byType(EmptyState), findsOneWidget);
    expect(
      find.text('Hesabı görmek için önce kurulumu tamamla.'),
      findsOneWidget,
    );
  });

  testWidgets('explains why a teacher has no annual leave', (tester) async {
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
    expect(
      find.text(
        'Öğretmenler yaz ve dinlenme tatillerinde izinli sayılır. Bu yüzden '
        'ayrıca yıllık izin verilmez.',
      ),
      findsOneWidget,
    );
    expect(find.text('Hak edişlerin'), findsNothing);
  });

  testWidgets('says when no right is earned yet', (tester) async {
    await pump(tester, calculator: _NoPeriodsCalculator());
    expect(find.text('Henüz izin hakkın doğmadı.'), findsOneWidget);
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
        expect(find.text('Bilmen gerekenler'), findsOneWidget);
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
}

/// A worker in the first year: no accrual yet.
class _NoPeriodsCalculator implements EntitlementCalculator {
  @override
  List<EntitlementPeriod> periods(Profile profile, {required DateTime until}) =>
      const [];

  @override
  NextAccrual? nextAccrual(Profile profile, DateTime today) =>
      NextAccrual(date: DateTime.utc(2027, 3, 15), days: 14);
}
