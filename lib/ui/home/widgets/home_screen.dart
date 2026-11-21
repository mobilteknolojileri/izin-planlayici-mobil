import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/routing/routes.dart';
import 'package:izin_planla/ui/core/app_format.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/core/theme/color_groups.dart';
import 'package:izin_planla/ui/core/widgets/balance_ring.dart';
import 'package:izin_planla/ui/core/widgets/big_number_card.dart';
import 'package:izin_planla/ui/core/widgets/empty_state.dart';
import 'package:izin_planla/ui/core/widgets/illustration.dart';
import 'package:izin_planla/ui/core/widgets/inset_card.dart';
import 'package:izin_planla/ui/core/widgets/large_title_page.dart';
import 'package:izin_planla/ui/core/widgets/legend_row.dart';
import 'package:izin_planla/ui/core/widgets/primary_button.dart';
import 'package:izin_planla/ui/core/widgets/stat_card.dart';
import 'package:izin_planla/ui/core/widgets/week_strip.dart';
import 'package:izin_planla/ui/home/view_models/home_state.dart';
import 'package:izin_planla/ui/home/view_models/home_view_model.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

/// Home tab: how many leave days are left, with the next accrual, the next
/// holiday and the best bridge ahead. At most four cards and one main
/// button, "İzin ekle".
class HomeScreen extends ConsumerWidget {
  /// Creates the screen.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(homeViewModelProvider);
    return switch (state) {
      HomeLoading() => LargeTitlePage(
        title: l10n.homeTitle,
        children: [_Loading(label: l10n.homeLoading)],
      ),
      HomeError() => LargeTitlePage(
        title: l10n.homeTitle,
        children: [
          _LoadError(
            message: l10n.homeErrorMessage,
            retryLabel: l10n.homeRetry,
            onRetry: ref.read(homeViewModelProvider.notifier).retry,
          ),
        ],
      ),
      HomeNoProfile() => LargeTitlePage(
        title: l10n.homeTitle,
        children: [
          EmptyState(
            illustration: Illustration.onboardingEmployment,
            message: l10n.homeNoProfileMessage,
            actionLabel: l10n.homeNoProfileAction,
            onAction: () => unawaited(context.push(Routes.onboarding)),
          ),
        ],
      ),
      final HomeReady ready => _Ready(state: ready),
    };
  }
}

class _Ready extends StatelessWidget {
  const new({required this.state});

  final HomeReady state;

  void _open(BuildContext context, String route) =>
      unawaited(context.push(route));

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final balance = state.balance;
    final next = state.nextAccrual;
    final holiday = state.nextHoliday;
    final bridge = state.bridge;
    final text = Theme.of(context).textTheme;
    // Side by side cards stack when the system text is large.
    final stack = MediaQuery.textScalerOf(context).scale(10) > 13;
    final statCards = [
      if (next != null)
        StatCard(
          tint: AppTint.green,
          icon: LucideIcons.calendarPlus2,
          title: l10n.homeNextAccrualTitle,
          value: '${state.daysUntilAccrual}',
          unit: l10n.homeDaysLeftUnit,
          detail: l10n.homeNextAccrualDetail(
            AppFormat.longDate(next.date, locale),
            next.days,
          ),
        ),
      if (holiday != null)
        StatCard(
          tint: AppTint.orange,
          icon: LucideIcons.flag,
          title: l10n.homeNextHolidayTitle,
          value: '${state.daysUntilHoliday}',
          unit: l10n.homeDaysLeftUnit,
          detail: l10n.homeNextHolidayDetail(
            holiday.name,
            AppFormat.longDate(holiday.date, locale),
          ),
        ),
    ];
    return LargeTitlePage(
      overline: AppFormat.longDate(state.today, locale),
      title: state.hasSeveralProfiles ? state.profileName : l10n.homeTitle,
      children: [
        if (balance == null)
          InsetCard(
            header: CardHeader(
              tint: AppTint.orange,
              icon: LucideIcons.info,
              title: l10n.homeTeacherTitle,
              chevron: true,
            ),
            summary: Text(l10n.homeTeacherMessage, style: text.bodyLarge),
            onTap: () => _open(context, Routes.explain),
          )
        else
          BigNumberCard(
            title: l10n.homeRemainingTitle,
            icon: LucideIcons.treePalm,
            value: AppFormat.days(balance.remaining, locale),
            unit: l10n.homeDaysUnit,
            caption: balance.remaining < 0
                ? l10n.homeOverdrawnCaption(-balance.remaining)
                : l10n.homeRemainingCaption(
                    balance.earned,
                    balance.used,
                    balance.planned,
                  ),
            trailing: BalanceRing(
              remaining: balance.remaining,
              used: balance.used,
              planned: balance.planned,
            ),
            footer: BalanceLegend(
              remaining: balance.remaining,
              used: balance.used,
              planned: balance.planned,
            ),
            actionLabel: l10n.homeHowCalculated,
            onAction: () => _open(context, Routes.explain),
          ),
        const SizedBox(height: AppSpacing.md),
        PrimaryButton(
          label: l10n.homeAddLeave,
          icon: LucideIcons.plus,
          onPressed: () => _open(context, Routes.leaveForm),
        ),
        if (statCards.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          if (stack || statCards.length == 1)
            for (final (index, card) in statCards.indexed) ...[
              if (index > 0) const SizedBox(height: AppSpacing.smd),
              card,
            ]
          else
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: statCards[0]),
                  const SizedBox(width: AppSpacing.smd),
                  Expanded(child: statCards[1]),
                ],
              ),
            ),
        ],
        if (bridge != null) ...[
          const SizedBox(height: AppSpacing.smd),
          InsetCard(
            header: CardHeader(
              tint: AppTint.blue,
              icon: LucideIcons.bridge,
              title: l10n.homeBridgeTitle,
              chevron: true,
            ),
            summary: Text(
              l10n.homeBridgeCaption(
                bridge.leaveDaysUsed,
                bridge.totalDaysOff,
                AppFormat.dayRange(bridge.vacation, locale),
              ),
              style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            onTap: () => context.go(Routes.bridge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WeekStrip(days: state.bridgeDays),
                const SizedBox(height: AppSpacing.smd),
                LegendRow(meanings: state.bridgeMeanings),
              ],
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          children: [
            TextButton.icon(
              icon: const Icon(LucideIcons.chartColumn),
              label: Text(l10n.homeStatsLink),
              onPressed: () => _open(context, Routes.stats),
            ),
            TextButton.icon(
              icon: const Icon(LucideIcons.bookOpen),
              label: Text(l10n.homeGuideLink),
              onPressed: () => _open(context, Routes.guide),
            ),
          ],
        ),
      ],
    );
  }
}

/// A centred progress indicator with a screen reader label.
class _Loading extends StatelessWidget {
  const new({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(AppSpacing.xl),
    child: Center(child: CircularProgressIndicator(semanticsLabel: label)),
  );
}

/// A short error sentence with a retry button.
class _LoadError extends StatelessWidget {
  const new({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => InsetCard(
    summary: Text(message, style: Theme.of(context).textTheme.bodyLarge),
    child: Align(
      alignment: AlignmentDirectional.centerStart,
      child: TextButton(onPressed: onRetry, child: Text(retryLabel)),
    ),
  );
}
