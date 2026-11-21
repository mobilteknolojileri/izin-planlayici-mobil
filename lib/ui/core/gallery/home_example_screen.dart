import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/core/app_format.dart';
import 'package:izin_planla/ui/core/gallery/gallery_samples.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/core/theme/app_theme.dart';
import 'package:izin_planla/ui/core/theme/color_groups.dart';
import 'package:izin_planla/ui/core/theme/meaning.dart';
import 'package:izin_planla/ui/core/widgets/app_tab_bar.dart';
import 'package:izin_planla/ui/core/widgets/balance_ring.dart';
import 'package:izin_planla/ui/core/widgets/big_number_card.dart';
import 'package:izin_planla/ui/core/widgets/inset_card.dart';
import 'package:izin_planla/ui/core/widgets/large_title_page.dart';
import 'package:izin_planla/ui/core/widgets/legend_row.dart';
import 'package:izin_planla/ui/core/widgets/primary_button.dart';
import 'package:izin_planla/ui/core/widgets/stat_card.dart';
import 'package:izin_planla/ui/core/widgets/week_strip.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

/// A home screen built only from task 06 components, with sample data.
/// Debug builds only, opened from the gallery. Task 11 builds the real home
/// screen the same way, inside `AppShell` instead of its own tab bar.
class HomeExampleScreen extends StatelessWidget {
  /// Creates the example.
  const new({required this.dark, super.key});

  /// Whether the dark theme is shown.
  final bool dark;

  @override
  Widget build(BuildContext context) =>
      Theme(data: dark ? AppTheme.dark : AppTheme.light, child: const _Page());
}

class _Page extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final text = Theme.of(context).textTheme;
    // Side by side cards stack when the system text is large.
    final stack = MediaQuery.textScalerOf(context).scale(10) > 13;
    final cards = [
      StatCard(
        tint: AppTint.green,
        icon: LucideIcons.calendarPlus2,
        title: l10n.coreGalleryHomeNextAccrual,
        value: _Sample.accrual,
        unit: l10n.coreBalanceRingCenter,
        detail: l10n.coreGalleryHomeNextAccrualDetail,
      ),
      StatCard(
        tint: AppTint.orange,
        icon: LucideIcons.flag,
        title: l10n.coreGalleryHomeNextHoliday,
        value: _Sample.holiday,
        unit: l10n.coreBalanceRingCenter,
        detail: l10n.coreGalleryHomeNextHolidayDetail,
      ),
    ];
    return Scaffold(
      extendBody: true,
      body: LargeTitlePage(
        overline: AppFormat.longDate(DateTime(2026, 11, 20), locale),
        title: l10n.coreGalleryHomeTitle,
        children: [
          BigNumberCard(
            title: l10n.coreGalleryHomeRemaining,
            icon: LucideIcons.treePalm,
            value: '18',
            unit: l10n.coreGalleryHomeDaysUnit,
            caption: l10n.coreGalleryBigNumberCaption,
            trailing: const BalanceRing(remaining: 18, used: 14, planned: 4),
            footer: const BalanceLegend(remaining: 18, used: 14, planned: 4),
            actionLabel: l10n.coreGalleryHowCalculated,
            onAction: () {},
          ),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(
            label: l10n.coreGalleryAddLeave,
            icon: LucideIcons.plus,
            onPressed: () {},
          ),
          const SizedBox(height: AppSpacing.md),
          if (stack) ...[
            cards[0],
            const SizedBox(height: AppSpacing.smd),
            cards[1],
          ] else
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: cards[0]),
                  const SizedBox(width: AppSpacing.smd),
                  Expanded(child: cards[1]),
                ],
              ),
            ),
          const SizedBox(height: AppSpacing.smd),
          InsetCard(
            header: CardHeader(
              tint: AppTint.blue,
              icon: LucideIcons.bridge,
              title: l10n.coreGalleryHomeBridgeTitle,
              chevron: true,
            ),
            summary: Text(
              l10n.coreGalleryHomeBridgeCaption,
              style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            onTap: () {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WeekStrip(days: GallerySamples.homeBridgeDays),
                const SizedBox(height: AppSpacing.smd),
                const LegendRow(
                  meanings: [
                    Meaning.bridge,
                    Meaning.holiday,
                    Meaning.eve,
                    Meaning.weekend,
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppTabBar(
        selectedIndex: 0,
        onSelected: (_) {},
        destinations: [
          AppTabDestination(icon: LucideIcons.house, label: l10n.navHome),
          AppTabDestination(
            icon: LucideIcons.listChecks,
            label: l10n.navLeaves,
          ),
          AppTabDestination(
            icon: LucideIcons.calendarDays,
            label: l10n.navCalendar,
          ),
          AppTabDestination(icon: LucideIcons.treePalm, label: l10n.navBridge),
          AppTabDestination(
            icon: LucideIcons.settings,
            label: l10n.navSettings,
          ),
        ],
      ),
    );
  }
}

/// Sample numbers of the example.
abstract final class _Sample {
  /// Days until the next accrual, 14 April 2027.
  static const accrual = '145';

  /// Days until the next holiday, 1 January 2027.
  static const holiday = '42';
}
