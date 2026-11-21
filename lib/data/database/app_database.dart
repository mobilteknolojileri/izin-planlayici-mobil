import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:izin_planla/data/database/converters/date_range_list_converter.dart';
import 'package:izin_planla/data/database/converters/day_converter.dart';
import 'package:izin_planla/data/database/converters/day_list_converter.dart';
import 'package:izin_planla/data/database/converters/int_list_converter.dart';
import 'package:izin_planla/data/database/tables/leave_records.dart';
import 'package:izin_planla/data/database/tables/overtime_records.dart';
import 'package:izin_planla/data/database/tables/profiles.dart';
import 'package:izin_planla/data/database/tables/settings.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// The app's SQLite database. Only repositories in `lib/data/repositories/`
/// use it, everything above them sees domain models.
///
/// Every shipped schema is committed in `drift_schemas/`. To change the
/// schema, bump [currentSchemaVersion], add the migration step in
/// [migration], run `dart run build_runner build` and then
/// `dart run drift_dev schema dump lib/data/database/app_database.dart
/// drift_schemas/`, and add a test that
/// opens the previous snapshot with `openAtSnapshot` in
/// `test/data/database/app_database_test.dart`.
@DriftDatabase(tables: [Profiles, LeaveRecords, OvertimeRecords, Settings])
class AppDatabase extends _$AppDatabase {
  /// Creates a database on the query executor [e]. Tests pass
  /// `NativeDatabase.memory()`.
  new(super.e);

  /// Opens the database file `izin_planla.sqlite` in the app support
  /// directory, which only this app can read.
  factory open() => AppDatabase(
    driftDatabase(
      name: fileName,
      native: DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
        setup: (database) {
          // WAL keeps reads fast while writing, FULL makes every committed
          // transaction survive a power loss.
          database
            ..execute('PRAGMA journal_mode = WAL')
            ..execute('PRAGMA synchronous = FULL');
        },
      ),
    ),
  );

  /// Base name of the database file, without the `.sqlite` extension.
  static const fileName = 'izin_planla';

  /// The schema version this build writes. Backups from a higher version
  /// are refused, so the export service reads it without opening the file.
  static const currentSchemaVersion = 1;

  @override
  int get schemaVersion => currentSchemaVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      // Version 1 is the first schema. Add one step per new version here.
      throw UnsupportedError('No migration from schema $from to $to.');
    },
    beforeOpen: (details) async {
      // SQLite turns foreign keys off for every new connection.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
