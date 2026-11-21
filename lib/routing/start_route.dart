import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_planla/routing/routes.dart';

/// Where the app opens: the home page, or the setup on a first run.
/// `main.dart` sets it before the router is created.
final startRouteProvider = NotifierProvider<StartRoute, String>(StartRoute.new);

/// Holds the first route of the app.
class StartRoute extends Notifier<String> {
  @override
  String build() => Routes.home;

  /// The route the app opens on.
  String get route => state;

  set route(String value) => state = value;
}
