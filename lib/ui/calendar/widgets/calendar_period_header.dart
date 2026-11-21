import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

/// The month or year on screen between a previous and a next button.
///
/// The title is a live region, so screen readers announce the new month
/// after a button press.
class CalendarPeriodHeader extends StatelessWidget {
  /// Creates the header. A null callback disables its button.
  const new({
    required this.title,
    required this.previousLabel,
    required this.nextLabel,
    required this.onPrevious,
    required this.onNext,
    super.key,
  });

  /// Month and year, or the year.
  final String title;

  /// Tooltip of the previous button.
  final String previousLabel;

  /// Tooltip of the next button.
  final String nextLabel;

  /// Called by the previous button.
  final VoidCallback? onPrevious;

  /// Called by the next button.
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onPrevious,
            tooltip: previousLabel,
            color: color,
            icon: const Icon(LucideIcons.chevronLeft),
          ),
          Expanded(
            child: Semantics(
              header: true,
              liveRegion: true,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: text.titleMedium,
              ),
            ),
          ),
          IconButton(
            onPressed: onNext,
            tooltip: nextLabel,
            color: color,
            icon: const Icon(LucideIcons.chevronRight),
          ),
        ],
      ),
    );
  }
}
