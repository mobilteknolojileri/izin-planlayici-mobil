import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/calendar/view_models/calendar_data.dart';
import 'package:izin_planla/ui/calendar/view_models/calendar_state.dart';
import 'package:izin_planla/ui/calendar/widgets/calendar_day_item.dart';
import 'package:izin_planla/ui/calendar/widgets/calendar_day_text.dart';
import 'package:izin_planla/ui/core/app_format.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/core/theme/color_groups.dart';
import 'package:izin_planla/ui/core/widgets/inset_card.dart';
import 'package:izin_planla/ui/core/widgets/meaning_tile.dart';
import 'package:izin_planla/ui/core/widgets/primary_button.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

/// What the selected day holds, or the range picked for a new leave, with
/// the screen's one main button: add a leave for that day or range.
class CalendarDayDetails extends StatelessWidget {
  /// Creates the card.
  const new({
    required this.state,
    required this.data,
    required this.onAddLeave,
    super.key,
  });

  /// Screen state with the selection.
  final CalendarState state;

  /// Loaded calendar data.
  final CalendarData data;

  /// Called with the first and last day of the new leave.
  final void Function(DateTime start, DateTime end) onAddLeave;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final text = Theme.of(context).textTheme;
    if (state.rangeMode) {
      final start = state.rangeStart;
      final end = state.rangeEnd;
      final message = start == null
          ? l10n.calendarRangeHint
          : end == null
          ? l10n.calendarRangePickEnd
          : CalendarDayText.rangeSelected(l10n, locale, start, end);
      return InsetCard(
        header: CardHeader(
          tint: AppTint.blue,
          icon: LucideIcons.calendarRange,
          title: l10n.calendarRangeMode,
        ),
        summary: Semantics(
          liveRegion: true,
          child: Text(message, style: text.bodyLarge),
        ),
        child: start != null && end != null
            ? PrimaryButton(
                label: l10n.calendarAddLeaveRange,
                icon: LucideIcons.plus,
                onPressed: () => onAddLeave(start, end),
              )
            : null,
      );
    }
    final selected = state.selectedDay;
    if (selected == null) {
      return InsetCard(
        summary: Text(l10n.calendarPickDay, style: text.bodyLarge),
      );
    }
    final day = data.dayAt(selected, everyone: state.everyone);
    final items = CalendarDayText.items(l10n, locale, day);
    return InsetCard(
      header: CardHeader(
        tint: AppTint.blue,
        icon: LucideIcons.calendarDays,
        title: AppFormat.longDate(day.date, locale),
      ),
      summary: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (index, item) in items.indexed) ...[
            if (index > 0) const SizedBox(height: AppSpacing.sm),
            _ItemRow(item: item),
          ],
        ],
      ),
      child: PrimaryButton(
        label: l10n.calendarAddLeaveDay,
        icon: LucideIcons.plus,
        onPressed: () => onAddLeave(day.date, day.date),
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const new({required this.item});

  final CalendarDayItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitle = item.subtitle;
    return MergeSemantics(
      child: Row(
        children: [
          MeaningTile(meaning: item.meaning, width: 32, height: 32),
          const SizedBox(width: AppSpacing.smd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: theme.textTheme.bodyLarge),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
