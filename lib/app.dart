import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_planla/config/dependencies.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/routing/router.dart';
import 'package:izin_planla/routing/routes.dart';
import 'package:izin_planla/ui/core/theme/app_theme.dart';
import 'package:material_ui/material_ui.dart';

/// Current app settings, used for the theme mode.
final appSettingsProvider = StreamProvider<AppSettings>(
  (ref) => ref.watch(settingsRepositoryProvider).watch(),
);

/// Root widget: theme, Turkish locale and router. It also keeps the
/// reminders and the home screen widget in step with the data.
class App extends ConsumerStatefulWidget {
  /// Creates the app.
  const new({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  late final AppLifecycleListener _lifecycle;
  StreamSubscription<void>? _widgetTaps;

  @override
  void initState() {
    super.initState();
    // A day may have passed while the app was in the background.
    _lifecycle = AppLifecycleListener(
      onResume: () => ref.read(notificationSyncProvider).refresh(),
    );
    // A tap on the home screen widget only brings a running app to the
    // front, so it is sent to the home page here.
    _widgetTaps = ref
        .read(homeWidgetClicksProvider)
        .listen((_) => ref.read(routerProvider).go(Routes.home));
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    unawaited(_widgetTaps?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Both start their data listeners when first read.
    ref
      ..watch(notificationSyncProvider)
      ..watch(homeWidgetServiceProvider);
    final themeMode = switch (ref.watch(appSettingsProvider).value?.themeMode) {
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
      AppThemeMode.system || null => ThemeMode.system,
    };
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: const Locale('tr'),
      supportedLocales: AppLocalizations.supportedLocales,
      // Material, Cupertino and widgets strings come from material_ui.
      // AppLocalizations.localizationsDelegates is not used because it
      // contains the deprecated flutter_localizations Material delegate.
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      // table_calendar, fl_chart and printing still import the deprecated
      // package:flutter/material.dart. The bridge gives them our theme and
      // localizations. Remove it once they migrate to material_ui.
      builder: (context, child) =>
          // The bridge is deprecated only because it is a temporary migration
          // utility, see the comment above.
          // ignore: deprecated_member_use
          MaterialUiCompatibilityBridge(child: child ?? const SizedBox()),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
