import 'package:drift/drift.dart';
import 'package:izin_planla/data/database/app_database.dart';
import 'package:izin_planla/data/database/mappers/profile_mapper.dart';
import 'package:izin_planla/data/repositories/app_database_mutation.dart';
import 'package:izin_planla/data/repositories/profile_repository.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/utils/result.dart';

/// [ProfileRepository] stored in the drift [AppDatabase].
///
/// Profiles are listed in the order they were first saved. Saving an
/// existing profile keeps its place.
final class DriftProfileRepository implements ProfileRepository {
  /// Creates a repository on the app's [AppDatabase].
  const new(this._database);

  final AppDatabase _database;

  @override
  Stream<List<Profile>> watchAll() {
    final query = _database.select(_database.profiles)
      ..orderBy([(profile) => OrderingTerm.asc(profile.rowId)]);
    return query.watch().map(
      (rows) => [for (final row in rows) ProfileMapper.toModel(row)],
    );
  }

  @override
  Future<Profile?> findById(String id) async {
    final query = _database.select(_database.profiles)
      ..where((profile) => profile.id.equals(id));
    final row = await query.getSingleOrNull();
    return row == null ? null : ProfileMapper.toModel(row);
  }

  /// Adds or replaces [profile]. Fails with a `StorageException` when a
  /// field breaks a schema rule, e.g. a negative prior service.
  @override
  Future<Result<void>> save(Profile profile) => _database.mutate(
    () => _database
        .into(_database.profiles)
        // A companion writes NULL for a cleared field. A plain row would
        // leave the old value in place when the id already exists.
        .insertOnConflictUpdate(
          ProfileMapper.toRow(profile).toCompanion(false),
        ),
  );

  /// Deletes the profile with [id] with its leave and overtime records.
  ///
  /// When it was the active profile, the first remaining profile becomes
  /// active, or none when it was the last one.
  @override
  Future<Result<void>> delete(String id) => _database.mutate(() async {
    final settings = await _database
        .select(_database.settings)
        .getSingleOrNull();
    if (settings?.activeProfileId == id) {
      final nextQuery = _database.select(_database.profiles)
        ..where((profile) => profile.id.equals(id).not())
        ..orderBy([(profile) => OrderingTerm.asc(profile.rowId)])
        ..limit(1);
      final next = await nextQuery.getSingleOrNull();
      await _database
          .update(_database.settings)
          .write(SettingsCompanion(activeProfileId: Value(next?.id)));
    }
    await (_database.delete(
      _database.leaveRecords,
    )..where((record) => record.profileId.equals(id))).go();
    await (_database.delete(
      _database.overtimeRecords,
    )..where((record) => record.profileId.equals(id))).go();
    await (_database.delete(
      _database.profiles,
    )..where((profile) => profile.id.equals(id))).go();
  });
}
