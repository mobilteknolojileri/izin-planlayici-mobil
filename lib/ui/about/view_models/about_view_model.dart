import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State and actions of the about screen. Built by task 11.
final aboutViewModelProvider = NotifierProvider<AboutViewModel, void>(
  AboutViewModel.new,
);

/// View model of the about screen. The screen only reads its state
/// and calls its methods, business rules stay in the domain layer.
class AboutViewModel extends Notifier<void> {
  @override
  void build() {}
}
