import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State and actions of the settings screen. Built by task 11.
final settingsViewModelProvider = NotifierProvider<SettingsViewModel, void>(
  SettingsViewModel.new,
);

/// View model of the settings screen. The screen only reads its state
/// and calls its methods, business rules stay in the domain layer.
class SettingsViewModel extends Notifier<void> {
  @override
  void build() {}
}
