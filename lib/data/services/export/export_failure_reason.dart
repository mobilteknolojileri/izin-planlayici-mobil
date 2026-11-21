/// Why an export, share, save or backup step failed.
///
/// The UI maps each reason to its own message, because "failed" without a
/// reason cannot be told apart from lost data.
enum ExportFailureReason {
  /// The profile to export does not exist.
  profileNotFound,

  /// Reading the data or building the file failed.
  buildFailed,

  /// The user closed the save dialog without choosing a location.
  cancelled,

  /// The share sheet could not be opened.
  shareFailed,

  /// The file could not be written to the chosen location.
  saveFailed,

  /// The file picker failed or the picked file could not be read.
  pickFailed,

  /// The backup codec could not export the data.
  backupFailed,

  /// The picked file is not an İzin Planla backup, e.g. a CSV export.
  notBackup,

  /// The backup header or payload is malformed.
  invalidBackup,

  /// The payload does not match its checksum, the file is damaged.
  checksumMismatch,

  /// The backup uses a newer backup format or database schema than this app.
  newerVersion,

  /// The picked file is larger than any backup this app writes.
  tooLarge,
}
