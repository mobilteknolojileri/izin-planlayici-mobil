import 'package:drift/drift.dart';
import 'package:izin_planla/data/database/app_database.dart';
import 'package:izin_planla/data/database/mappers/leave_record_mapper.dart';
import 'package:izin_planla/data/repositories/app_database_mutation.dart';
import 'package:izin_planla/data/repositories/leave_repository.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/utils/result.dart';

/// [LeaveRepository] stored in the drift [AppDatabase].
///
/// Records are listed by start date, then end date, then save order.
final class DriftLeaveRepository implements LeaveRepository {
  /// Creates a repository on the app's [AppDatabase].
  const new(this._database);

  final AppDatabase _database;

  @override
  Stream<List<LeaveRecord>> watchForProfile(String profileId) {
    final query = _database.select(_database.leaveRecords)
      ..where((record) => record.profileId.equals(profileId))
      ..orderBy([
        (record) => OrderingTerm.asc(record.startDate),
        (record) => OrderingTerm.asc(record.endDate),
        (record) => OrderingTerm.asc(record.rowId),
      ]);
    return query.watch().map(
      (rows) => [for (final row in rows) LeaveRecordMapper.toModel(row)],
    );
  }

  /// Adds or replaces [record]. Fails with a `StorageException` when its
  /// profile does not exist or a field breaks a schema rule.
  @override
  Future<Result<void>> save(LeaveRecord record) => _database.mutate(
    () => _database
        .into(_database.leaveRecords)
        // A companion writes NULL for a cleared field. A plain row would
        // leave the old value in place when the id already exists.
        .insertOnConflictUpdate(
          LeaveRecordMapper.toRow(record).toCompanion(false),
        ),
  );

  @override
  Future<Result<void>> delete(String id) => _database.mutate(
    () => (_database.delete(
      _database.leaveRecords,
    )..where((record) => record.id.equals(id))).go(),
  );
}
