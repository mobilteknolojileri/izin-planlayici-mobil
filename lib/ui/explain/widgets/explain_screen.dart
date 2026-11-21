import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/routing/routes.dart';
import 'package:izin_planla/ui/core/app_format.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/core/theme/color_groups.dart';
import 'package:izin_planla/ui/core/widgets/empty_state.dart';
import 'package:izin_planla/ui/core/widgets/illustration.dart';
import 'package:izin_planla/ui/core/widgets/info_tip.dart';
import 'package:izin_planla/ui/core/widgets/inset_card.dart';
import 'package:izin_planla/ui/explain/view_models/explain_state.dart';
import 'package:izin_planla/ui/explain/view_models/explain_view_model.dart';
import 'package:izin_planla/ui/explain/widgets/explain_rule_text.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

/// "Nasıl hesaplandı?": the balance arithmetic, then every accrual with the
/// rule and article that set its days, in plain words.
class ExplainScreen extends ConsumerWidget {
  /// Creates the screen.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(explainViewModelProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.explainTitle)),
      body: switch (state) {
        ExplainLoading() => Center(
          child: CircularProgressIndicator(semanticsLabel: l10n.explainLoading),
        ),
        ExplainError() => _Body(
          children: [
            InsetCard(
              summary: Text(l10n.explainErrorMessage),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton(
                  onPressed: ref.read(explainViewModelProvider.notifier).retry,
                  child: Text(l10n.explainRetry),
                ),
              ),
            ),
          ],
        ),
        ExplainNoProfile() => SafeArea(
          child: EmptyState(
            illustration: Illustration.onboardingEmployment,
            message: l10n.explainNoProfileMessage,
            actionLabel: l10n.explainNoProfileAction,
            onAction: () => unawaited(context.push(Routes.onboarding)),
          ),
        ),
        final ExplainReady ready => _Ready(state: ready),
      },
    );
  }
}

/// The scrolling page body with the screen padding.
class _Body extends StatelessWidget {
  const new({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.lg,
      ),
      children: children,
    ),
  );
}

class _Ready extends StatelessWidget {
  const new({required this.state});

  final ExplainReady state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final text = Theme.of(context).textTheme;
    final balance = state.balance;
    final next = state.nextAccrual;
    const gap = SizedBox(height: AppSpacing.smd);
    return _Body(
      children: [
        if (state.isTeacher) ...[
          InsetCard(
            header: CardHeader(
              tint: AppTint.orange,
              icon: LucideIcons.info,
              title: l10n.explainNotesHeader,
            ),
            summary: Text(l10n.explainTeacherMessage, style: text.bodyLarge),
          ),
          gap,
        ],
        if (balance != null) ...[
          _SummaryCard(balance: balance, profile: state.profile),
          gap,
        ],
        if (next != null) ...[
          InsetCard(
            header: CardHeader(
              tint: AppTint.green,
              icon: LucideIcons.calendarPlus2,
              title: l10n.explainNextHeader,
            ),
            summary: Text(
              l10n.explainNextDetail(
                AppFormat.longDate(next.date, locale),
                next.days,
              ),
              style: text.bodyLarge,
            ),
          ),
          gap,
        ],
        if (!state.isTeacher) ...[
          const SizedBox(height: AppSpacing.sm),
          Semantics(
            header: true,
            child: Text(l10n.explainPeriodsHeader, style: text.titleLarge),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (state.periods.isEmpty)
            InsetCard(
              summary: Text(l10n.explainNoPeriods, style: text.bodyLarge),
            )
          else
            for (final (index, period) in state.periods.indexed) ...[
              if (index > 0) gap,
              _PeriodCard(period: period),
            ],
          gap,
        ],
        _ProfileCard(profile: state.profile),
        if (!state.isTeacher) ...[gap, _NotesCard(state: state)],
      ],
    );
  }
}

/// The balance as a short sum: earned, used, planned and remaining.
class _SummaryCard extends StatelessWidget {
  const new({required this.balance, required this.profile});

  final LeaveBalance balance;
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final secondary = Theme.of(context).colorScheme.onSurfaceVariant;
    final usedBefore = profile.leaveUsedBeforeTracking;
    final rows = [
      (l10n.explainEarned, balance.earned),
      (l10n.explainUsed, balance.used),
      (l10n.explainPlanned, balance.planned),
      (l10n.explainRemaining, balance.remaining),
    ];
    return InsetCard(
      header: CardHeader(
        tint: AppTint.blue,
        icon: LucideIcons.calculator,
        title: l10n.explainSummaryTitle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (index, (label, days)) in rows.indexed) ...[
            if (index > 0) const Divider(),
            MergeSemantics(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Row(
                  children: [
                    Expanded(child: Text(label, style: text.bodyLarge)),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      l10n.coreDays(days),
                      style: index == rows.length - 1
                          ? text.titleMedium
                          : text.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (usedBefore > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.explainUsedBeforeNote(usedBefore),
              style: text.bodyMedium?.copyWith(color: secondary),
            ),
          ],
          if (balance.expiringAtYearEnd > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.explainExpiringNote(balance.expiringAtYearEnd),
              style: text.bodyMedium?.copyWith(color: secondary),
            ),
          ],
        ],
      ),
    );
  }
}

/// One accrual: its date, the days earned and the rules behind them.
class _PeriodCard extends StatelessWidget {
  const new({required this.period});

  final EntitlementPeriod period;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final secondary = theme.colorScheme.onSurfaceVariant;
    final year = period.calendarYear;
    final expires = period.expiresOn;
    return InsetCard(
      header: CardHeader(
        tint: AppTint.green,
        icon: LucideIcons.calendarCheck,
        title: AppFormat.longDate(period.accrualDate, locale),
      ),
      summary: Text(
        l10n.explainPeriodDays(period.days),
        style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (year != null)
            Text(l10n.explainPeriodYear(year), style: text.bodyLarge),
          if (expires != null)
            Text(
              l10n.explainPeriodExpires(AppFormat.longDate(expires, locale)),
              style: text.bodyLarge,
            ),
          for (final rule in period.rules) ...[
            const SizedBox(height: AppSpacing.smd),
            MergeSemantics(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ExplainRuleText.of(l10n, rule, locale),
                    style: text.bodyLarge,
                  ),
                  Text(
                    rule.legalReference,
                    style: text.bodyMedium?.copyWith(color: secondary),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// The facts the calculation starts from.
class _ProfileCard extends StatelessWidget {
  const new({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final text = Theme.of(context).textTheme;
    final prior = profile.priorService;
    final labor = profile.employmentType == EmploymentType.laborLaw;
    final hasPrior = prior.years > 0 || prior.months > 0 || prior.days > 0;
    return InsetCard(
      header: CardHeader(
        tint: AppTint.purple,
        icon: LucideIcons.userRound,
        title: l10n.explainProfileHeader,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labor ? l10n.explainEmploymentLabor : l10n.explainEmploymentCivil,
            style: text.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.explainStartDate(
              AppFormat.longDate(profile.employmentStartDate, locale),
            ),
            style: text.bodyLarge,
          ),
          if (hasPrior)
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.explainPriorService(
                      prior.years,
                      prior.months,
                      prior.days,
                    ),
                    style: text.bodyLarge,
                  ),
                ),
                InfoTip(
                  term: l10n.explainPriorServiceTerm,
                  message: labor
                      ? l10n.explainPriorServiceInfoLabor
                      : l10n.explainPriorServiceInfoCivil,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

/// Assumptions and settings that change the result.
class _NotesCard extends StatelessWidget {
  const new({required this.state});

  final ExplainReady state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final schedule = state.profile.workSchedule;
    final notes = [
      if (state.showNoAbsenceNote) l10n.explainNoAbsenceNote,
      switch (schedule.halfDayDeduction) {
        HalfDayDeduction.zero => l10n.explainHalfDayZero,
        HalfDayDeduction.half => l10n.explainHalfDayHalf,
        HalfDayDeduction.full => l10n.explainHalfDayFull,
      },
      l10n.explainHalfDayUnclear,
      if (state.showSaturdayNote && schedule.saturdayCountsAsLeave)
        l10n.explainSaturdayCounts,
      if (state.showSaturdayNote && !schedule.saturdayCountsAsLeave)
        l10n.explainSaturdayNotCounted,
    ];
    return InsetCard(
      header: CardHeader(
        tint: AppTint.orange,
        icon: LucideIcons.lightbulb,
        title: l10n.explainNotesHeader,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (index, note) in notes.indexed) ...[
            if (index > 0) const SizedBox(height: AppSpacing.sm),
            Text(note, style: text.bodyLarge),
          ],
        ],
      ),
    );
  }
}
