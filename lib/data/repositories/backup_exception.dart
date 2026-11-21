/// Why a backup file could not be restored. The existing data is unchanged.
///
/// A sealed hierarchy, so the restore screen can switch over every case.
sealed class BackupException implements Exception {
  /// Creates a backup failure.
  const new();
}

/// The file is not an İzin Planla backup, is cut off or breaks a data rule.
final class InvalidBackupException extends BackupException {
  /// Creates the failure. [reason] is for logs, not for users.
  const new(this.reason, {this.cause});

  /// What is wrong with the file, in English.
  final String reason;

  /// The underlying parse or database error, if any.
  final Object? cause;

  @override
  String toString() => 'InvalidBackupException: $reason';
}

/// The file was written by a newer app version. The user should update the
/// app before restoring it.
final class NewerBackupException extends BackupException {
  /// Creates the failure for a file in [formatVersion].
  const new(this.formatVersion, this.supportedVersion);

  /// Format version written in the file.
  final int formatVersion;

  /// Newest format version this app can read.
  final int supportedVersion;

  @override
  String toString() =>
      'NewerBackupException: format $formatVersion, '
      'this app reads up to $supportedVersion';
}
