import 'dart:async';

import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/core/app_format.dart';
import 'package:izin_planla/ui/core/theme/app_radius.dart';
import 'package:izin_planla/ui/people/widgets/labeled_field.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

/// A form field that shows a date as "20 Kasım 2026, Cuma" and opens the
/// date picker on tap. Dates outside [firstDate] and [lastDate] cannot be
/// picked, so a wrong date is prevented instead of reported.
///
/// Shared by the setup, people, leave and overtime forms. A candidate for
/// `lib/ui/core/widgets/`.
class DateField extends StatelessWidget {
  /// Creates the field.
  const new({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    this.errorText,
    super.key,
  });

  /// Field label, such as "İşe başlama tarihi".
  final String label;

  /// The chosen date (UTC midnight), null before a choice.
  final DateTime? value;

  /// Called with the picked date as UTC midnight.
  final ValueChanged<DateTime> onChanged;

  /// Earliest date the picker allows.
  final DateTime firstDate;

  /// Latest date the picker allows.
  final DateTime lastDate;

  /// Error under the field, null when there is none.
  final String? errorText;

  Future<void> _pick(BuildContext context) async {
    final first = DateUtils.dateOnly(firstDate.toLocalDate());
    final last = DateUtils.dateOnly(lastDate.toLocalDate());
    final current = value;
    // An empty field opens on today, kept inside the allowed range.
    var initial = current == null
        ? DateUtils.dateOnly(DateTime.now())
        : current.toLocalDate();
    if (initial.isBefore(first)) initial = first;
    if (initial.isAfter(last)) initial = last;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
      helpText: label,
    );
    if (picked != null) {
      onChanged(DateTime.utc(picked.year, picked.month, picked.day));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final theme = Theme.of(context);
    final value = this.value;
    final style = theme.textTheme.bodyLarge;
    return LabeledField(
      label: label,
      child: Semantics(
        button: true,
        child: InkWell(
          onTap: () => unawaited(_pick(context)),
          borderRadius: AppRadius.medium,
          child: InputDecorator(
            decoration: InputDecoration(
              errorText: errorText,
              errorMaxLines: 3,
              suffixIcon: const Icon(LucideIcons.calendarDays),
            ),
            child: Text(
              value == null
                  ? l10n.peopleDatePlaceholder
                  : AppFormat.longDate(value, locale),
              style: value == null
                  ? style?.copyWith(color: theme.colorScheme.onSurfaceVariant)
                  : style,
            ),
          ),
        ),
      ),
    );
  }
}

extension on DateTime {
  /// The same calendar day in local time, as the date picker expects.
  DateTime toLocalDate() => DateTime(year, month, day);
}
