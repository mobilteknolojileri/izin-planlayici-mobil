import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:izin_planla/data/services/export/export_format.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/routing/routes.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/core/theme/color_groups.dart';
import 'package:izin_planla/ui/core/widgets/info_tip.dart';
import 'package:izin_planla/ui/core/widgets/inset_card.dart';
import 'package:izin_planla/ui/core/widgets/large_title_page.dart';
import 'package:izin_planla/ui/core/widgets/undo_snack_bar.dart';
import 'package:izin_planla/ui/settings/view_models/settings_content.dart';
import 'package:izin_planla/ui/settings/view_models/settings_reminder.dart';
import 'package:izin_planla/ui/settings/view_models/settings_restore_failure.dart';
import 'package:izin_planla/ui/settings/view_models/settings_view_model.dart';
import 'package:izin_planla/ui/settings/widgets/reset_confirm_dialog.dart';
import 'package:izin_planla/ui/settings/widgets/settings_choice_row.dart';
import 'package:izin_planla/ui/settings/widgets/settings_nav_row.dart';
import 'package:izin_planla/ui/settings/widgets/settings_stepper.dart';
import 'package:izin_planla/utils/result.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

/// Settings tab: people, work schedule, theme, reminders, data backup,
/// export and reset, and links to the statistics, guide and about screens.
class SettingsScreen extends ConsumerWidget {
  /// Creates the screen.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(settingsViewModelProvider);
    final viewModel = ref.read(settingsViewModelProvider.notifier);
    final text = Theme.of(context).textTheme;
    final List<Widget> children;
    switch (state.content) {
      case AsyncValue(value: final content?):
        children = [
          _PeopleCard(content: content),
          if (content.activeProfile case final profile?) ...[
            const SizedBox(height: AppSpacing.smd),
            _ScheduleCard(profile: profile, viewModel: viewModel),
          ],
          const SizedBox(height: AppSpacing.smd),
          _ThemeCard(content: content, viewModel: viewModel),
          const SizedBox(height: AppSpacing.smd),
          _RemindersCard(content: content, viewModel: viewModel),
          const SizedBox(height: AppSpacing.smd),
          _DataCard(content: content, viewModel: viewModel),
          const SizedBox(height: AppSpacing.smd),
          const _InfoCard(),
        ];
      case AsyncValue(error: _?):
        children = [
          InsetCard(summary: Text(l10n.settingsError, style: text.bodyLarge)),
        ];
      case _:
        children = [
          Center(
            child: CircularProgressIndicator(
              semanticsLabel: l10n.settingsLoading,
            ),
          ),
        ];
    }
    return LargeTitlePage(title: l10n.settingsTitle, children: children);
  }
}

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

Future<bool> _confirm(
  BuildContext context, {
  required String title,
  required String body,
  required String action,
  bool destructive = false,
}) async {
  final l10n = AppLocalizations.of(context);
  final scheme = Theme.of(context).colorScheme;
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      scrollable: true,
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.settingsCancel),
        ),
        TextButton(
          style: destructive
              ? TextButton.styleFrom(foregroundColor: scheme.error)
              : null,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(action),
        ),
      ],
    ),
  );
  return result ?? false;
}

class _PeopleCard extends StatelessWidget {
  const new({required this.content});

  final SettingsContent content;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final active = content.activeProfile;
    return InsetCard(
      header: CardHeader(
        tint: AppTint.blue,
        icon: LucideIcons.users,
        title: l10n.settingsPeopleTitle,
        chevron: true,
      ),
      summary: Text(
        active == null
            ? l10n.settingsPeopleEmpty
            : l10n.settingsPeopleSummary(active.name, content.profiles.length),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      onTap: () => context.push<void>(Routes.people).ignore(),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  const new({required this.profile, required this.viewModel});

  final Profile profile;
  final SettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final secondary = text.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final schedule = profile.workSchedule;
    // Any Monday, to name the weekdays.
    final monday = DateTime.utc(2024);
    final showSaturday =
        profile.employmentType == EmploymentType.laborLaw &&
        !schedule.workDays.contains(DateTime.saturday);
    final halfDays = {
      HalfDayDeduction.zero: l10n.settingsHalfDayZero,
      HalfDayDeduction.half: l10n.settingsHalfDayHalf,
      HalfDayDeduction.full: l10n.settingsHalfDayFull,
    };
    final hours = schedule.dailyWorkingHours;
    return InsetCard(
      header: CardHeader(
        tint: AppTint.green,
        icon: LucideIcons.briefcase,
        title: l10n.settingsScheduleTitle,
      ),
      summary: Text(l10n.settingsScheduleFor(profile.name), style: secondary),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.settingsWorkDays, style: text.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (var i = 0; i < DateTime.daysPerWeek; i++)
                FilterChip(
                  label: Text(
                    DateFormat.EEEE(locale)
                        .format(monday.add(Duration(days: i))),
                  ),
                  selected: schedule.workDays.contains(i + 1),
                  onSelected: (_) => viewModel.toggleWorkDay(i + 1).ignore(),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(l10n.settingsWorkDaysHelp, style: secondary),
          if (showSaturday) ...[
            const Divider(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.settingsSaturdayTitle),
                    subtitle: Text(l10n.settingsSaturdayHelp),
                    value: schedule.saturdayCountsAsLeave,
                    onChanged: (value) => viewModel
                        .setSaturdayCountsAsLeave(value: value)
                        .ignore(),
                  ),
                ),
                InfoTip(
                  term: l10n.settingsSaturdayInfoTerm,
                  message: l10n.settingsSaturdayInfo,
                ),
              ],
            ),
          ],
          const Divider(height: AppSpacing.lg),
          Text(l10n.settingsHalfDayTitle, style: text.titleSmall),
          Text(l10n.settingsHalfDayHelp, style: secondary),
          for (final MapEntry(key: value, value: label) in halfDays.entries)
            SettingsChoiceRow(
              label: label,
              selected: schedule.halfDayDeduction == value,
              onTap: () => viewModel.setHalfDayDeduction(value).ignore(),
            ),
          const Divider(height: AppSpacing.lg),
          Text(l10n.settingsHoursTitle, style: text.titleSmall),
          Text(l10n.settingsHoursHelp, style: secondary),
          const SizedBox(height: AppSpacing.sm),
          SettingsStepper(
            value: l10n.settingsHoursValue(hours),
            decreaseTooltip: l10n.settingsHoursDecrease,
            increaseTooltip: l10n.settingsHoursIncrease,
            onDecrease: hours > SettingsContent.minHours
                ? () => viewModel.changeHours(-0.5).ignore()
                : null,
            onIncrease: hours < SettingsContent.maxHours
                ? () => viewModel.changeHours(0.5).ignore()
                : null,
          ),
        ],
      ),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  const new({required this.content, required this.viewModel});

  final SettingsContent content;
  final SettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final modes = {
      AppThemeMode.system: l10n.settingsThemeSystem,
      AppThemeMode.light: l10n.settingsThemeLight,
      AppThemeMode.dark: l10n.settingsThemeDark,
    };
    return InsetCard(
      header: CardHeader(
        tint: AppTint.purple,
        icon: LucideIcons.palette,
        title: l10n.settingsThemeTitle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final MapEntry(key: mode, value: label) in modes.entries)
            SettingsChoiceRow(
              label: label,
              selected: content.settings.themeMode == mode,
              onTap: () => viewModel.setThemeMode(mode).ignore(),
            ),
        ],
      ),
    );
  }
}

class _RemindersCard extends StatelessWidget {
  const new({required this.content, required this.viewModel});

  final SettingsContent content;
  final SettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final prefs = content.settings.notifications;
    final reminders = [
      (
        SettingsReminder.holiday,
        l10n.settingsReminderHoliday,
        prefs.holidayReminder,
        prefs.holidayDaysBefore,
      ),
      (
        SettingsReminder.accrual,
        l10n.settingsReminderAccrual,
        prefs.accrualReminder,
        null,
      ),
      (
        SettingsReminder.planned,
        l10n.settingsReminderPlanned,
        prefs.plannedLeaveReminder,
        prefs.plannedLeaveDaysBefore,
      ),
      (
        SettingsReminder.yearEnd,
        l10n.settingsReminderYearEnd,
        prefs.yearEndReminder,
        null,
      ),
    ];
    return InsetCard(
      header: CardHeader(
        tint: AppTint.orange,
        icon: LucideIcons.bell,
        title: l10n.settingsRemindersTitle,
      ),
      summary: Text(
        l10n.settingsRemindersHelp,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (reminder, label, enabled, days) in reminders) ...[
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(label),
              value: enabled,
              onChanged: (value) => _toggle(context, reminder, value),
            ),
            if (enabled && days != null)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: SettingsStepper(
                  value: l10n.settingsDaysBefore(days),
                  decreaseTooltip: l10n.settingsDaysBeforeDecrease,
                  increaseTooltip: l10n.settingsDaysBeforeIncrease,
                  onDecrease: days > SettingsContent.minDaysBefore
                      ? () => viewModel.changeDaysBefore(reminder, -1).ignore()
                      : null,
                  onIncrease: days < SettingsContent.maxDaysBefore
                      ? () => viewModel.changeDaysBefore(reminder, 1).ignore()
                      : null,
                ),
              ),
          ],
        ],
      ),
    );
  }

  Future<void> _toggle(
    BuildContext context,
    SettingsReminder reminder,
    bool enabled,
  ) async {
    final l10n = AppLocalizations.of(context);
    final saved = await viewModel.setReminder(reminder, enabled: enabled);
    if (!saved && enabled && context.mounted) {
      _showMessage(context, l10n.settingsPermissionDenied);
    }
  }
}

class _DataCard extends StatelessWidget {
  const new({required this.content, required this.viewModel});

  final SettingsContent content;
  final SettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return InsetCard(
      header: CardHeader(
        tint: AppTint.blue,
        icon: LucideIcons.database,
        title: l10n.settingsDataTitle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SettingsNavRow(
            icon: LucideIcons.archive,
            title: l10n.settingsBackup,
            subtitle: l10n.settingsBackupHelp,
            onTap: () => _backup(context),
          ),
          SettingsNavRow(
            icon: LucideIcons.archiveRestore,
            title: l10n.settingsRestore,
            subtitle: l10n.settingsRestoreHelp,
            onTap: () => _restore(context),
          ),
          if (content.activeProfile != null)
            SettingsNavRow(
              icon: LucideIcons.fileOutput,
              title: l10n.settingsExport,
              subtitle: l10n.settingsExportHelp,
              onTap: () => _export(context),
            ),
          SettingsNavRow(
            icon: LucideIcons.trash2,
            title: l10n.settingsReset,
            subtitle: l10n.settingsResetHelp,
            destructive: true,
            onTap: () => _reset(context),
          ),
        ],
      ),
    );
  }

  Future<void> _backup(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final shared = await viewModel.backup();
    if (!shared && context.mounted) {
      _showMessage(context, l10n.settingsFailed);
    }
  }

  Future<void> _restore(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final picked = await viewModel.pickBackup();
    if (!context.mounted) return;
    final String json;
    switch (picked) {
      case Ok(:final String value):
        json = value;
      case Ok():
        return;
      case Err(:final error):
        _showMessage(
          context,
          _restoreMessage(l10n, viewModel.pickFailure(error)),
        );
        return;
    }
    final confirmed = await _confirm(
      context,
      title: l10n.settingsRestoreConfirmTitle,
      body: l10n.settingsRestoreConfirmBody,
      action: l10n.settingsRestoreConfirm,
    );
    if (!confirmed || !context.mounted) return;
    final failure = await viewModel.restore(json);
    if (!context.mounted) return;
    _showMessage(context, _restoreMessage(l10n, failure));
  }

  static String _restoreMessage(
    AppLocalizations l10n,
    SettingsRestoreFailure? failure,
  ) => switch (failure) {
    null => l10n.settingsRestoreDone,
    SettingsRestoreFailure.newer => l10n.settingsRestoreNewer,
    SettingsRestoreFailure.invalid => l10n.settingsRestoreInvalid,
    SettingsRestoreFailure.other => l10n.settingsFailed,
  };

  Future<void> _export(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final choice = await showDialog<(ExportFormat, bool)>(
      context: context,
      builder: (context) => const _ExportDialog(),
    );
    if (choice == null || !context.mounted) return;
    final (format, save) = choice;
    final done = await viewModel.export(format, save: save);
    if (!context.mounted) return;
    if (!done) {
      _showMessage(context, l10n.settingsFailed);
    } else if (save) {
      _showMessage(context, l10n.settingsExportSaved);
    }
  }

  Future<void> _reset(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const ResetConfirmDialog(),
    );
    if (confirmed != true || !context.mounted) return;
    final router = GoRouter.of(context);
    final snapshot = await viewModel.resetAll();
    if (!context.mounted) return;
    if (snapshot == null) {
      _showMessage(context, l10n.settingsFailed);
      return;
    }
    UndoSnackBar.show(
      context,
      message: l10n.settingsResetDone,
      onUndo: () async {
        if (await viewModel.undoReset(snapshot)) router.go(Routes.home);
      },
    );
    router.go(Routes.onboarding);
  }
}

/// Chooses the file format, then sharing or saving the file.
class _ExportDialog extends StatefulWidget {
  const new();

  @override
  State<_ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<_ExportDialog> {
  ExportFormat _format = ExportFormat.pdf;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final formats = {
      ExportFormat.pdf: l10n.settingsExportPdf,
      ExportFormat.xlsx: l10n.settingsExportExcel,
      ExportFormat.csv: l10n.settingsExportCsv,
    };
    return AlertDialog(
      scrollable: true,
      title: Text(l10n.settingsExport),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.settingsExportHelp),
          for (final MapEntry(key: format, value: label) in formats.entries)
            SettingsChoiceRow(
              label: label,
              selected: _format == format,
              onTap: () => setState(() => _format = format),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.settingsCancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop((_format, true)),
          child: Text(l10n.settingsExportSave),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop((_format, false)),
          child: Text(l10n.settingsExportShare),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return InsetCard(
      header: CardHeader(
        tint: AppTint.purple,
        icon: LucideIcons.info,
        title: l10n.settingsInfoTitle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SettingsNavRow(
            icon: LucideIcons.chartColumn,
            title: l10n.settingsStats,
            chevron: true,
            onTap: () => context.push<void>(Routes.stats).ignore(),
          ),
          SettingsNavRow(
            icon: LucideIcons.bookOpen,
            title: l10n.settingsGuide,
            chevron: true,
            onTap: () => context.push<void>(Routes.guide).ignore(),
          ),
          SettingsNavRow(
            icon: LucideIcons.info,
            title: l10n.settingsAbout,
            chevron: true,
            onTap: () => context.push<void>(Routes.about).ignore(),
          ),
        ],
      ),
    );
  }
}
