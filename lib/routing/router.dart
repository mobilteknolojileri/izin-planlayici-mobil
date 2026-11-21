import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:izin_planla/routing/routes.dart';
import 'package:izin_planla/routing/start_route.dart';
import 'package:izin_planla/ui/about/widgets/about_screen.dart';
import 'package:izin_planla/ui/bridge/widgets/bridge_screen.dart';
import 'package:izin_planla/ui/calendar/widgets/calendar_screen.dart';
import 'package:izin_planla/ui/core/gallery/gallery_screen.dart';
import 'package:izin_planla/ui/core/widgets/app_shell.dart';
import 'package:izin_planla/ui/explain/widgets/explain_screen.dart';
import 'package:izin_planla/ui/guide/widgets/guide_screen.dart';
import 'package:izin_planla/ui/home/widgets/home_screen.dart';
import 'package:izin_planla/ui/leave_form/widgets/leave_form_screen.dart';
import 'package:izin_planla/ui/leaves/widgets/leaves_screen.dart';
import 'package:izin_planla/ui/onboarding/widgets/onboarding_screen.dart';
import 'package:izin_planla/ui/people/widgets/people_screen.dart';
import 'package:izin_planla/ui/settings/widgets/settings_screen.dart';
import 'package:izin_planla/ui/stats/widgets/stats_screen.dart';

/// Start route for debug runs, e.g. `--dart-define=START_ROUTE=/gallery`.
const _debugStartRoute = String.fromEnvironment('START_ROUTE');

/// The app router. A provider so tests can read and override it.
final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: kDebugMode && _debugStartRoute.isNotEmpty
        ? _debugStartRoute
        : ref.read(startRouteProvider),
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (_, _, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: Routes.home, builder: (_, _) => const HomeScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.leaves,
                builder: (_, _) => const LeavesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.calendar,
                builder: (_, _) => const CalendarScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.bridge,
                builder: (_, _) => const BridgeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.settings,
                builder: (_, _) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: Routes.onboarding,
        builder: (_, _) => const OnboardingScreen(),
      ),
      GoRoute(
        path: Routes.leaveForm,
        builder: (_, _) => const LeaveFormScreen(),
      ),
      GoRoute(path: Routes.explain, builder: (_, _) => const ExplainScreen()),
      GoRoute(path: Routes.people, builder: (_, _) => const PeopleScreen()),
      GoRoute(path: Routes.stats, builder: (_, _) => const StatsScreen()),
      GoRoute(path: Routes.guide, builder: (_, _) => const GuideScreen()),
      GoRoute(path: Routes.about, builder: (_, _) => const AboutScreen()),
      if (kDebugMode)
        GoRoute(path: Routes.gallery, builder: (_, _) => const GalleryScreen()),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
