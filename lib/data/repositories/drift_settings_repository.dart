import 'package:izin_planla/data/database/app_database.dart';
import 'package:izin_planla/data/database/mappers/settings_mapper.dart';
import 'package:izin_planla/data/repositories/app_database_mutation.dart';
import 'package:izin_planla/data/repositories/settings_repository.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/utils/result.dart';

/// [SettingsRepository] stored in the drift [AppDatabase].
///
/// Before the first save, and after a reset, it emits the defaults of
/// `AppSettings()`.
final class DriftSettingsRepository implements SettingsRepository {
  /// Creates a repository on the app's [AppDatabase].
  const new(this._database);

  final AppDatabase _database;

  @override
  Stream<AppSettings> watch() => _database
      .select(_database.settings)
      .watchSingleOrNull()
      .map(SettingsMapper.toModel);

  /// Replaces the settings. Fails with a `StorageException` when
  /// `activeProfileId` names a profile that does not exist.
  @override
  Future<Result<void>> save(AppSettings settings) => _database.mutate(
    () => _database
        .into(_database.settings)
        // A companion writes NULL for a cleared field. A plain row would
        // leave the old value in place when the id already exists.
        .insertOnConflictUpdate(
          SettingsMapper.toRow(settings).toCompanion(false),
        ),
  );
}
