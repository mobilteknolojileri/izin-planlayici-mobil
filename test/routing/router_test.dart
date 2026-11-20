import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/app.dart';
import 'package:izin_planla/routing/router.dart';
import 'package:izin_planla/routing/routes.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  Future<ProviderContainer> pumpApp(WidgetTester tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const App()),
    );
    await tester.pumpAndSettle();
    return container;
  }

  Finder appBarTitle(String text) =>
      find.descendant(of: find.byType(AppBar), matching: find.text(text));

  testWidgets('every tab opens its screen', (tester) async {
    await pumpApp(tester);
    expect(appBarTitle('Ana Sayfa'), findsOneWidget);

    const tabs = {
      'İzinlerim': 'İzinlerim',
      'Takvim': 'Takvim',
      'Köprü': 'Köprü',
      'Ayarlar': 'Ayarlar',
      'Ana Sayfa': 'Ana Sayfa',
    };
    for (final MapEntry(key: label, value: title) in tabs.entries) {
      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text(label),
        ),
      );
      await tester.pumpAndSettle();
      expect(appBarTitle(title), findsOneWidget, reason: 'tab $label');
    }
  });

  testWidgets('every pushed route opens its screen', (tester) async {
    final container = await pumpApp(tester);
    const pushed = {
      Routes.onboarding: 'Kurulum',
      Routes.leaveForm: 'İzin Ekle',
      Routes.explain: 'Nasıl Hesaplandı?',
      Routes.people: 'Kişiler',
      Routes.stats: 'İstatistik',
      Routes.guide: 'Mevzuat Rehberi',
      Routes.about: 'Hakkında',
    };
    for (final MapEntry(key: path, value: title) in pushed.entries) {
      container.read(routerProvider).go(path);
      await tester.pumpAndSettle();
      expect(appBarTitle(title), findsOneWidget, reason: path);
    }
  });
}
