import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/config/dependencies.dart';
import 'package:izin_planla/data/fakes/fake_profile_repository.dart';
import 'package:izin_planla/data/fakes/fake_settings_repository.dart';
import 'package:izin_planla/data/fakes/sample_data.dart';
import 'package:izin_planla/data/services/links/link_opener.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/core/theme/app_theme.dart';
import 'package:izin_planla/ui/core/widgets/week_strip.dart';
import 'package:izin_planla/ui/guide/view_models/guide_source.dart';
import 'package:izin_planla/ui/guide/widgets/guide_screen.dart';
import 'package:material_ui/material_ui.dart';

import '../../../config/fake_dependencies.dart';
import '../../core/golden_harness.dart' show AndroidNonlinear200;

void main() {
  Future<void> pumpScreen(
    WidgetTester tester, {
    bool noProfile = false,
    bool civilServant = false,
    bool dark = false,
    TextScaler textScaler = TextScaler.noScaling,
    double width = 360,
    LinkOpener? linkOpener,
  }) async {
    tester.view
      ..physicalSize = Size(width, 9000)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final profiles = FakeProfileRepository();
    final settings = FakeSettingsRepository();
    if (noProfile) {
      await profiles.delete(SampleData.profileId);
      await settings.save(const AppSettings());
    }
    if (civilServant) {
      await profiles.save(
        SampleData.profile.copyWith(
          employmentType: EmploymentType.civilServant,
        ),
      );
    }
    await tester.pumpWidget(
      ProviderScope(
        overrides: withFakeDependencies([
          if (linkOpener != null)
            linkOpenerProvider.overrideWithValue(linkOpener),
          profileRepositoryProvider.overrideWithValue(profiles),
          settingsRepositoryProvider.overrideWithValue(settings),
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
          home: const GuideScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('labour law rules with sources, example and disclaimer', (
    tester,
  ) async {
    await pumpScreen(tester);
    expect(find.text('Mevzuat rehberi'), findsOneWidget);
    expect(find.text('İzin hakkın ne zaman başlar?'), findsOneWidget);
    expect(
      find.text('Kaynak: 4857 sayılı İş Kanunu, madde 53 ve 54'),
      findsOneWidget,
    );
    expect(find.text('15 yıl ve fazlası'), findsOneWidget);
    expect(find.text('26 gün'), findsOneWidget);
    expect(find.byType(WeekStrip), findsOneWidget);
    expect(
      find.bySemanticsLabel('29 Ekim 2026, Perşembe, Resmî tatil'),
      findsOneWidget,
    );
    expect(find.text('Yasal uyarı'), findsOneWidget);
    expect(find.textContaining('hukuki tavsiye değildir'), findsOneWidget);
    // The disclaimer is the last card.
    expect(
      tester.getTopLeft(find.text('Yasal uyarı')).dy,
      greaterThan(tester.getTopLeft(find.text('Kaynaklar')).dy),
    );
  });

  testWidgets('the law chips switch to the civil servants law', (tester) async {
    await pumpScreen(tester);
    await tester.tap(find.text('Memur (657)'));
    await tester.pumpAndSettle();
    expect(find.text('10 yıldan fazla'), findsOneWidget);
    expect(find.text('30 gün'), findsOneWidget);
    expect(find.text('15 yıl ve fazlası'), findsNothing);
  });

  testWidgets('a civil servant sees the civil servants law first', (
    tester,
  ) async {
    await pumpScreen(tester, civilServant: true);
    expect(
      find.text('Kaynak: 657 sayılı Devlet Memurları Kanunu, madde 104'),
      findsOneWidget,
    );
  });

  testWidgets('empty: without a person the labour law is shown', (
    tester,
  ) async {
    await pumpScreen(tester, noProfile: true);
    expect(find.text('15 yıl ve fazlası'), findsOneWidget);
  });

  testWidgets('the link button opens the source', (tester) async {
    final opener = RecordingLinkOpener();
    await pumpScreen(tester, linkOpener: opener);
    await tester.tap(
      find.byTooltip('4857 sayılı İş Kanunu bağlantısını aç').first,
    );
    await tester.pumpAndSettle();
    expect(opener.opened, [GuideSource.labor.url]);
  });

  testWidgets('without a browser the source link is copied', (tester) async {
    final copied = <String>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied.add((call.arguments as Map)['text'] as String);
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await pumpScreen(tester, linkOpener: RecordingLinkOpener(opens: false));
    await tester.tap(
      find.byTooltip('4857 sayılı İş Kanunu bağlantısını aç').first,
    );
    await tester.pumpAndSettle();
    expect(copied, [GuideSource.labor.url]);
    expect(
      find.text('Tarayıcı açılamadı. Bağlantı kopyalandı.'),
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
        for (final civil in [false, true]) {
          testWidgets('$theme, text $size, ${width.toInt()} wide, '
              '${civil ? 'civil servant' : 'labour law'}: nothing overflows', (
            tester,
          ) async {
            await pumpScreen(
              tester,
              dark: dark,
              textScaler: scaler,
              width: width,
              civilServant: civil,
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
