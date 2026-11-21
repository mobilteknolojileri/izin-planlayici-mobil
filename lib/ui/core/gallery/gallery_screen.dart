import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/core/gallery/gallery_samples.dart';
import 'package:izin_planla/ui/core/gallery/home_example_screen.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/core/theme/app_theme.dart';
import 'package:izin_planla/ui/core/theme/color_groups.dart';
import 'package:izin_planla/ui/core/theme/meaning.dart';
import 'package:izin_planla/ui/core/widgets/app_illustration.dart';
import 'package:izin_planla/ui/core/widgets/balance_ring.dart';
import 'package:izin_planla/ui/core/widgets/big_number_card.dart';
import 'package:izin_planla/ui/core/widgets/day_breakdown_list.dart';
import 'package:izin_planla/ui/core/widgets/empty_state.dart';
import 'package:izin_planla/ui/core/widgets/illustration.dart';
import 'package:izin_planla/ui/core/widgets/info_tip.dart';
import 'package:izin_planla/ui/core/widgets/inset_card.dart';
import 'package:izin_planla/ui/core/widgets/legend_row.dart';
import 'package:izin_planla/ui/core/widgets/primary_button.dart';
import 'package:izin_planla/ui/core/widgets/secondary_button.dart';
import 'package:izin_planla/ui/core/widgets/stat_card.dart';
import 'package:izin_planla/ui/core/widgets/step_scaffold.dart';
import 'package:izin_planla/ui/core/widgets/undo_snack_bar.dart';
import 'package:izin_planla/ui/core/widgets/week_strip.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

/// Every shared component in the light or dark theme. Debug builds only,
/// opened with `--dart-define=START_ROUTE=/gallery`.
///
/// Section titles are component names, not user-facing text.
class GalleryScreen extends StatefulWidget {
  /// Creates the gallery.
  const new({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  bool _dark = false;

  @override
  Widget build(BuildContext context) => Theme(
    data: _dark ? AppTheme.dark : AppTheme.light,
    child: Builder(builder: _buildPage),
  );

  Widget _buildPage(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    void noop() {}
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
        actions: [
          Switch(
            value: _dark,
            onChanged: (value) => setState(() => _dark = value),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const _Section('Home example'),
          OutlinedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => HomeExampleScreen(dark: _dark),
              ),
            ),
            child: const Text('Open home example'),
          ),
          const _Section('BigNumberCard, BalanceRing, BalanceLegend'),
          BigNumberCard(
            title: l10n.coreGalleryHomeRemaining,
            icon: LucideIcons.treePalm,
            value: '18',
            unit: l10n.coreGalleryHomeDaysUnit,
            caption: l10n.coreGalleryBigNumberCaption,
            trailing: const BalanceRing(remaining: 18, used: 14, planned: 4),
            footer: const BalanceLegend(remaining: 18, used: 14, planned: 4),
            actionLabel: l10n.coreGalleryHowCalculated,
            onAction: noop,
          ),
          const _Section('StatCard'),
          StatCard(
            tint: AppTint.orange,
            icon: LucideIcons.flag,
            title: l10n.coreGalleryHomeNextHoliday,
            value: '42',
            unit: l10n.coreBalanceRingCenter,
            detail: l10n.coreGalleryHomeNextHolidayDetail,
          ),
          const _Section('InsetCard, CardHeader'),
          InsetCard(
            header: CardHeader(
              tint: AppTint.blue,
              icon: LucideIcons.bridge,
              title: l10n.coreGalleryHomeBridgeTitle,
              chevron: true,
            ),
            summary: Text(l10n.coreGalleryBridgeCaption),
            onTap: noop,
            child: WeekStrip(days: GallerySamples.bridgeDays),
          ),
          const _Section('WeekStrip'),
          WeekStrip(days: GallerySamples.bridgeDays),
          const SizedBox(height: AppSpacing.sm),
          Text(l10n.coreGalleryBridgeCaption),
          const _Section('LegendRow'),
          const LegendRow(meanings: Meaning.values),
          const _Section('DayBreakdownList'),
          InsetCard(child: DayBreakdownList(days: GallerySamples.breakdown)),
          const _Section('InfoTip'),
          Row(
            children: [
              Text(l10n.coreGalleryInfoTerm),
              InfoTip(
                term: l10n.coreGalleryInfoTerm,
                message: l10n.coreGalleryInfoMessage,
              ),
            ],
          ),
          const _Section('PrimaryButton, SecondaryButton'),
          PrimaryButton(
            label: l10n.coreGalleryAddLeave,
            icon: LucideIcons.plus,
            onPressed: noop,
          ),
          const SizedBox(height: AppSpacing.sm),
          SecondaryButton(label: l10n.coreGalleryCancel, onPressed: noop),
          const _Section('UndoSnackBar'),
          Builder(
            builder: (context) => SecondaryButton(
              label: l10n.coreUndo,
              onPressed: () => UndoSnackBar.show(
                context,
                message: l10n.coreGalleryUndoMessage,
                onUndo: noop,
              ),
            ),
          ),
          const _Section('EmptyState'),
          SizedBox(
            height: 420,
            child: EmptyState(
              illustration: Illustration.leavesEmpty,
              message: l10n.coreGalleryEmptyMessage,
              actionLabel: l10n.coreGalleryAddLeave,
              onAction: noop,
            ),
          ),
          const _Section('StepScaffold'),
          SizedBox(
            height: 640,
            child: StepScaffold(
              step: 2,
              stepCount: 4,
              question: l10n.coreGalleryStepQuestion,
              reason: l10n.coreGalleryStepReason,
              nextLabel: l10n.coreGalleryNext,
              onNext: noop,
              onBack: noop,
              illustration: Illustration.onboardingStartDate,
              child: const SizedBox(),
            ),
          ),
          const _Section('Illustration'),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: [
              for (final illustration in Illustration.values)
                AppIllustration(illustration, height: 100),
            ],
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const new(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.sm),
    child: Text(title, style: Theme.of(context).textTheme.titleMedium),
  );
}
