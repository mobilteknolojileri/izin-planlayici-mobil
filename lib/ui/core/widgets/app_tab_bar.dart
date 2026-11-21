import 'package:izin_planla/ui/core/theme/app_colors.dart';
import 'package:izin_planla/ui/core/theme/app_radius.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:material_ui/material_ui.dart';

/// One tab of [AppTabBar].
@immutable
class AppTabDestination {
  /// Creates a tab.
  const new({required this.icon, required this.label});

  /// Tab icon, from Lucide.
  final IconData icon;

  /// Tab label, always shown.
  final String label;
}

/// The floating Liquid Glass tab bar at the bottom of the app.
///
/// Labels grow with the system text size up to 1.3 times, like Material's
/// `NavigationBar`, because five labels cannot fit a phone width at 200%.
/// A long press shows the full-size icon and label above the bar, like the
/// iOS Large Content Viewer. The glass tint keeps labels at 4.5:1 over any
/// content that scrolls behind the bar.
///
/// Place it in `Scaffold.bottomNavigationBar` with `extendBody: true`, so
/// content scrolls behind the glass.
class AppTabBar extends StatefulWidget {
  /// Creates the tab bar.
  const new({
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  /// The tabs, at most five.
  final List<AppTabDestination> destinations;

  /// Index of the current tab.
  final int selectedIndex;

  /// Called with the index of a tapped tab.
  final ValueChanged<int> onSelected;

  /// Largest label size, as a factor of the base size.
  static const maxLabelScale = 1.3;

  @override
  State<AppTabBar> createState() => _AppTabBarState();
}

class _AppTabBarState extends State<AppTabBar> {
  /// Outer margin of `GlassTabBar.bottom`.
  static const _barMargin = 20.0;

  final _viewer = OverlayPortalController();
  int _pressed = 0;

  void _press(Offset position, double width) {
    final count = widget.destinations.length;
    final tabWidth = (width - _barMargin * 2) / count;
    final index = ((position.dx - _barMargin) / tabWidth).floor();
    setState(() => _pressed = index.clamp(0, count - 1));
    _viewer.show();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context).tabBar;
    final destinations = widget.destinations;
    return SafeArea(
      top: false,
      child: LayoutBuilder(
        builder: (context, constraints) => OverlayPortal(
          controller: _viewer,
          overlayChildBuilder: (_) =>
              _LargeContentViewer(destination: destinations[_pressed]),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            // Visual aid only, screen readers already read every tab label.
            excludeFromSemantics: true,
            onLongPressStart: (details) =>
                _press(details.localPosition, constraints.maxWidth),
            onLongPressMoveUpdate: (details) =>
                _press(details.localPosition, constraints.maxWidth),
            onLongPressEnd: (_) => _viewer.hide(),
            onLongPressCancel: _viewer.hide,
            child: MediaQuery.withClampedTextScaling(
              maxScaleFactor: AppTabBar.maxLabelScale,
              child: GlassTabBar.bottom(
                selectedIndex: widget.selectedIndex,
                onTabSelected: widget.onSelected,
                settings: LiquidGlassSettings(glassColor: colors.glass),
                selectedIconColor: colors.selected,
                selectedLabelColor: colors.selected,
                unselectedIconColor: colors.unselected,
                unselectedLabelColor: colors.unselected,
                labelFontSize: 12,
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
                tabs: [
                  for (final destination in destinations)
                    GlassTab(
                      icon: Icon(destination.icon),
                      label: destination.label,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Full-size icon and label of the pressed tab, shown above the tab bar.
class _LargeContentViewer extends StatelessWidget {
  const new({required this.destination});

  final AppTabDestination destination;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return ExcludeSemantics(
      child: Align(
        alignment: const Alignment(0, 0.35),
        child: IgnorePointer(
          child: Container(
            constraints: const BoxConstraints(minWidth: 180, maxWidth: 300),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: ShapeDecoration(
              color: theme.cardColor,
              shadows: [
                BoxShadow(
                  color: scheme.shadow.withValues(alpha: 0.25),
                  blurRadius: 32,
                  offset: const Offset(0, 8),
                ),
              ],
              shape: AppShapes.card,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(destination.icon, size: 56, color: scheme.onSurface),
                const SizedBox(height: AppSpacing.smd),
                Text(
                  destination.label,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
