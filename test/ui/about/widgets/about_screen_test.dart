import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:izin_planla/config/dependencies.dart';
import 'package:izin_planla/data/services/links/link_opener.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/about/view_models/about_link.dart';
import 'package:izin_planla/ui/about/view_models/about_view_model.dart';
import 'package:izin_planla/ui/about/widgets/about_screen.dart';
import 'package:izin_planla/ui/core/theme/app_theme.dart';
import 'package:material_ui/material_ui.dart';

import '../../../config/fake_dependencies.dart';
import '../../core/golden_harness.dart' show AndroidNonlinear200;

void main() {
  Future<void> pumpScreen(
    WidgetTester tester, {
    bool dark = false,
    TextScaler textScaler = TextScaler.noScaling,
    double width = 360,
    LinkOpener? linkOpener,
  }) async {
    tester.view
      ..physicalSize = Size(width, 6000)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const AboutScreen()),
        GoRoute(
          path: '/guide',
          builder: (_, _) => const Scaffold(body: Text('guide')),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: withFakeDependencies([
          if (linkOpener != null)
            linkOpenerProvider.overrideWithValue(linkOpener),
          aboutVersionProvider.overrideWithValue('1.2.3'),
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
  }

  testWidgets('shows version, privacy, sources, licence and disclaimer', (
    tester,
  ) async {
    await pumpScreen(tester);
    expect(find.text('Hakkında'), findsOneWidget);
    expect(find.text('Sürüm 1.2.3'), findsOneWidget);
    expect(find.text('Gizlilik'), findsOneWidget);
    expect(find.text('4857 sayılı İş Kanunu'), findsOneWidget);
    expect(find.textContaining('GPL-3.0 lisansıyla'), findsOneWidget);
    expect(find.text('Kaynak kodu (GitHub)'), findsOneWidget);
    expect(find.text('Yasal uyarı'), findsOneWidget);
    expect(find.textContaining('hukuki tavsiye değildir'), findsOneWidget);
  });

  testWidgets('package licences open the licence page', (tester) async {
    await pumpScreen(tester);
    await tester.tap(find.text('Kullanılan paketlerin lisansları'));
    await tester.pumpAndSettle();
    expect(find.byType(LicensePage), findsOneWidget);
  });

  testWidgets('the guide button opens the guide', (tester) async {
    await pumpScreen(tester);
    await tester.tap(find.text('Mevzuat rehberini aç'));
    await tester.pumpAndSettle();
    expect(find.text('guide'), findsOneWidget);
  });

  testWidgets('the source code link opens in the browser', (tester) async {
    final opener = RecordingLinkOpener();
    await pumpScreen(tester, linkOpener: opener);
    await tester.tap(find.byTooltip('Kaynak kodu (GitHub) bağlantısını aç'));
    await tester.pumpAndSettle();
    expect(opener.opened, [AboutLink.sourceCode.url]);
  });

  testWidgets('without a browser the source code link is copied', (
    tester,
  ) async {
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
    await tester.tap(find.byTooltip('Kaynak kodu (GitHub) bağlantısını aç'));
    await tester.pumpAndSettle();
    expect(copied, [AboutLink.sourceCode.url]);
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
        testWidgets('$theme, text $size, ${width.toInt()} wide: nothing '
            'overflows', (tester) async {
          await pumpScreen(
            tester,
            dark: dark,
            textScaler: scaler,
            width: width,
          );
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
