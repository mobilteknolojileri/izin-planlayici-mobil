/// Thin seam over the `home_widget` plugin, so the service can be tested
/// without a platform channel.
abstract interface class HomeWidgetGateway {
  /// Stores [value] under [key] in the storage the Android widget reads.
  Future<void> save(String key, String value);

  /// Asks the Android widget to redraw from the stored values.
  Future<void> update();

  /// Opens the launcher's widget pin dialog when the launcher supports it,
  /// otherwise does nothing.
  Future<void> requestPin();
}
