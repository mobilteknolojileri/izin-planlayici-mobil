import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State and actions of the calendar screen. Built by task 11.
final calendarViewModelProvider = NotifierProvider<CalendarViewModel, void>(
  CalendarViewModel.new,
);

/// View model of the calendar screen. The screen only reads its state
/// and calls its methods, business rules stay in the domain layer.
class CalendarViewModel extends Notifier<void> {
  @override
  void build() {}
}
