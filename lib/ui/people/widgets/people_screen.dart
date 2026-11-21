import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/core/app_format.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/core/widgets/empty_state.dart';
import 'package:izin_planla/ui/core/widgets/illustration.dart';
import 'package:izin_planla/ui/core/widgets/inset_card.dart';
import 'package:izin_planla/ui/core/widgets/primary_button.dart';
import 'package:izin_planla/ui/people/view_models/people_state.dart';
import 'package:izin_planla/ui/people/view_models/people_view_model.dart';
import 'package:izin_planla/ui/people/widgets/people_form_page.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

/// Everyone whose leave is tracked. Tapping a person makes them the one on
/// the home screen, the pencil edits them and "Kişi ekle" adds someone.
class PeopleScreen extends ConsumerWidget {
  /// Creates the screen.
  const new({super.key});

  static void _openForm(
    BuildContext context,
    DateTime today, {
    Profile? profile,
  }) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => PeopleFormPage(today: today, profile: profile),
    ),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(peopleViewModelProvider);
    final viewModel = ref.read(peopleViewModelProvider.notifier);
    final ready = state is PeopleReady ? state : null;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.peopleTitle)),
      body: switch (state) {
        PeopleLoading() => Center(
          child: CircularProgressIndicator(semanticsLabel: l10n.peopleLoading),
        ),
        PeopleError() => ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            InsetCard(
              summary: Text(l10n.peopleErrorMessage),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton(
                  onPressed: viewModel.retry,
                  child: Text(l10n.peopleRetry),
                ),
              ),
            ),
          ],
        ),
        PeopleReady(:final profiles, :final today) when profiles.isEmpty =>
          SafeArea(
            child: EmptyState(
              illustration: Illustration.peopleEmpty,
              message: l10n.peopleEmptyMessage,
              actionLabel: l10n.peopleAdd,
              onAction: () => _openForm(context, today),
            ),
          ),
        final PeopleReady ready => _List(
          state: ready,
          onSelect: (profile) => unawaited(viewModel.select(profile.id)),
          onEdit: (profile) =>
              _openForm(context, ready.today, profile: profile),
        ),
      },
      bottomNavigationBar: ready == null || ready.profiles.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: PrimaryButton(
                  label: l10n.peopleAdd,
                  icon: LucideIcons.userPlus,
                  onPressed: () => _openForm(context, ready.today),
                ),
              ),
            ),
    );
  }
}

class _List extends StatelessWidget {
  const new({
    required this.state,
    required this.onSelect,
    required this.onEdit,
  });

  final PeopleReady state;
  final ValueChanged<Profile> onSelect;
  final ValueChanged<Profile> onEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final secondary = theme.textTheme.bodyMedium?.copyWith(
      color: scheme.onSurfaceVariant,
    );
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Text(l10n.peopleSelectHint, style: secondary),
        const SizedBox(height: AppSpacing.sm),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (final (index, profile) in state.profiles.indexed) ...[
                if (index > 0) const Divider(indent: AppSpacing.md),
                Semantics(
                  inMutuallyExclusiveGroup: true,
                  child: ListTile(
                    contentPadding: const EdgeInsetsDirectional.only(
                      start: AppSpacing.md,
                      end: AppSpacing.xs,
                      top: AppSpacing.xs,
                      bottom: AppSpacing.xs,
                    ),
                    selected: profile.id == state.activeId,
                    selectedColor: scheme.primary,
                    leading: Icon(
                      profile.id == state.activeId
                          ? LucideIcons.circleCheck
                          : LucideIcons.circle,
                      color: profile.id == state.activeId
                          ? scheme.primary
                          : scheme.outline,
                    ),
                    title: Text(profile.name),
                    subtitle: Text(
                      [
                        if (profile.id == state.activeId) l10n.peopleSelected,
                        if (profile.employmentType == EmploymentType.laborLaw)
                          l10n.peopleLabor
                        else
                          l10n.peopleCivil,
                        AppFormat.longDate(profile.employmentStartDate, locale),
                      ].join('\n'),
                    ),
                    trailing: IconButton(
                      icon: const Icon(LucideIcons.pencil),
                      tooltip: l10n.peopleEditTooltip(profile.name),
                      onPressed: () => onEdit(profile),
                    ),
                    onTap: () => onSelect(profile),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(l10n.peopleHint, style: secondary),
      ],
    );
  }
}
