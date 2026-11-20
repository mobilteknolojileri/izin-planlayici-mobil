/// Updates the Android home screen widget. Implemented by task 14.
abstract interface class HomeWidgetService {
  /// Writes current values to the widget and redraws it.
  Future<void> refresh();

  /// Opens the widget picker if the launcher supports it.
  Future<void> requestPin();
}
