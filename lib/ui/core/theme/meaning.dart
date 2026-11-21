import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/core/theme/meaning_pattern.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

/// What a coloured mark on a chart or calendar means.
///
/// Every meaning has its own colour (`AppColors.forMeaning`), icon, pattern
/// and label, so it stays readable without colour.
enum Meaning {
  /// Annual leave days still available.
  remaining(LucideIcons.calendarCheck, MeaningPattern.solid),

  /// Leave days already taken.
  used(LucideIcons.circleCheck, MeaningPattern.stripes),

  /// Leave days planned for the future.
  planned(LucideIcons.clock, MeaningPattern.dots),

  /// Full-day official holiday.
  holiday(LucideIcons.flag, MeaningPattern.crosshatch),

  /// Eve or 28 October, off from 13.00.
  eve(LucideIcons.contrast, MeaningPattern.half),

  /// Weekly rest day or non-working Saturday.
  weekend(LucideIcons.sofa, MeaningPattern.horizontalLines),

  /// Leave day suggested by the bridge planner.
  bridge(LucideIcons.bridge, MeaningPattern.verticalLines),

  /// Normal working day.
  workday(LucideIcons.briefcase, MeaningPattern.none);

  new(this.icon, this.pattern);

  /// Icon shown on every mark of this meaning.
  final IconData icon;

  /// Pattern drawn on every mark of this meaning.
  final MeaningPattern pattern;

  /// Short label for legends and screen readers.
  String label(AppLocalizations l10n) => switch (this) {
    remaining => l10n.coreMeaningRemaining,
    used => l10n.coreMeaningUsed,
    planned => l10n.coreMeaningPlanned,
    holiday => l10n.coreMeaningHoliday,
    eve => l10n.coreMeaningEve,
    weekend => l10n.coreMeaningWeekend,
    bridge => l10n.coreMeaningBridge,
    workday => l10n.coreMeaningWorkday,
  };
}
