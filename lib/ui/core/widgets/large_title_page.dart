import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:material_ui/material_ui.dart';

/// A tab screen in the iOS style: an optional small line, a large title and
/// the content in one scrolling list on the grouped background.
///
/// Content scrolls under the status bar behind a soft fade, and the list
/// ends above the glass tab bar of `AppShell`, because it reads the bottom
/// padding inside the shell's scaffold. Screens pushed on top of the tabs
/// use a regular `AppBar` with a back button instead.
class LargeTitlePage extends StatelessWidget {
  /// Creates the page.
  const new({
    required this.title,
    required this.children,
    this.overline,
    this.trailing,
    this.horizontalPadding = AppSpacing.md,
    super.key,
  });

  /// The large title, a screen reader heading.
  final String title;

  /// Optional small line above the title, such as today's date.
  final String? overline;

  /// Optional widget at the end of the title row, such as an icon button.
  final Widget? trailing;

  /// The content, in order.
  final List<Widget> children;

  /// Space on the left and right of the content. The calendar uses less, so
  /// its seven day columns stay at least 48 dp wide on a 360 dp phone.
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final surface = theme.colorScheme.surface;
    final overline = this.overline;
    final trailing = this.trailing;
    return Scaffold(
      body: Builder(
        builder: (context) {
          final padding = MediaQuery.paddingOf(context);
          return Stack(
            children: [
              ListView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  padding.top + AppSpacing.sm,
                  horizontalPadding,
                  padding.bottom + AppSpacing.lg,
                ),
                children: [
                  if (overline != null)
                    Text(
                      overline,
                      style: text.titleSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          header: true,
                          child: Text(title, style: text.headlineLarge),
                        ),
                      ),
                      ?trailing,
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ...children,
                ],
              ),
              // Content scrolls under the status bar, the fade keeps the
              // status bar icons readable.
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: padding.top + AppSpacing.md,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.6, 1],
                        colors: [surface, surface.withValues(alpha: 0)],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
