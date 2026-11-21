import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/core/widgets/primary_button.dart';
import 'package:izin_planla/ui/core/widgets/undo_snack_bar.dart';
import 'package:izin_planla/ui/leaves/view_models/leaves_view_model.dart';
import 'package:izin_planla/ui/people/widgets/date_field.dart';
import 'package:izin_planla/ui/people/widgets/labeled_field.dart';
import 'package:material_ui/material_ui.dart';

/// Bottom sheet that adds, edits or deletes one overtime record.
class OvertimeSheet extends ConsumerStatefulWidget {
  /// Creates the sheet. Edits [record] when given.
  const new({required this.today, this.record, super.key});

  /// Today, UTC midnight, the default date.
  final DateTime today;

  /// The record being edited, null for a new one.
  final OvertimeRecord? record;

  /// Opens the sheet over [context].
  static Future<void> show(
    BuildContext context, {
    required DateTime today,
    OvertimeRecord? record,
  }) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => OvertimeSheet(today: today, record: record),
  );

  @override
  ConsumerState<OvertimeSheet> createState() => _OvertimeSheetState();
}

class _OvertimeSheetState extends ConsumerState<OvertimeSheet> {
  late DateTime _date = widget.record?.date ?? widget.today;
  late String _hours = switch (widget.record?.hours) {
    null => '',
    final hours when hours == hours.roundToDouble() => '${hours.round()}',
    final hours => '$hours'.replaceAll('.', ','),
  };
  late String _note = widget.record?.note ?? '';
  bool _showErrors = false;
  bool _busy = false;

  Future<void> _save() async {
    final viewModel = ref.read(leavesViewModelProvider.notifier);
    if (!viewModel.isValidHours(_hours)) {
      setState(() => _showErrors = true);
      return;
    }
    setState(() => _busy = true);
    final saved = await viewModel.saveOvertime(
      date: _date,
      hours: _hours,
      note: _note,
      existing: widget.record,
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (saved) Navigator.of(context).pop();
  }

  Future<void> _delete(OvertimeRecord record) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    final undo = await ref
        .read(leavesViewModelProvider.notifier)
        .deleteOvertime(record);
    if (!mounted) return;
    setState(() => _busy = false);
    if (undo == null) return;
    UndoSnackBar.show(
      context,
      message: l10n.leavesOvertimeDeleted,
      onUndo: () => unawaited(undo()),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = ref.read(leavesViewModelProvider.notifier);
    final record = widget.record;
    final today = widget.today;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              child: Text(
                l10n.leavesOvertimeSheetTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            DateField(
              label: l10n.leavesOvertimeDate,
              value: _date,
              firstDate: DateTime.utc(today.year - 5),
              lastDate: DateTime.utc(today.year + 1, 12, 31),
              onChanged: (date) => setState(() => _date = date),
            ),
            const SizedBox(height: AppSpacing.md),
            LabeledField(
              label: l10n.leavesOvertimeHoursLabel,
              child: TextFormField(
                initialValue: _hours,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9,]')),
                ],
                decoration: InputDecoration(
                  errorText: _showErrors && !viewModel.isValidHours(_hours)
                      ? l10n.leavesOvertimeHoursError
                      : null,
                  errorMaxLines: 3,
                ),
                onChanged: (value) => setState(() => _hours = value),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            LabeledField(
              label: l10n.leavesOvertimeNote,
              child: TextFormField(
                initialValue: _note,
                onChanged: (value) => _note = value,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: l10n.leavesSave,
              onPressed: _busy ? null : () => unawaited(_save()),
            ),
            if (record != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Center(
                child: TextButton(
                  onPressed: _busy ? null : () => unawaited(_delete(record)),
                  child: Text(l10n.leavesDelete),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
