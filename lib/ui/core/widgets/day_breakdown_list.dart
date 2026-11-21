import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/core/app_format.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/core/theme/meaning.dart';
import 'package:izin_planla/ui/core/widgets/meaning_tile.dart';
import 'package:material_ui/material_ui.dart';

/// Every day of a leave range with the reason it counts or not, so the user
/// sees where the total comes from.
///
/// Not scrollable, place it inside the screen's scroll view.
class DayBreakdownList extends StatelessWidget {
  /// Creates the list from the day count result.
  const new({required this.days, super.key});

  /// Days in calendar order, from `DayCount.days`.
  final List<DayBreakdown> days;

  /// The mark shown for [day].
  static Meaning meaningOf(DayBreakdown day) => switch (day.reason) {
    DayReason.workday => Meaning.workday,
    DayReason.weeklyRest ||
    DayReason.contractualRest ||
    DayReason.weekendInsideLeave => Meaning.weekend,
    DayReason.holiday || DayReason.administrativeLeave => Meaning.holiday,
    DayReason.halfDayHoliday => Meaning.eve,
    DayReason.trimmedEdge =>
      day.holidayName == null ? Meaning.weekend : Meaning.holiday,
  };

  /// Why [day] counts or not, in plain words.
  static String reasonOf(AppLocalizations l10n, DayBreakdown day) {
    final name = day.holidayName;
    return switch (day.reason) {
      DayReason.workday => l10n.coreDayReasonWorkday,
      DayReason.weeklyRest => l10n.coreDayReasonWeeklyRest,
      DayReason.holiday when name != null => l10n.coreDayReasonHolidayNamed(
        name,
      ),
      DayReason.holiday => l10n.coreDayReasonHoliday,
      DayReason.contractualRest => l10n.coreDayReasonContractualRest,
      DayReason.halfDayHoliday when name != null =>
        l10n.coreDayReasonHalfDayNamed(name),
      DayReason.halfDayHoliday => l10n.coreDayReasonHalfDay,
      DayReason.administrativeLeave => l10n.coreDayReasonAdministrativeLeave,
      DayReason.weekendInsideLeave => l10n.coreDayReasonWeekendInsideLeave,
      DayReason.trimmedEdge => l10n.coreDayReasonTrimmedEdge,
    };
  }

  /// Days deducted for one day: "1 gün", "Yarım gün" or "Sayılmaz".
  static String valueOf(AppLocalizations l10n, double value) {
    if (value == 0) return l10n.coreDayNotCounted;
    if (value == 0.5) return l10n.coreDayHalfCounted;
    return l10n.coreDayCounted(value);
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (final (index, day) in days.indexed) ...[
        if (index > 0) const Divider(),
        _DayRow(day: day),
      ],
    ],
  );
}

class _DayRow extends StatelessWidget {
  const new({required this.day});

  final DayBreakdown day;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final date = AppFormat.longDate(day.date, locale);
    final reason = DayBreakdownList.reasonOf(l10n, day);
    final value = DayBreakdownList.valueOf(l10n, day.value);
    final counted = day.value > 0;
    final valueText = Text(
      value,
      style: counted
          ? text.titleSmall
          : text.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
    );
    // With large system text the value moves under the reason, so the date
    // and reason keep enough width.
    final stacked = MediaQuery.textScalerOf(context).scale(1) > 1.5;
    return Semantics(
      label: l10n.coreDayBreakdownSemantics(date, reason, value),
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            MeaningTile(meaning: DayBreakdownList.meaningOf(day)),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(date, style: text.bodyLarge),
                  Text(
                    reason,
                    style: text.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (stacked) valueText,
                ],
              ),
            ),
            if (!stacked) ...[const SizedBox(width: AppSpacing.sm), valueText],
          ],
        ),
      ),
    );
  }
}
