import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/core/widgets/link_button.dart';
import 'package:izin_planla/ui/guide/view_models/guide_source.dart';
import 'package:izin_planla/ui/guide/view_models/guide_view_model.dart';
import 'package:material_ui/material_ui.dart';

/// A source line with a button that opens the source in the browser.
class GuideSourceRow extends ConsumerWidget {
  /// Creates the row.
  const new({
    required this.text,
    required this.sourceName,
    required this.source,
    super.key,
  });

  /// The line shown, such as "Kaynak: 4857 sayılı İş Kanunu, madde 53".
  final String text;

  /// Name of the source, for the button's tooltip.
  final String sourceName;

  /// The source whose link is opened.
  final GuideSource source;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        LinkButton(
          name: sourceName,
          url: source.url,
          open: ref.read(guideViewModelProvider.notifier).openLink,
        ),
      ],
    );
  }
}
