/// Opens web links outside the app.
abstract interface class LinkOpener {
  /// Opens [url] in the phone's browser. Returns whether it opened, false
  /// when no app can open it, so the caller can offer to copy it instead.
  Future<bool> open(String url);
}
