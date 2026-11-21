import 'package:izin_planla/data/repositories/backup_codec.dart';
import 'package:izin_planla/utils/result.dart';

/// [BackupCodec] that keeps one JSON document in memory.
class StubBackupCodec implements BackupCodec {
  /// Creates a codec holding [document].
  new(this.document);

  /// The stored document, replaced by [restoreJson].
  String document;

  /// When set, [exportJson] fails with this error.
  Exception? exportError;

  /// Number of [restoreJson] calls.
  int restores = 0;

  @override
  Future<Result<String>> exportJson() async {
    final error = exportError;
    return error == null ? Result.ok(document) : Result.error(error);
  }

  @override
  Future<Result<void>> restoreJson(String json) async {
    restores++;
    document = json;
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> resetAll() async {
    document = '{}';
    return const Result.ok(null);
  }
}
