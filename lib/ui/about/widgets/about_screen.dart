import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// About screen. Built by task 11, empty until then.
class AboutScreen extends StatelessWidget {
  /// Creates the screen.
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.aboutTitle)),
      body: const SizedBox.shrink(),
    );
  }
}
