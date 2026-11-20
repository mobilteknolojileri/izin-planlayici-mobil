import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State and actions of the leave form screen. Built by task 11.
final leaveFormViewModelProvider = NotifierProvider<LeaveFormViewModel, void>(
  LeaveFormViewModel.new,
);

/// View model of the leave form screen. The screen only reads its state
/// and calls its methods, business rules stay in the domain layer.
class LeaveFormViewModel extends Notifier<void> {
  @override
  void build() {}
}
