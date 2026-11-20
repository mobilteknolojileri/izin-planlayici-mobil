import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State and actions of the statistics screen. Built by task 11.
final statsViewModelProvider = NotifierProvider<StatsViewModel, void>(
  StatsViewModel.new,
);

/// View model of the statistics screen. The screen only reads its state
/// and calls its methods, business rules stay in the domain layer.
class StatsViewModel extends Notifier<void> {
  @override
  void build() {}
}
