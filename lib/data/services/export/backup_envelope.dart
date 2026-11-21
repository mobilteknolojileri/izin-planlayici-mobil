/// The validated header and payload of a backup file.
///
/// Built only by `BackupEnvelopeCodec.read`, so an instance always passed the
/// version and checksum checks.
class BackupEnvelope {
  /// Creates an envelope.
  const new({
    required this.formatVersion,
    required this.schemaVersion,
    required this.appVersion,
    required this.exportedAtUtc,
    required this.payloadSha256,
    required this.payloadJson,
  });

  /// Version of the envelope shape itself.
  final int formatVersion;

  /// Database schema version the payload was written from.
  final int schemaVersion;

  /// App version that wrote the file, e.g. `1.0.0+1`.
  final String appVersion;

  /// When the backup was made, in UTC.
  final DateTime exportedAtUtc;

  /// Lowercase hex SHA-256 of the UTF-8 bytes of [payloadJson].
  final String payloadSha256;

  /// The `BackupCodec` document as compact JSON, ready for `restoreJson`.
  final String payloadJson;
}
