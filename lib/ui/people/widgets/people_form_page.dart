import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/core/widgets/primary_button.dart';
import 'package:izin_planla/ui/core/widgets/undo_snack_bar.dart';
import 'package:izin_planla/ui/people/view_models/people_view_model.dart';
import 'package:izin_planla/ui/people/view_models/profile_draft.dart';
import 'package:izin_planla/ui/people/widgets/date_field.dart';
import 'package:izin_planla/ui/people/widgets/labeled_field.dart';
import 'package:izin_planla/ui/people/widgets/option_list.dart';
import 'package:izin_planla/ui/people/widgets/profile_advanced_fields.dart';
import 'package:izin_planla/utils/result.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

/// Form of one person, opened from the people screen: name, employment
/// type, dates, Saturday work and the optional advanced answers.
class PeopleFormPage extends ConsumerStatefulWidget {
  /// Creates the form. Edits [profile] when given, else adds a person.
  const new({required this.today, this.profile, super.key});

  /// Today, UTC midnight, the latest date the pickers allow.
  final DateTime today;

  /// The person being edited, null for a new one.
  final Profile? profile;

  @override
  ConsumerState<PeopleFormPage> createState() => _PeopleFormPageState();
}

class _PeopleFormPageState extends ConsumerState<PeopleFormPage> {
  static final _firstDate = DateTime.utc(1940);

  late ProfileDraft _draft = switch (widget.profile) {
    final profile? => ProfileDraft.fromProfile(profile),
    null => const ProfileDraft(employmentType: EmploymentType.laborLaw),
  };
  bool _showErrors = false;
  bool _busy = false;

  void _update(ProfileDraft draft) => setState(() => _draft = draft);

  Future<void> _save() async {
    setState(() => _showErrors = true);
    if (_draft.name.trim().isEmpty || !_draft.isComplete) return;
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    final result = await ref
        .read(peopleViewModelProvider.notifier)
        .save(_draft, existing: widget.profile);
    if (!mounted) return;
    setState(() => _busy = false);
    if (result is Ok<void>) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.peopleSaveError)));
    }
  }

  Future<void> _delete(Profile profile) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    final undo = await ref
        .read(peopleViewModelProvider.notifier)
        .delete(profile);
    if (!mounted) return;
    setState(() => _busy = false);
    if (undo == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.peopleSaveError)));
      return;
    }
    UndoSnackBar.show(
      context,
      message: l10n.peopleDeleted(profile.name),
      onUndo: () => unawaited(undo()),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profile = widget.profile;
    final draft = _draft;
    final dateError = _showErrors ? l10n.peopleFormDateError : null;
    const gap = SizedBox(height: AppSpacing.md);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          profile == null ? l10n.peopleFormNewTitle : l10n.peopleFormEditTitle,
        ),
        actions: [
          if (profile != null)
            IconButton(
              icon: const Icon(LucideIcons.trash2),
              tooltip: l10n.peopleFormDeleteTooltip,
              onPressed: _busy ? null : () => unawaited(_delete(profile)),
            ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            LabeledField(
              label: l10n.peopleFormName,
              child: TextFormField(
                initialValue: draft.name,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  errorText: _showErrors && draft.name.trim().isEmpty
                      ? l10n.peopleFormNameError
                      : null,
                  errorMaxLines: 3,
                ),
                onChanged: (value) => _update(draft.copyWith(name: value)),
              ),
            ),
            gap,
            Semantics(
              header: true,
              child: Text(
                l10n.peopleFormTypeLabel,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            OptionList<EmploymentType>(
              values: EmploymentType.values,
              selected: draft.employmentType,
              title: (type) => switch (type) {
                EmploymentType.laborLaw => l10n.peopleTypeLaborTitle,
                EmploymentType.civilServant => l10n.peopleTypeCivilTitle,
              },
              detail: (type) => switch (type) {
                EmploymentType.laborLaw => l10n.peopleTypeLaborDetail,
                EmploymentType.civilServant => l10n.peopleTypeCivilDetail,
              },
              onSelected: (type) =>
                  _update(draft.copyWith(employmentType: type)),
            ),
            gap,
            DateField(
              label: l10n.peopleFormStart,
              value: draft.startDate,
              firstDate: _firstDate,
              lastDate: widget.today,
              errorText: draft.startDate == null ? dateError : null,
              onChanged: (date) => _update(draft.copyWith(startDate: date)),
            ),
            // Only workers are asked, the age rules are 4857 only.
            if (draft.isLabor) ...[
              gap,
              DateField(
                label: l10n.peopleFormBirth,
                value: draft.birthDate,
                firstDate: _firstDate,
                lastDate: widget.today,
                errorText: draft.birthDate == null ? dateError : null,
                onChanged: (date) => _update(draft.copyWith(birthDate: date)),
              ),
              gap,
              Card(
                clipBehavior: Clip.antiAlias,
                child: SwitchListTile(
                  title: Text(l10n.peopleFormSaturday),
                  value: draft.worksSaturday ?? false,
                  onChanged: (value) =>
                      _update(draft.copyWith(worksSaturday: value)),
                ),
              ),
            ],
            gap,
            ProfileAdvancedFields(draft: draft, onChanged: _update),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: PrimaryButton(
            label: l10n.peopleFormSave,
            onPressed: _busy ? null : () => unawaited(_save()),
          ),
        ),
      ),
    );
  }
}
