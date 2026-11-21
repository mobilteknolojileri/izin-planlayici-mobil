import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:material_ui/material_ui.dart';

/// Asks the user to type the confirm word before every piece of data is
/// deleted, because one stray tap must not wipe everything.
///
/// Pops `true` once the word is typed and "Sil" is pressed.
class ResetConfirmDialog extends StatefulWidget {
  /// Creates the dialog.
  const new({super.key});

  /// Whether [text] is the confirm [word]. Case and the Turkish dotted
  /// capital İ do not matter, so "sil", "Sil" and "SİL" all match.
  static bool matches(String text, String word) =>
      _normalize(text) == _normalize(word);

  static String _normalize(String text) =>
      text.trim().replaceAll('İ', 'i').toLowerCase();

  @override
  State<ResetConfirmDialog> createState() => _ResetConfirmDialogState();
}

class _ResetConfirmDialogState extends State<ResetConfirmDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final confirmed = ResetConfirmDialog.matches(
      _controller.text,
      l10n.settingsResetWord,
    );
    void confirm() => Navigator.of(context).pop(true);
    return AlertDialog(
      scrollable: true,
      title: Text(l10n.settingsResetConfirmTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.settingsResetConfirmBody),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _controller,
            autofocus: true,
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(labelText: l10n.settingsResetTypeLabel),
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) {
              if (confirmed) confirm();
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.settingsCancel),
        ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: scheme.error),
          // Stays off until the word is typed.
          onPressed: confirmed ? confirm : null,
          child: Text(l10n.settingsResetConfirm),
        ),
      ],
    );
  }
}
