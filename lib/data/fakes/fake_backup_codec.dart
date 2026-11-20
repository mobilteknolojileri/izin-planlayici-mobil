import 'package:izin_planla/data/repositories/backup_codec.dart';
import 'package:izin_planla/utils/result.dart';

/// [BackupCodec] that accepts everything and stores nothing.
class FakeBackupCodec implements BackupCodec {
  @override
  Future<Result<String>> exportJson() async => const Result.ok('{}');

  @override
  Future<Result<void>> restoreJson(String json) async => const Result.ok(null);

  @override
  Future<Result<void>> resetAll() async => const Result.ok(null);
}
