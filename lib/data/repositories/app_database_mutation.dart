import 'package:izin_planla/data/database/app_database.dart';
import 'package:izin_planla/data/repositories/storage_exception.dart';
import 'package:izin_planla/utils/result.dart';

/// The single write path of the repositories: one transaction per mutation.
extension AppDatabaseMutation on AppDatabase {
  /// Runs [body] in one transaction and reports the outcome as a [Result].
  ///
  /// A database failure rolls back every statement of [body] and becomes a
  /// [StorageException]. Errors (bugs) are not caught. Watch streams emit the
  /// new state only after the commit.
  Future<Result<void>> mutate(Future<void> Function() body) async {
    try {
      await transaction(body);
      return const Result.ok(null);
    } on Exception catch (error, stackTrace) {
      return Result.error(StorageException.fromDatabase(error, stackTrace));
    }
  }
}
