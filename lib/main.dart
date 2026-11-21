import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:izin_planla/app.dart';
import 'package:izin_planla/config/dependencies.dart';
import 'package:izin_planla/data/services/app_info/installed_version.dart';
import 'package:izin_planla/routing/routes.dart';
import 'package:izin_planla/routing/start_route.dart';
import 'package:izin_planla/ui/core/theme/app_typography.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:material_ui/material_ui.dart';

/// Starts the app with Turkish date formatting, the font licence, the glass
/// shaders, the installed version and the notification plugin ready.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr');
  AppTypography.registerLicense();
  // Loads the glass shaders before the first frame, so the tab bar does
  // not flash.
  await LiquidGlassWidgets.initialize();
  final container = ProviderContainer(
    overrides: [
      appVersionProvider.overrideWithValue(await readInstalledVersion()),
    ],
  );
  // A first run opens the setup instead of an empty home page.
  final profiles = await container
      .read(profileRepositoryProvider)
      .watchAll()
      .first;
  if (profiles.isEmpty) {
    container.read(startRouteProvider.notifier).route = Routes.onboarding;
  }
  // Prepares the plugin and time zones only. The permission is asked when
  // the user turns a reminder on, and errors are logged, not thrown.
  await container.read(notificationServiceProvider).initialize();
  runApp(
    LiquidGlassWidgets.wrap(
      // The glass follows the app's theme mode, not the system's.
      brightnessResolver: Theme.maybeBrightnessOf,
      child: UncontrolledProviderScope(
        container: container,
        child: const App(),
      ),
    ),
  );
}
