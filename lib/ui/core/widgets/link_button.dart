import 'package:flutter/services.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

/// An icon button that opens [url] in the phone's browser.
///
/// When no app can open it, the link is copied instead and a message says
/// so, because the user must never be left without the source.
class LinkButton extends StatelessWidget {
  /// Creates the button. [open] comes from the screen's view model.
  const new({
    required this.name,
    required this.url,
    required this.open,
    super.key,
  });

  /// What the link points to, read in the tooltip: "[name] bağlantısını aç".
  final String name;

  /// The web address.
  final String url;

  /// Opens the address and returns whether it opened.
  final Future<bool> Function(String url) open;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return IconButton(
      tooltip: l10n.coreOpenLink(name),
      color: Theme.of(context).colorScheme.primary,
      icon: const Icon(LucideIcons.externalLink),
      onPressed: () async {
        final messenger = ScaffoldMessenger.of(context);
        if (await open(url)) return;
        await Clipboard.setData(ClipboardData(text: url));
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.coreLinkCopied)));
      },
    );
  }
}
