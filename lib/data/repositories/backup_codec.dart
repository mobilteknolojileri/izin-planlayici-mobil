import 'package:izin_planla/utils/result.dart';

/// Exports, restores and resets all user data. Implemented by task 10.
abstract interface class BackupCodec {
  /// All data as one versioned JSON document.
  Future<Result<String>> exportJson();

  /// Replaces all data with [json] in one transaction. Fails without
  /// changing anything when [json] is invalid or from a newer app version.
  Future<Result<void>> restoreJson(String json);

  /// Deletes all user data.
  Future<Result<void>> resetAll();
}
