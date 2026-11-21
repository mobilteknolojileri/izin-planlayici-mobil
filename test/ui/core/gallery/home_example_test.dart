import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/core/gallery/home_example_screen.dart';
import 'package:izin_planla/ui/core/widgets/app_tab_bar.dart';
import 'package:izin_planla/ui/core/widgets/legend_row.dart';
import 'package:material_ui/material_ui.dart';

import '../golden_harness.dart' show AndroidNonlinear200;

/// The whole home example, built from task 06 components, at every text
/// size and phone width the app supports. Catches what single component
/// tests miss: components side by side, the tab bar over the content.
void main() {
  Future<void> pumpScreen(
    WidgetTester tester, {
    required bool dark,
    TextScaler textScaler = TextScaler.noScaling,
    double width = 360,
  }) async {
    // Tall enough that the whole list is laid out, so overflow anywhere in
    // it is reported.
    tester.view
      ..physicalSize = Size(width, 2800)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
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
        home: HomeExampleScreen(dark: dark),
      ),
    );
    await tester.pumpAndSettle();
  }

  final scalers = <String, TextScaler>{
    'x1': TextScaler.noScaling,
    'x1.3': const TextScaler.linear(1.3),
    'x2 linear': const TextScaler.linear(2),
    'x2 android': const AndroidNonlinear200(),
  };

  for (final dark in [false, true]) {
    final theme = dark ? 'dark' : 'light';
    for (final MapEntry(key: size, value: scaler) in scalers.entries) {
      for (final width in [320.0, 360.0]) {
        testWidgets('$theme, text $size, ${width.toInt()} wide: nothing '
            'overflows and no word is split', (tester) async {
          await pumpScreen(
            tester,
            dark: dark,
            textScaler: scaler,
            width: width,
          );
          expect(tester.takeException(), isNull);
          expect(find.text('İzin durumun'), findsOneWidget);
          for (final word in [
            'Pzt',
            'Sal',
            'Çar',
            'Per',
            'Cum',
            'Cmt',
            'Ana sayfa',
            'İzinlerim',
            'Ayarlar',
          ]) {
            _expectSingleLine(find.text(word));
          }
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

  testWidgets('the list ends above the glass tab bar', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 780)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('tr'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        home: HomeExampleScreen(dark: false),
      ),
    );
    await tester.pumpAndSettle();
    final position = tester
        .state<ScrollableState>(
          find.descendant(
            of: find.byType(ListView),
            matching: find.byType(Scrollable),
          ),
        )
        .position;
    // A lazy list learns its real end only after building the last
    // children, so jump until the end stops moving.
    do {
      position.jumpTo(position.maxScrollExtent);
      await tester.pumpAndSettle();
    } while (position.pixels < position.maxScrollExtent);
    expect(
      tester.getRect(find.byType(LegendRow)).bottom,
      lessThanOrEqualTo(tester.getRect(find.byType(AppTabBar)).top),
    );
  });

  testWidgets('screen reader labels and roles', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpScreen(tester, dark: false);
    expect(
      find.bySemanticsLabel('12 Mart 2027, Cuma, Önerilen izin'),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel('Kalan 18 gün, kullanılan 14 gün, planlanan 4 gün'),
      findsOneWidget,
    );
    for (final label in ['Nasıl hesaplandı?', 'İzin ekle']) {
      expect(
        tester.getSemantics(find.text(label)),
        isSemantics(label: label, isButton: true),
      );
    }
    semantics.dispose();
  });
}

/// Fails when a text found by [finder] wraps to a second line.
void _expectSingleLine(Finder finder) {
  for (final element in finder.evaluate()) {
    final paragraph = element.renderObject! as RenderParagraph;
    final oneLine = TextPainter(
      text: paragraph.text,
      textDirection: TextDirection.ltr,
      textScaler: paragraph.textScaler,
    )..layout();
    expect(
      paragraph.size.height,
      lessThanOrEqualTo(oneLine.height + 0.5),
      reason: '"${paragraph.text.toPlainText()}" wraps',
    );
    oneLine.dispose();
  }
}
