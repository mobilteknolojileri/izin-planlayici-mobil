import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:izin_planla/data/database/app_database.dart';

/// The SQL that creates schema [version] exactly as committed in
/// `drift_schemas/drift_schema_v<version>.json` by `drift_dev schema dump`.
List<String> snapshotStatements(int version) {
  final file = File('drift_schemas/drift_schema_v$version.json');
  final document = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  return [
    for (final entity in document['fixed_sql'] as List<dynamic>)
      for (final sql
          in (entity as Map<String, dynamic>)['sql'] as List<dynamic>)
        if ((sql as Map<String, dynamic>)['dialect'] == 'sqlite')
          sql['sql'] as String,
  ];
}

/// Opens an in-memory database that an app with schema [version] left
/// behind: the snapshot tables, the [seed] rows and `user_version`.
///
/// Opening it runs the real migration from [version] to the current
/// `AppDatabase.schemaVersion`.
AppDatabase openAtSnapshot(int version, {List<String> seed = const []}) {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final statements = snapshotStatements(version);
  return AppDatabase(
    NativeDatabase.memory(
      setup: (raw) {
        statements.forEach(raw.execute);
        seed.forEach(raw.execute);
        raw.execute('PRAGMA user_version = $version');
      },
    ),
  );
}
