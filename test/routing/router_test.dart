import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/app.dart';
import 'package:izin_planla/routing/router.dart';
import 'package:izin_planla/routing/routes.dart';
import 'package:izin_planla/routing/start_route.dart';
import 'package:izin_planla/ui/about/widgets/about_screen.dart';
import 'package:izin_planla/ui/bridge/widgets/bridge_screen.dart';
import 'package:izin_planla/ui/calendar/widgets/calendar_screen.dart';
import 'package:izin_planla/ui/core/widgets/app_tab_bar.dart';
import 'package:izin_planla/ui/explain/widgets/explain_screen.dart';
import 'package:izin_planla/ui/guide/widgets/guide_screen.dart';
import 'package:izin_planla/ui/home/widgets/home_screen.dart';
import 'package:izin_planla/ui/leave_form/widgets/leave_form_screen.dart';
import 'package:izin_planla/ui/leaves/widgets/leaves_screen.dart';
import 'package:izin_planla/ui/onboarding/widgets/onboarding_screen.dart';
import 'package:izin_planla/ui/people/widgets/people_screen.dart';
import 'package:izin_planla/ui/settings/widgets/settings_screen.dart';
import 'package:izin_planla/ui/stats/widgets/stats_screen.dart';

import '../config/fake_dependencies.dart';

void main() {
  Future<ProviderContainer> pumpApp(WidgetTester tester) async {
    final container = ProviderContainer(overrides: withFakeDependencies());
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const App()),
    );
    await tester.pumpAndSettle();
    return container;
  }

  // Screens are matched by type: tab screens show a large title instead of
  // an app bar, and their texts depend on the data.
  testWidgets('every tab opens its screen', (tester) async {
    await pumpApp(tester);
    expect(find.byType(HomeScreen), findsOneWidget);

    const tabs = {
      'İzinlerim': LeavesScreen,
      'Takvim': CalendarScreen,
      'Köprü': BridgeScreen,
      'Ayarlar': SettingsScreen,
      'Ana sayfa': HomeScreen,
    };
    for (final MapEntry(key: label, value: screen) in tabs.entries) {
      // The glass tab bar draws each label twice, plain and in the lens.
      await tester.tap(
        find
            .descendant(of: find.byType(AppTabBar), matching: find.text(label))
            .first,
      );
      await tester.pumpAndSettle();
      expect(find.byType(screen), findsOneWidget, reason: 'tab $label');
    }
  });

  testWidgets('a first run opens the setup', (tester) async {
    final container = ProviderContainer(overrides: withFakeDependencies());
    addTearDown(container.dispose);
    container.read(startRouteProvider.notifier).route = Routes.onboarding;
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const App()),
    );
    await tester.pumpAndSettle();
    expect(find.byType(OnboardingScreen), findsOneWidget);
  });

  testWidgets('every pushed route opens its screen', (tester) async {
    final container = await pumpApp(tester);
    const pushed = {
      Routes.onboarding: OnboardingScreen,
      Routes.leaveForm: LeaveFormScreen,
      Routes.explain: ExplainScreen,
      Routes.people: PeopleScreen,
      Routes.stats: StatsScreen,
      Routes.guide: GuideScreen,
      Routes.about: AboutScreen,
    };
    for (final MapEntry(key: path, value: screen) in pushed.entries) {
      container.read(routerProvider).go(path);
      await tester.pumpAndSettle();
      expect(find.byType(screen), findsOneWidget, reason: path);
    }
  });
}
