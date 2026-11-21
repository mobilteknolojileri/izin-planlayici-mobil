import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:izin_planla/data/services/export/app_version.dart';
import 'package:izin_planla/data/services/export/backup_envelope.dart';
import 'package:izin_planla/data/services/export/export_failure.dart';
import 'package:izin_planla/data/services/export/export_failure_reason.dart';
import 'package:izin_planla/utils/result.dart';

/// Wraps the `BackupCodec` document in a versioned, checksummed envelope and
/// validates it again on restore.
///
/// The file is one JSON object whose header comes first:
/// `format`, `formatVersion`, `schemaVersion`, `appVersion`,
/// `exportedAtUtc`, `payloadSha256`, then `payload`. The checksum covers the
/// compact JSON encoding of `payload`, so whitespace changes do not matter
/// but any changed value does.
class BackupEnvelopeCodec {
  /// Creates a codec for the running app.
  ///
  /// [appVersion] is the pubspec version, e.g. `1.0.0+1`, written into each
  /// backup for support only. [schemaVersion] is the database schema version
  /// of this build. Throws [ArgumentError] when [appVersion] cannot be
  /// parsed, a programming error.
  new({required String appVersion, required this.schemaVersion})
    : _appVersionText = AppVersion.tryParse(appVersion) == null
          ? throw ArgumentError.value(appVersion, 'appVersion')
          : appVersion;

  /// Marks the file as an İzin Planla backup.
  static const formatMarker = 'izin-planla-backup';

  /// Envelope shape version written by this build.
  static const formatVersion = 1;

  /// Largest file [read] accepts. Real backups are far smaller.
  static const int maxBytes = 16 * 1024 * 1024;

  /// MIME type of a backup file.
  static const mimeType = 'application/json';

  /// Database schema version of this build.
  final int schemaVersion;

  final String _appVersionText;

  static final _sha256Pattern = RegExp(r'^[0-9a-f]{64}$');

  /// Wraps [payloadJson] made at [exportedAt].
  ///
  /// Throws [FormatException] when [payloadJson] is not JSON.
  Uint8List wrap(String payloadJson, {required DateTime exportedAt}) {
    final payload = jsonDecode(payloadJson);
    final canonical = jsonEncode(payload);
    final envelope = <String, Object?>{
      'format': formatMarker,
      'formatVersion': formatVersion,
      'schemaVersion': schemaVersion,
      'appVersion': _appVersionText,
      'exportedAtUtc': exportedAt.toUtc().toIso8601String(),
      'payloadSha256': sha256Hex(canonical),
      'payload': payload,
    };
    return utf8.encode(jsonEncode(envelope));
  }

  /// Validates [bytes] and returns the envelope.
  ///
  /// Fails with [ExportFailureReason.tooLarge], `notBackup`, `newerVersion`,
  /// `invalidBackup` or `checksumMismatch`, checked in that order, so a file
  /// in a newer format or schema is refused before its content is trusted.
  ///
  /// Only `formatVersion` and `schemaVersion` decide compatibility. The
  /// `appVersion` must be well formed but is provenance only, so a backup
  /// from a newer app with the same format and schema restores.
  Result<BackupEnvelope> read(Uint8List bytes) {
    if (bytes.length > maxBytes) return _fail(ExportFailureReason.tooLarge);

    final Object? decoded;
    try {
      var text = utf8.decode(bytes);
      if (text.isNotEmpty && text.codeUnitAt(0) == 0xFEFF) {
        text = text.substring(1);
      }
      decoded = jsonDecode(text);
    } on FormatException catch (error) {
      return _fail(ExportFailureReason.notBackup, error);
    }
    if (decoded is! Map<String, dynamic> || decoded['format'] != formatMarker) {
      return _fail(ExportFailureReason.notBackup);
    }

    final format = decoded['formatVersion'];
    final schema = decoded['schemaVersion'];
    if (format is! int || format < 1 || schema is! int || schema < 1) {
      return _fail(ExportFailureReason.invalidBackup, 'version');
    }
    if (format > formatVersion || schema > schemaVersion) {
      return _fail(
        ExportFailureReason.newerVersion,
        'format $format, schema $schema',
      );
    }
    // Provenance only: the shape is checked, the value never refuses a file.
    final appText = decoded['appVersion'];
    if (appText is! String || AppVersion.tryParse(appText) == null) {
      return _fail(ExportFailureReason.invalidBackup, 'appVersion');
    }

    final exportedText = decoded['exportedAtUtc'];
    final exportedAt = exportedText is String
        ? DateTime.tryParse(exportedText)
        : null;
    if (exportedAt == null || !exportedAt.isUtc) {
      return _fail(ExportFailureReason.invalidBackup, 'exportedAtUtc');
    }
    final checksum = decoded['payloadSha256'];
    if (checksum is! String || !_sha256Pattern.hasMatch(checksum)) {
      return _fail(ExportFailureReason.invalidBackup, 'payloadSha256');
    }
    final payload = decoded['payload'];
    if (payload == null) {
      return _fail(ExportFailureReason.invalidBackup, 'payload');
    }

    final canonical = jsonEncode(payload);
    if (sha256Hex(canonical) != checksum) {
      return _fail(ExportFailureReason.checksumMismatch);
    }
    return Result.ok(
      BackupEnvelope(
        formatVersion: format,
        schemaVersion: schema,
        appVersion: appText,
        exportedAtUtc: exportedAt,
        payloadSha256: checksum,
        payloadJson: canonical,
      ),
    );
  }

  /// Lowercase hex SHA-256 of the UTF-8 bytes of [text].
  static String sha256Hex(String text) {
    final digest = Sha256.of(utf8.encode(text));
    final buffer = StringBuffer();
    for (final byte in digest) {
      buffer.write(byte.toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString();
  }

  static Result<BackupEnvelope> _fail(
    ExportFailureReason reason, [
    Object? cause,
  ]) => Result.error(ExportFailure(reason, cause: cause));
}
