import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State and actions of the people screen. Built by task 11.
final peopleViewModelProvider = NotifierProvider<PeopleViewModel, void>(
  PeopleViewModel.new,
);

/// View model of the people screen. The screen only reads its state
/// and calls its methods, business rules stay in the domain layer.
class PeopleViewModel extends Notifier<void> {
  @override
  void build() {}
}
