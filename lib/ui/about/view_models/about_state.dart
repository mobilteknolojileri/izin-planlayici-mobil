import 'package:izin_planla/ui/about/view_models/about_link.dart';
import 'package:material_ui/material_ui.dart';

/// What the about screen shows.
@immutable
class AboutState {
  /// Creates the state.
  const new({required this.version});

  /// App version, such as `1.0.0`.
  final String version;

  /// Legislation sources, in the order they are listed.
  List<AboutLink> get sources => const [
    AboutLink.labor,
    AboutLink.regulation,
    AboutLink.civil,
    AboutLink.holidays,
  ];
}
