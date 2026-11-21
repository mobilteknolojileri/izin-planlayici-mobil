import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_planla/ui/bridge/view_models/bridge_content.dart';
import 'package:izin_planla/ui/bridge/view_models/bridge_sort.dart';
import 'package:material_ui/material_ui.dart';

/// What the bridge screen shows.
@immutable
class BridgeState {
  /// Creates the state.
  const new({required this.content, required this.sort});

  /// Suggestions for the chosen year, loading or failed.
  final AsyncValue<BridgeContent> content;

  /// Order of the suggestion list.
  final BridgeSort sort;
}
