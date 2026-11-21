import 'package:flutter/services.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/core/widgets/info_tip.dart';
import 'package:izin_planla/ui/people/view_models/profile_draft.dart';
import 'package:izin_planla/ui/people/widgets/labeled_field.dart';
import 'package:material_ui/material_ui.dart';

/// The optional, less common profile answers in a collapsed section:
/// prior service, leave used before the app, contract days, underground
/// work or teacher, and daily working hours.
///
/// Shared by the setup and the people form. Only the fields that apply to
/// the chosen employment type are shown.
class ProfileAdvancedFields extends StatelessWidget {
  /// Creates the section for [draft].
  const new({required this.draft, required this.onChanged, super.key});

  /// Current answers.
  final ProfileDraft draft;

  /// Called with the changed answers.
  final ValueChanged<ProfileDraft> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final labor = draft.isLabor;
    // Three narrow fields side by side do not fit large text.
    final stack = MediaQuery.textScalerOf(context).scale(10) > 13;
    final prior = [
      _NumberField(
        key: const ValueKey('priorYears'),
        label: l10n.peopleYears,
        value: draft.priorYears,
        whole: true,
        onChanged: (value) => onChanged(draft.copyWith(priorYears: value)),
      ),
      _NumberField(
        key: const ValueKey('priorMonths'),
        label: l10n.peopleMonths,
        value: draft.priorMonths,
        whole: true,
        onChanged: (value) => onChanged(draft.copyWith(priorMonths: value)),
      ),
      _NumberField(
        key: const ValueKey('priorDays'),
        label: l10n.peopleDays,
        value: draft.priorDays,
        whole: true,
        onChanged: (value) => onChanged(draft.copyWith(priorDays: value)),
      ),
    ];
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: Text(l10n.peopleAdvancedTitle),
        shape: const Border(),
        collapsedShape: const Border(),
        childrenPadding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.peoplePriorServiceLabel,
                  style: text.titleSmall,
                ),
              ),
              InfoTip(
                term: l10n.peoplePriorServiceLabel,
                message: labor
                    ? l10n.peoplePriorServiceInfoLabor
                    : l10n.peoplePriorServiceInfoCivil,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (stack)
            for (final field in prior) ...[
              field,
              const SizedBox(height: AppSpacing.smd),
            ]
          else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final (index, field) in prior.indexed) ...[
                  if (index > 0) const SizedBox(width: AppSpacing.sm),
                  Expanded(child: field),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.smd),
          ],
          _NumberField(
            key: const ValueKey('usedBefore'),
            label: l10n.peopleUsedBeforeLabel,
            helper: l10n.peopleUsedBeforeHelp,
            value: draft.usedBefore,
            onChanged: (value) => onChanged(draft.copyWith(usedBefore: value)),
          ),
          const SizedBox(height: AppSpacing.smd),
          if (labor) ...[
            _NumberField(
              key: const ValueKey('contractDays'),
              label: l10n.peopleContractLabel,
              value: draft.contractDays,
              whole: true,
              onChanged: (value) =>
                  onChanged(draft.copyWith(contractDays: value)),
            ),
            const SizedBox(height: AppSpacing.smd),
          ],
          _NumberField(
            key: const ValueKey('dailyHours'),
            label: l10n.peopleDailyHoursLabel,
            value: draft.dailyHours,
            hint: '8',
            onChanged: (value) => onChanged(draft.copyWith(dailyHours: value)),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (labor)
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.peopleUndergroundLabel),
              value: draft.isUnderground,
              onChanged: (value) =>
                  onChanged(draft.copyWith(isUnderground: value)),
            )
          else
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.peopleTeacherLabel),
              value: draft.isTeacher,
              onChanged: (value) => onChanged(draft.copyWith(isTeacher: value)),
            ),
        ],
      ),
    );
  }
}

/// A number field that keeps what the user typed and says when it is not
/// a number.
class _NumberField extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    required this.onChanged,
    this.whole = false,
    this.hint,
    this.helper,
    super.key,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final bool whole;
  final String? hint;
  final String? helper;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final valid = whole
        ? ProfileDraft.isWholeNumber(value)
        : ProfileDraft.isNumber(value);
    return LabeledField(
      label: label,
      child: TextFormField(
        initialValue: value,
        keyboardType: TextInputType.numberWithOptions(decimal: !whole),
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            whole ? RegExp('[0-9]') : RegExp('[0-9,]'),
          ),
        ],
        decoration: InputDecoration(
          hintText: hint,
          helperText: helper,
          helperMaxLines: 6,
          errorText: valid ? null : l10n.peopleNumberError,
          errorMaxLines: 3,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
