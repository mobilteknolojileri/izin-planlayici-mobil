import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/routing/routes.dart';
import 'package:izin_planla/ui/about/view_models/about_link.dart';
import 'package:izin_planla/ui/about/view_models/about_view_model.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/core/theme/color_groups.dart';
import 'package:izin_planla/ui/core/widgets/inset_card.dart';
import 'package:izin_planla/ui/core/widgets/link_button.dart';
import 'package:izin_planla/ui/core/widgets/secondary_button.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

/// About: version, privacy, legislation sources, the GPL-3.0 licence with
/// the source code link, the package licences and the legal disclaimer.
class AboutScreen extends ConsumerWidget {
  /// Creates the screen.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(aboutViewModelProvider);
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final secondary = text.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final padding = MediaQuery.paddingOf(context);
    final sourceNames = {
      AboutLink.labor: l10n.aboutSourceLabor,
      AboutLink.regulation: l10n.aboutSourceRegulation,
      AboutLink.civil: l10n.aboutSourceCivil,
      AboutLink.holidays: l10n.aboutSourceHolidays,
    };
    Widget header(AppTint tint, IconData icon, String title) => Semantics(
      header: true,
      child: CardHeader(tint: tint, icon: icon, title: title),
    );
    return Scaffold(
      appBar: AppBar(title: Text(l10n.aboutTitle)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.lg + padding.bottom,
        ),
        children: [
          InsetCard(
            summary: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.appTitle, style: text.headlineSmall),
                Text(l10n.aboutVersion(state.version), style: secondary),
                const SizedBox(height: AppSpacing.sm),
                Text(l10n.aboutDescription, style: text.bodyLarge),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.smd),
          InsetCard(
            header: header(
              AppTint.green,
              LucideIcons.shieldCheck,
              l10n.aboutPrivacyTitle,
            ),
            summary: Text(l10n.aboutPrivacyBody, style: text.bodyLarge),
            child: _LinkRow(
              name: l10n.aboutPrivacyPolicy,
              link: AboutLink.privacyPolicy,
            ),
          ),
          const SizedBox(height: AppSpacing.smd),
          InsetCard(
            header: header(
              AppTint.purple,
              LucideIcons.bookOpen,
              l10n.aboutSourcesTitle,
            ),
            summary: Text(l10n.aboutSourcesBody, style: text.bodyLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final source in state.sources)
                  _LinkRow(name: sourceNames[source]!, link: source),
                const SizedBox(height: AppSpacing.sm),
                SecondaryButton(
                  label: l10n.aboutOpenGuide,
                  icon: LucideIcons.bookOpen,
                  onPressed: () => context.push<void>(Routes.guide).ignore(),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.smd),
          InsetCard(
            header: header(
              AppTint.blue,
              LucideIcons.code,
              l10n.aboutLicenseTitle,
            ),
            summary: Text(l10n.aboutLicenseBody, style: text.bodyLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _LinkRow(
                  name: l10n.aboutSourceCode,
                  link: AboutLink.sourceCode,
                ),
                const SizedBox(height: AppSpacing.sm),
                SecondaryButton(
                  label: l10n.aboutPackages,
                  icon: LucideIcons.scrollText,
                  onPressed: () => showLicensePage(
                    context: context,
                    applicationName: l10n.appTitle,
                    applicationVersion: state.version,
                    applicationLegalese: l10n.aboutLegalese,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.smd),
          InsetCard(
            header: header(
              AppTint.orange,
              LucideIcons.scale,
              l10n.aboutDisclaimerTitle,
            ),
            summary: Text(l10n.aboutDisclaimer, style: text.bodyMedium),
          ),
        ],
      ),
    );
  }
}

/// A link name with a button that opens the link in the browser.
class _LinkRow extends ConsumerWidget {
  const new({required this.name, required this.link});

  final String name;
  final AboutLink link;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(child: Text(name, style: theme.textTheme.bodyLarge)),
        const SizedBox(width: AppSpacing.xs),
        LinkButton(
          name: name,
          url: link.url,
          open: ref.read(aboutViewModelProvider.notifier).openLink,
        ),
      ],
    );
  }
}
