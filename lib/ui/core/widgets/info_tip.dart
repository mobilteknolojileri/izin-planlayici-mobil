import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

/// A "?" button next to a term. Tapping it explains the term in one
/// sentence.
class InfoTip extends StatelessWidget {
  /// Creates the button for [term].
  const new({required this.term, required this.message, super.key});

  /// The term being explained, used as the dialog title.
  final String term;

  /// One sentence in plain words.
  final String message;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return IconButton(
      icon: const Icon(LucideIcons.circleQuestionMark),
      tooltip: l10n.coreInfoTipTooltip(term),
      color: Theme.of(context).colorScheme.primary,
      onPressed: () => showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(term),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.coreOk),
            ),
          ],
        ),
      ),
    );
  }
}
