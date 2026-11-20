import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State and actions of the bridge planner screen. Built by task 11.
final bridgeViewModelProvider = NotifierProvider<BridgeViewModel, void>(
  BridgeViewModel.new,
);

/// View model of the bridge planner screen. The screen only reads its state
/// and calls its methods, business rules stay in the domain layer.
class BridgeViewModel extends Notifier<void> {
  @override
  void build() {}
}
