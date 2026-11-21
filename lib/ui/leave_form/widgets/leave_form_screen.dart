import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/routing/routes.dart';
import 'package:izin_planla/ui/core/theme/app_radius.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/core/theme/color_groups.dart';
import 'package:izin_planla/ui/core/widgets/day_breakdown_list.dart';
import 'package:izin_planla/ui/core/widgets/empty_state.dart';
import 'package:izin_planla/ui/core/widgets/illustration.dart';
import 'package:izin_planla/ui/core/widgets/info_tip.dart';
import 'package:izin_planla/ui/core/widgets/inset_card.dart';
import 'package:izin_planla/ui/core/widgets/primary_button.dart';
import 'package:izin_planla/ui/core/widgets/undo_snack_bar.dart';
import 'package:izin_planla/ui/leave_form/view_models/leave_form_save_result.dart';
import 'package:izin_planla/ui/leave_form/view_models/leave_form_state.dart';
import 'package:izin_planla/ui/leave_form/view_models/leave_form_view_model.dart';
import 'package:izin_planla/ui/leave_form/widgets/leave_texts.dart';
import 'package:izin_planla/ui/people/widgets/date_field.dart';
import 'package:izin_planla/ui/people/widgets/labeled_field.dart';
import 'package:izin_planla/ui/people/widgets/option_list.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

/// Adds or edits a leave. While the user picks dates the form shows how
/// many days the leave costs, day by day, with balance and split rule
/// warnings.
///
/// Opens an existing leave with [leaveId], or a new one with [start] and
/// [end] already chosen. Without constructor values the screen reads the
/// same values from the route's query, see [location].
class LeaveFormScreen extends ConsumerWidget {
  /// Creates the screen.
  const new({this.leaveId, this.start, this.end, super.key});

  /// Id of the leave to edit, null for a new leave.
  final String? leaveId;

  /// First day of a new leave, UTC midnight.
  final DateTime? start;

  /// Last day of a new leave, UTC midnight.
  final DateTime? end;

  static const _idParameter = 'id';
  static const _startParameter = 'start';
  static const _endParameter = 'end';

  /// The route location that opens the form for the leave with [leaveId],
  /// or for a new leave from [start] to [end], for example
  /// `/leave-form?start=2026-11-23&end=2026-11-27`.
  static String location({String? leaveId, DateTime? start, DateTime? end}) {
    String day(DateTime date) => DateTime.utc(
      date.year,
      date.month,
      date.day,
    ).toIso8601String().substring(0, 10);
    return Uri(
      path: Routes.leaveForm,
      queryParameters: {
        _idParameter: ?leaveId,
        if (start != null) _startParameter: day(start),
        if (end != null) _endParameter: day(end),
      },
    ).toString();
  }

  LeaveFormArgs _args(BuildContext context) {
    if (leaveId != null || start != null || end != null) {
      return (leaveId: leaveId, start: start, end: end);
    }
    if (GoRouter.maybeOf(context) == null) {
      return (leaveId: null, start: null, end: null);
    }
    final query = GoRouterState.of(context).uri.queryParameters;
    DateTime? day(String key) {
      final parsed = DateTime.tryParse(query[key] ?? '');
      return parsed == null
          ? null
          : DateTime.utc(parsed.year, parsed.month, parsed.day);
    }

    return (
      leaveId: query[_idParameter],
      start: day(_startParameter),
      end: day(_endParameter),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = leaveFormViewModelProvider(_args(context));
    final state = ref.watch(provider);
    final viewModel = ref.read(provider.notifier);
    final ready = state is LeaveFormReady ? state : null;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ready != null && ready.isEditing
              ? l10n.leaveFormEditTitle
              : l10n.leaveFormTitle,
        ),
        actions: [
          if (ready != null && ready.isEditing)
            IconButton(
              icon: const Icon(LucideIcons.trash2),
              tooltip: l10n.leaveFormDeleteTooltip,
              onPressed: () => unawaited(_delete(context, viewModel)),
            ),
        ],
      ),
      body: switch (state) {
        LeaveFormLoading() => Center(
          child: CircularProgressIndicator(
            semanticsLabel: l10n.leaveFormLoading,
          ),
        ),
        LeaveFormError() => ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            InsetCard(
              summary: Text(l10n.leaveFormErrorMessage),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton(
                  onPressed: viewModel.retry,
                  child: Text(l10n.leaveFormRetry),
                ),
              ),
            ),
          ],
        ),
        LeaveFormNoProfile() => SafeArea(
          child: EmptyState(
            illustration: Illustration.onboardingEmployment,
            message: l10n.leaveFormNoProfileMessage,
            actionLabel: l10n.leaveFormNoProfileAction,
            onAction: () => unawaited(context.push(Routes.onboarding)),
          ),
        ),
        final LeaveFormReady ready => _Form(state: ready, viewModel: viewModel),
      },
      bottomNavigationBar: ready == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: PrimaryButton(
                  label: l10n.leaveFormSave,
                  onPressed: ready.saving
                      ? null
                      : () => unawaited(_save(context, viewModel)),
                ),
              ),
            ),
    );
  }

  static void _close(BuildContext context) {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else if (GoRouter.maybeOf(context) != null) {
      context.go(Routes.home);
    }
  }

  static Future<void> _save(
    BuildContext context,
    LeaveFormViewModel viewModel,
  ) async {
    final l10n = AppLocalizations.of(context);
    final result = await viewModel.save();
    if (!context.mounted) return;
    switch (result) {
      case LeaveFormInvalid():
        break;
      case LeaveFormFailed():
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.leaveFormSaveError)));
      case LeaveFormSaved(:final undo):
        if (undo != null) {
          UndoSnackBar.show(
            context,
            message: l10n.leaveFormUpdated,
            onUndo: () => unawaited(undo()),
          );
        }
        _close(context);
    }
  }

  static Future<void> _delete(
    BuildContext context,
    LeaveFormViewModel viewModel,
  ) async {
    final l10n = AppLocalizations.of(context);
    final undo = await viewModel.delete();
    if (!context.mounted) return;
    if (undo == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.leaveFormSaveError)));
      return;
    }
    UndoSnackBar.show(
      context,
      message: l10n.leaveFormDeleted,
      onUndo: () => unawaited(undo()),
    );
    _close(context);
  }
}

class _Form extends StatelessWidget {
  const new({required this.state, required this.viewModel});

  final LeaveFormReady state;
  final LeaveFormViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final secondary = text.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final draft = state.draft;
    final today = state.today;
    final firstDate = DateTime.utc(today.year - 5);
    final lastDate = DateTime.utc(today.year + 3, 12, 31);
    final dateError = state.showErrors && state.startMissing
        ? l10n.leaveFormDateError
        : null;
    final suggested = state.suggestedDays;
    final dayCount = state.dayCount;
    const gap = SizedBox(height: AppSpacing.md);
    return SafeArea(
      top: false,
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.lg,
        ),
        children: [
          _TypeField(type: draft.type, onChanged: viewModel.setType),
          if (draft.type == LeaveType.other) ...[
            gap,
            LabeledField(
              label: l10n.leaveFormCustomNameLabel,
              child: TextFormField(
                initialValue: draft.customName,
                decoration: InputDecoration(
                  errorText: state.showErrors && state.customNameMissing
                      ? l10n.leaveFormCustomNameError
                      : null,
                  errorMaxLines: 3,
                ),
                onChanged: viewModel.setCustomName,
              ),
            ),
          ],
          if (suggested != null) ...[
            gap,
            InsetCard(
              summary: Row(
                children: [
                  Icon(LucideIcons.scale, color: theme.colorScheme.primary),
                  const SizedBox(width: AppSpacing.smd),
                  Expanded(
                    child: Text(
                      l10n.leaveFormSuggestion(suggested),
                      style: text.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (state.offersSecondExcuse) ...[
            gap,
            Card(
              clipBehavior: Clip.antiAlias,
              child: Row(
                children: [
                  Expanded(
                    child: SwitchListTile(
                      title: Text(l10n.leaveFormSecondExcuseLabel),
                      value: draft.secondExcuse,
                      onChanged: (value) =>
                          viewModel.setSecondExcuse(value: value),
                    ),
                  ),
                  InfoTip(
                    term: l10n.leaveFormSecondExcuseTerm,
                    message: l10n.leaveFormSecondExcuseInfo,
                  ),
                ],
              ),
            ),
          ],
          gap,
          Semantics(
            header: true,
            child: Text(l10n.leaveFormUnitLabel, style: text.titleSmall),
          ),
          const SizedBox(height: AppSpacing.xs),
          OptionList<LeaveUnit>(
            values: LeaveUnit.values,
            selected: draft.unit,
            title: (unit) => switch (unit) {
              LeaveUnit.days => l10n.leaveFormUnitDays,
              LeaveUnit.halfDay => l10n.leaveFormUnitHalfDay,
              LeaveUnit.hours => l10n.leaveFormUnitHours,
            },
            onSelected: viewModel.setUnit,
          ),
          if (draft.unit != LeaveUnit.days) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(l10n.leaveFormWorkplaceNote, style: secondary),
          ],
          gap,
          if (draft.unit == LeaveUnit.days) ...[
            DateField(
              label: l10n.leaveFormStartLabel,
              value: draft.start,
              firstDate: firstDate,
              lastDate: lastDate,
              errorText: dateError,
              onChanged: viewModel.setStart,
            ),
            gap,
            DateField(
              label: l10n.leaveFormEndLabel,
              value: draft.end,
              firstDate: draft.start ?? firstDate,
              lastDate: lastDate,
              onChanged: viewModel.setEnd,
            ),
          ] else
            DateField(
              label: l10n.leaveFormDayLabel,
              value: draft.start,
              firstDate: firstDate,
              lastDate: lastDate,
              errorText: dateError,
              onChanged: viewModel.setStart,
            ),
          if (draft.unit == LeaveUnit.hours) ...[
            gap,
            LabeledField(
              label: l10n.leaveFormHoursLabel,
              child: TextFormField(
                initialValue: draft.hours,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9,]')),
                ],
                decoration: InputDecoration(
                  errorText: state.hoursTooMany
                      ? l10n.leaveFormHoursTooMany(state.dailyHours)
                      : state.showErrors && state.hoursInvalid
                      ? l10n.leaveFormHoursError
                      : null,
                  errorMaxLines: 3,
                ),
                onChanged: viewModel.setHours,
              ),
            ),
          ],
          if (draft.type == LeaveType.paternity) ...[
            gap,
            DateField(
              label: l10n.leaveFormEventDateLabel,
              value: draft.eventDate,
              firstDate: firstDate,
              lastDate: lastDate,
              onChanged: viewModel.setEventDate,
            ),
          ],
          gap,
          _Preview(state: state),
          if (state.shortfall != null || state.warnings.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.smd),
            _Warnings(state: state),
          ],
          if (dayCount != null && dayCount.days.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.smd),
            InsetCard(
              header: CardHeader(
                tint: AppTint.purple,
                icon: LucideIcons.listChecks,
                title: l10n.leaveFormBreakdownTitle,
              ),
              child: DayBreakdownList(days: dayCount.days),
            ),
          ],
          gap,
          LabeledField(
            label: l10n.leaveFormNoteLabel,
            child: TextFormField(
              initialValue: draft.note,
              minLines: 2,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              onChanged: viewModel.setNote,
            ),
          ),
        ],
      ),
    );
  }
}

/// The leave type, opening the list of every type on tap.
class _TypeField extends StatelessWidget {
  const new({required this.type, required this.onChanged});

  final LeaveType type;
  final ValueChanged<LeaveType> onChanged;

  Future<void> _pick(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final picked = await showModalBottomSheet<LeaveType>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) => SingleChildScrollView(
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
                l10n.leaveFormTypeLabel,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: AppSpacing.smd),
            OptionList<LeaveType>(
              values: LeaveType.values,
              selected: type,
              title: (value) => LeaveTexts.typeLabel(l10n, value),
              onSelected: (value) => Navigator.of(context).pop(value),
            ),
          ],
        ),
      ),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return LabeledField(
      label: l10n.leaveFormTypeLabel,
      child: Semantics(
        button: true,
        child: InkWell(
          onTap: () => unawaited(_pick(context)),
          borderRadius: AppRadius.medium,
          child: InputDecorator(
            decoration: const InputDecoration(
              suffixIcon: Icon(LucideIcons.chevronDown),
            ),
            child: Text(
              LeaveTexts.typeLabel(l10n, type),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ),
    );
  }
}

/// How many days the leave costs, as soon as a date is chosen.
class _Preview extends StatelessWidget {
  const new({required this.state});

  final LeaveFormReady state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final draft = state.draft;
    final remaining = state.remainingAfter;
    final String sentence;
    if (draft.range == null) {
      sentence = l10n.leaveFormPickDatesHint;
    } else if (!state.deducts) {
      sentence = l10n.leaveFormNotDeducted;
    } else {
      sentence = switch (draft.unit) {
        LeaveUnit.days => l10n.leaveFormDeductDays(state.dayCount?.total ?? 0),
        LeaveUnit.halfDay => l10n.leaveFormDeductHalfDay,
        LeaveUnit.hours => l10n.leaveFormDeductHours(draft.hoursValue ?? 0),
      };
    }
    return Semantics(
      liveRegion: true,
      child: InsetCard(
        header: CardHeader(
          tint: AppTint.blue,
          icon: LucideIcons.calculator,
          title: l10n.leaveFormDeductTitle,
        ),
        summary: Text(
          sentence,
          style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        child: remaining != null && remaining >= 0
            ? Text(
                l10n.leaveFormRemainingAfter(remaining),
                style: text.bodyLarge,
              )
            : null,
      ),
    );
  }
}

/// Balance, split rule and travel leave warnings. Saving stays possible.
class _Warnings extends StatelessWidget {
  const new({required this.state});

  final LeaveFormReady state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final shortfall = state.shortfall;
    final lines = [
      if (shortfall != null) l10n.leaveFormBalanceWarning(shortfall),
      for (final warning in state.warnings)
        switch (warning) {
          LeaveWarningType.splitRule => l10n.leaveFormSplitWarning,
          LeaveWarningType.travelLeaveLimit => l10n.leaveFormTravelWarning,
          LeaveWarningType.insufficientBalance => l10n.leaveFormBalanceWarning(
            shortfall ?? 0,
          ),
        },
    ];
    return InsetCard(
      header: CardHeader(
        tint: AppTint.orange,
        icon: LucideIcons.triangleAlert,
        title: l10n.leaveFormWarningTitle,
      ),
      summary: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (index, line) in lines.indexed) ...[
            if (index > 0) const SizedBox(height: AppSpacing.sm),
            Text(line, style: text.bodyLarge),
          ],
        ],
      ),
    );
  }
}
