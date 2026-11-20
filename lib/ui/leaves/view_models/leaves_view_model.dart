import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State and actions of the leave list screen. Built by task 11.
final leavesViewModelProvider = NotifierProvider<LeavesViewModel, void>(
  LeavesViewModel.new,
);

/// View model of the leave list screen. The screen only reads its state
/// and calls its methods, business rules stay in the domain layer.
class LeavesViewModel extends Notifier<void> {
  @override
  void build() {}
}
