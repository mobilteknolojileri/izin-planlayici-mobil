import 'dart:io';

import 'package:drift/native.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/database/app_database.dart';
import 'package:izin_planla/data/repositories/drift_leave_repository.dart';
import 'package:izin_planla/data/repositories/drift_profile_repository.dart';
import 'package:izin_planla/data/repositories/drift_settings_repository.dart';
import 'package:izin_planla/domain/models/models.dart';

import '../repositories/fixtures.dart';
import 'schema_snapshot.dart';

void main() {
  group('schema', () {
    test('starts at version 1', () async {
      final database = openTestDatabase();
      addTearDown(database.close);

      expect(database.schemaVersion, 1);
    });

    test('a fresh database matches the table definitions', () async {
      final database = openTestDatabase();
      addTearDown(database.close);

      await database.validateDatabaseSchema();
    });

    test('the committed v1 snapshot matches the table definitions', () async {
      final database = openAtSnapshot(1);
      addTearDown(database.close);

      await database.validateDatabaseSchema();
    });

    test('the snapshot check notices a schema difference', () async {
      final database = openAtSnapshot(
        1,
        seed: ['ALTER TABLE profiles ADD COLUMN nickname TEXT'],
      );
      addTearDown(database.close);

      await expectLater(
        database.validateDatabaseSchema(),
        throwsA(isA<SchemaMismatch>()),
      );
    });

    test('every table is STRICT', () async {
      final database = openTestDatabase();
      addTearDown(database.close);

      final rows = await database
          .customSelect(
            "SELECT name, strict FROM pragma_table_list WHERE schema = 'main' "
            "AND name NOT LIKE 'sqlite_%' ORDER BY name",
          )
          .get();

      expect(
        {
          for (final row in rows)
            row.read<String>('name'): row.read<int>('strict'),
        },
        {
          'leave_records': 1,
          'overtime_records': 1,
          'profiles': 1,
          'settings': 1,
        },
      );
    });

    test('foreign keys are enforced on every open', () async {
      final database = openTestDatabase();
      addTearDown(database.close);

      final row = await database
          .customSelect('PRAGMA foreign_keys')
          .getSingle();

      expect(row.data.values.single, 1);
    });

    test('CHECK constraints reject an unknown enum name', () async {
      final database = openTestDatabase();
      addTearDown(database.close);
      await DriftProfileRepository(database).save(simpleProfile('p1'));

      await expectLater(
        database.customStatement(
          "UPDATE profiles SET employment_type = 'contractor'",
        ),
        throwsA(isA<SqliteException>()),
      );
    });

    test('CHECK constraints reject an impossible calendar day', () async {
      final database = openTestDatabase();
      addTearDown(database.close);
      await DriftProfileRepository(database).save(simpleProfile('p1'));

      await expectLater(
        database.customStatement(
          "UPDATE profiles SET birth_date = '2026-02-30'",
        ),
        throwsA(isA<SqliteException>()),
      );
    });
  });

  group('migration', () {
    test('keeps the data of a v1 database', () async {
      const profileRow =
          'INSERT INTO profiles VALUES '
          "('p1', 'Ayşe', 'civilServant', '2010-09-01', '1975-02-28', "
          "'[1,2,3,4,5]', 7, 1, 'half', 8.0, 1, 2, 3, 0, 0, 0.0, 0, "
          "'[\"2026-01-02\"]', '[]')";
      const leaveRow =
          'INSERT INTO leave_records VALUES '
          "('l1', 'p1', 'annual', '2026-07-06', '2026-07-10', 'days', "
          'NULL, NULL, NULL, 0, NULL)';
      const settingsRow =
          "INSERT INTO settings VALUES (1, 'dark', 'p1', 0, 7, 0, 0, 1, 0)";
      final database = openAtSnapshot(
        1,
        seed: [profileRow, leaveRow, settingsRow],
      );
      addTearDown(database.close);

      await database.validateDatabaseSchema();

      expect(
        await DriftProfileRepository(database).findById('p1'),
        Profile(
          id: 'p1',
          name: 'Ayşe',
          employmentType: EmploymentType.civilServant,
          employmentStartDate: DateTime.utc(2010, 9),
          birthDate: DateTime.utc(1975, 2, 28),
          priorService: const ServiceDuration(years: 1, months: 2, days: 3),
          administrativeLeaveDays: [DateTime.utc(2026, 1, 2)],
        ),
      );
      expect(await DriftLeaveRepository(database).watchForProfile('p1').first, [
        leave(
          'l1',
          start: DateTime.utc(2026, 7, 6),
          end: DateTime.utc(2026, 7, 10),
        ),
      ]);
      expect(
        await DriftSettingsRepository(database).watch().first,
        const AppSettings(themeMode: AppThemeMode.dark, activeProfileId: 'p1'),
      );
    });
  });

  group('file database', () {
    test('keeps the data after the app restarts', () async {
      final directory = await Directory.systemTemp.createTemp('izin_planla_');
      addTearDown(() => directory.delete(recursive: true));
      final file = File('${directory.path}/izin_planla.sqlite');

      final first = AppDatabase(NativeDatabase(file));
      await DriftProfileRepository(first).save(fullProfile('p1'));
      await DriftLeaveRepository(first).save(fullLeave('l1'));
      await first.close();

      final second = AppDatabase(NativeDatabase(file));
      addTearDown(second.close);

      expect(
        await DriftProfileRepository(second).findById('p1'),
        fullProfile('p1'),
      );
      expect(await DriftLeaveRepository(second).watchForProfile('p1').first, [
        fullLeave('l1'),
      ]);
    });
  });
}
