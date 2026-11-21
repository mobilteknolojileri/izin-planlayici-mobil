import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_planla/ui/settings/view_models/settings_content.dart';
import 'package:material_ui/material_ui.dart';

/// What the settings screen shows.
@immutable
class SettingsState {
  /// Creates the state.
  const new({required this.content});

  /// Settings and people, loading or failed.
  final AsyncValue<SettingsContent> content;
}
