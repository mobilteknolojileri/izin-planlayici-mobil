import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

/// Onboarding screen. Built by task 11, empty until then.
class OnboardingScreen extends StatelessWidget {
  /// Creates the screen.
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.onboardingTitle)),
      body: const SizedBox.shrink(),
    );
  }
}
