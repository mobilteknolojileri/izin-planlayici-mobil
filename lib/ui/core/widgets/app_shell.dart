import 'package:go_router/go_router.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/core/widgets/app_tab_bar.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

/// Scaffold with the glass tab bar around the five tab screens. Content
/// scrolls behind the bar, every tab screen keeps the bar height free at the
/// end of its list through the bottom padding of `MediaQuery`.
class AppShell extends StatelessWidget {
  /// Creates the shell for [navigationShell].
  const new({required this.navigationShell, super.key});

  /// Current tab branch, provided by the router.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: AppTabBar(
        selectedIndex: navigationShell.currentIndex,
        onSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: [
          AppTabDestination(icon: LucideIcons.house, label: l10n.navHome),
          AppTabDestination(
            icon: LucideIcons.listChecks,
            label: l10n.navLeaves,
          ),
          AppTabDestination(
            icon: LucideIcons.calendarDays,
            label: l10n.navCalendar,
          ),
          AppTabDestination(icon: LucideIcons.treePalm, label: l10n.navBridge),
          AppTabDestination(
            icon: LucideIcons.settings,
            label: l10n.navSettings,
          ),
        ],
      ),
    );
  }
}
