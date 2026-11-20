import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State and actions of the legislation guide screen. Built by task 11.
final guideViewModelProvider = NotifierProvider<GuideViewModel, void>(
  GuideViewModel.new,
);

/// View model of the legislation guide screen. The screen only reads its state
/// and calls its methods, business rules stay in the domain layer.
class GuideViewModel extends Notifier<void> {
  @override
  void build() {}
}
