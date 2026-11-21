import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_planla/ui/stats/view_models/stats_content.dart';
import 'package:material_ui/material_ui.dart';

/// What the statistics screen shows.
@immutable
class StatsState {
  /// Creates the state.
  const new({required this.content});

  /// Statistics, loading or failed.
  final AsyncValue<StatsContent> content;
}
