import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// The message after a delete or edit, with a "Geri al" action.
abstract final class UndoSnackBar {
  /// Long enough to read the message and reach the button. With TalkBack on,
  /// Flutter keeps a snack bar with an action open until it is used.
  static const duration = Duration(seconds: 8);

  /// Shows [message] and calls [onUndo] when the user taps "Geri al".
  /// Replaces a snack bar that is already visible.
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
    BuildContext context, {
    required String message,
    required VoidCallback onUndo,
  }) {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
    return messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: SnackBarAction(label: l10n.coreUndo, onPressed: onUndo),
      ),
    );
  }
}
