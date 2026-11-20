import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State and actions of the calculation explanation screen. Built by task 11.
final explainViewModelProvider = NotifierProvider<ExplainViewModel, void>(
  ExplainViewModel.new,
);

/// View model of the calculation explanation screen. The screen only reads
/// its state and calls its methods, business rules stay in the domain layer.
class ExplainViewModel extends Notifier<void> {
  @override
  void build() {}
}
