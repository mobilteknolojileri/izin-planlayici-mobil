/// Why a backup could not be restored, as the screen explains it.
enum SettingsRestoreFailure {
  /// The file comes from a newer app version.
  newer,

  /// The file is not a valid backup.
  invalid,

  /// Anything else, such as a storage error.
  other,
}
