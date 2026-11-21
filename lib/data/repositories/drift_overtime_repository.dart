import 'package:drift/drift.dart';
import 'package:izin_planla/data/database/app_database.dart';
import 'package:izin_planla/data/database/mappers/overtime_record_mapper.dart';
import 'package:izin_planla/data/repositories/app_database_mutation.dart';
import 'package:izin_planla/data/repositories/overtime_repository.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/utils/result.dart';

/// [OvertimeRepository] stored in the drift [AppDatabase].
///
/// Records are listed by date, then save order.
final class DriftOvertimeRepository implements OvertimeRepository {
  /// Creates a repository on the app's [AppDatabase].
  const new(this._database);

  final AppDatabase _database;

  @override
  Stream<List<OvertimeRecord>> watchForProfile(String profileId) {
    final query = _database.select(_database.overtimeRecords)
      ..where((record) => record.profileId.equals(profileId))
      ..orderBy([
        (record) => OrderingTerm.asc(record.date),
        (record) => OrderingTerm.asc(record.rowId),
      ]);
    return query.watch().map(
      (rows) => [for (final row in rows) OvertimeRecordMapper.toModel(row)],
    );
  }

  /// Adds or replaces [record]. Fails with a `StorageException` when its
  /// profile does not exist or its hours are not positive.
  @override
  Future<Result<void>> save(OvertimeRecord record) => _database.mutate(
    () => _database
        .into(_database.overtimeRecords)
        // A companion writes NULL for a cleared field. A plain row would
        // leave the old value in place when the id already exists.
        .insertOnConflictUpdate(
          OvertimeRecordMapper.toRow(record).toCompanion(false),
        ),
  );

  @override
  Future<Result<void>> delete(String id) => _database.mutate(
    () => (_database.delete(
      _database.overtimeRecords,
    )..where((record) => record.id.equals(id))).go(),
  );
}
