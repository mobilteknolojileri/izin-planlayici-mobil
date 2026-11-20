import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State and actions of the home screen. Built by task 11.
final homeViewModelProvider = NotifierProvider<HomeViewModel, void>(
  HomeViewModel.new,
);

/// View model of the home screen. The screen only reads its state
/// and calls its methods, business rules stay in the domain layer.
class HomeViewModel extends Notifier<void> {
  @override
  void build() {}
}
