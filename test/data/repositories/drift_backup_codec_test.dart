import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/database/app_database.dart';
import 'package:izin_planla/data/repositories/backup_exception.dart';
import 'package:izin_planla/data/repositories/drift_backup_codec.dart';
import 'package:izin_planla/data/repositories/drift_leave_repository.dart';
import 'package:izin_planla/data/repositories/drift_overtime_repository.dart';
import 'package:izin_planla/data/repositories/drift_profile_repository.dart';
import 'package:izin_planla/data/repositories/drift_settings_repository.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/utils/result.dart';

import 'fixtures.dart';

void main() {
  late AppDatabase database;
  late DriftBackupCodec codec;
  late DriftProfileRepository profiles;
  late DriftLeaveRepository leaves;
  late DriftOvertimeRepository overtimes;
  late DriftSettingsRepository settings;

  setUp(() {
    database = openTestDatabase();
    codec = DriftBackupCodec(database);
    profiles = DriftProfileRepository(database);
    leaves = DriftLeaveRepository(database);
    overtimes = DriftOvertimeRepository(database);
    settings = DriftSettingsRepository(database);
  });

  tearDown(() => database.close());

  const savedSettings = AppSettings(
    themeMode: AppThemeMode.dark,
    activeProfileId: 'p2',
    notifications: NotificationPreferences(holidayReminder: true),
  );

  Future<void> seed() async {
    await profiles.save(simpleProfile('p1'));
    await profiles.save(fullProfile('p2'));
    await leaves.save(leave('l1', start: DateTime.utc(2026, 7, 6)));
    await leaves.save(fullLeave('l2', profileId: 'p2'));
    await overtimes.save(
      overtime('o1', profileId: 'p2', date: DateTime.utc(2026, 2, 3)),
    );
    await settings.save(savedSettings);
  }

  Future<String> export() async {
    final result = await codec.exportJson();
    return (result as Ok<String>).value;
  }

  Future<void> expectSeededData() async {
    expect(await profiles.watchAll().first, [
      simpleProfile('p1'),
      fullProfile('p2'),
    ]);
    expect(await leaves.watchForProfile('p1').first, [
      leave('l1', start: DateTime.utc(2026, 7, 6)),
    ]);
    expect(await leaves.watchForProfile('p2').first, [
      fullLeave('l2', profileId: 'p2'),
    ]);
    expect(await overtimes.watchForProfile('p2').first, [
      overtime('o1', profileId: 'p2', date: DateTime.utc(2026, 2, 3)),
    ]);
    expect(await settings.watch().first, savedSettings);
  }

  group('exportJson', () {
    test('writes a versioned document of an empty database', () async {
      final document = jsonDecode(await export()) as Map<String, dynamic>;

      expect(document, {
        'format': DriftBackupCodec.format,
        'formatVersion': DriftBackupCodec.formatVersion,
        'settings': const AppSettings().toJson(),
        'profiles': <Object>[],
        'leaveRecords': <Object>[],
        'overtimeRecords': <Object>[],
      });
    });

    test('contains every record as model JSON', () async {
      await seed();

      final document = jsonDecode(await export()) as Map<String, dynamic>;

      expect(document['settings'], savedSettings.toJson());
      expect(document['profiles'], hasLength(2));
      expect(document['leaveRecords'], hasLength(2));
      expect(
        Profile.fromJson(
          (document['profiles'] as List<dynamic>)[1] as Map<String, dynamic>,
        ),
        fullProfile('p2'),
      );
    });
  });

  group('restoreJson', () {
    test('export, reset and restore gives the same data', () async {
      await seed();
      final backup = await export();

      expect(await codec.resetAll(), isA<Ok<void>>());
      expect(await profiles.watchAll().first, isEmpty);
      expect(await codec.restoreJson(backup), isA<Ok<void>>());

      await expectSeededData();
      expect(await export(), backup);
    });

    test('replaces the data that is not in the backup', () async {
      await profiles.save(simpleProfile('p1'));
      final backup = await export();
      await profiles.save(simpleProfile('extra'));
      await settings.save(const AppSettings(activeProfileId: 'extra'));

      expect(await codec.restoreJson(backup), isA<Ok<void>>());

      expect(await profiles.watchAll().first, [simpleProfile('p1')]);
      expect(await settings.watch().first, const AppSettings());
    });

    test('watchers see the restored data', () async {
      await seed();
      final backup = await export();
      await codec.resetAll();
      final emissions = Emissions(profiles.watchAll());
      addTearDown(emissions.cancel);
      expect(await emissions.next(), isEmpty);

      await codec.restoreJson(backup);

      expect(await emissions.next(), hasLength(2));
    });

    test('accepts a document with whitespace and in any key order', () async {
      await seed();
      final document = jsonDecode(await export()) as Map<String, dynamic>;
      final reordered = {
        for (final key in document.keys.toList().reversed) key: document[key],
      };
      await codec.resetAll();

      final result = await codec.restoreJson(
        const JsonEncoder.withIndent('  ').convert(reordered),
      );

      expect(result, isA<Ok<void>>());
      await expectSeededData();
    });
  });

  group('restoreJson rejects', () {
    late String backup;
    late Map<String, dynamic> document;

    setUp(() async {
      await seed();
      backup = await export();
      document = jsonDecode(backup) as Map<String, dynamic>;
    });

    Future<Result<void>> restoreChanged(
      void Function(Map<String, dynamic> document) change,
    ) {
      final copy = jsonDecode(backup) as Map<String, dynamic>;
      change(copy);
      return codec.restoreJson(jsonEncode(copy));
    }

    Matcher failsWith<T extends BackupException>() =>
        isA<Err<void>>().having((err) => err.error, 'error', isA<T>());

    List<dynamic> listOf(Map<String, dynamic> document, String key) =>
        document[key] as List<dynamic>;

    Map<String, dynamic> itemOf(
      Map<String, dynamic> document,
      String key,
      int index,
    ) => listOf(document, key)[index] as Map<String, dynamic>;

    Future<void> expectRejected(
      Future<Result<void>> Function() restore,
      Matcher matcher,
    ) async {
      expect(await restore(), matcher);
      // The existing data is untouched.
      expect(await export(), backup);
      await expectSeededData();
    }

    test('text that is not JSON', () async {
      await expectRejected(
        () => codec.restoreJson('not a backup'),
        failsWith<InvalidBackupException>(),
      );
    });

    test('a file cut off in the middle', () async {
      await expectRejected(
        () => codec.restoreJson(backup.substring(0, backup.length ~/ 2)),
        failsWith<InvalidBackupException>(),
      );
    });

    test('an empty file', () async {
      await expectRejected(
        () => codec.restoreJson(''),
        failsWith<InvalidBackupException>(),
      );
    });

    test('JSON that is not an object', () async {
      await expectRejected(
        () => codec.restoreJson('[1, 2, 3]'),
        failsWith<InvalidBackupException>(),
      );
    });

    test('a document of another app', () async {
      await expectRejected(
        () => restoreChanged((d) => d['format'] = 'other-app'),
        failsWith<InvalidBackupException>(),
      );
    });

    test('a document without a version', () async {
      await expectRejected(
        () => restoreChanged((d) => d.remove('formatVersion')),
        failsWith<InvalidBackupException>(),
      );
    });

    test('a document from a newer app version', () async {
      await expectRejected(
        () => restoreChanged(
          (d) => d['formatVersion'] = DriftBackupCodec.formatVersion + 1,
        ),
        isA<Err<void>>().having(
          (err) => err.error,
          'error',
          isA<NewerBackupException>()
              .having(
                (e) => e.formatVersion,
                'formatVersion',
                DriftBackupCodec.formatVersion + 1,
              )
              .having(
                (e) => e.supportedVersion,
                'supportedVersion',
                DriftBackupCodec.formatVersion,
              ),
        ),
      );
    });

    test('a missing list', () async {
      await expectRejected(
        () => restoreChanged((d) => d.remove('leaveRecords')),
        failsWith<InvalidBackupException>(),
      );
    });

    test('a list of the wrong type', () async {
      await expectRejected(
        () => restoreChanged((d) => d['profiles'] = {'p1': 'x'}),
        failsWith<InvalidBackupException>(),
      );
    });

    test('a field of the wrong type', () async {
      await expectRejected(
        () => restoreChanged((d) => itemOf(d, 'profiles', 0)['name'] = 42),
        failsWith<InvalidBackupException>(),
      );
    });

    test('a missing required field', () async {
      await expectRejected(
        () => restoreChanged((d) => itemOf(d, 'profiles', 0).remove('id')),
        failsWith<InvalidBackupException>(),
      );
    });

    test('an unknown enum name', () async {
      await expectRejected(
        () => restoreChanged(
          (d) => itemOf(d, 'leaveRecords', 0)['type'] = 'holiday',
        ),
        failsWith<InvalidBackupException>(),
      );
    });

    test('a malformed date', () async {
      await expectRejected(
        () => restoreChanged(
          (d) => itemOf(d, 'profiles', 0)['birthDate'] = 'yesterday',
        ),
        failsWith<InvalidBackupException>(),
      );
    });

    test('a range that ends before it starts', () async {
      await expectRejected(
        () => restoreChanged(
          (d) => itemOf(d, 'leaveRecords', 0)['range'] = {
            'start': '2026-07-10',
            'end': '2026-07-06',
          },
        ),
        failsWith<InvalidBackupException>(),
      );
    });

    test('a duplicate id', () async {
      await expectRejected(
        () => restoreChanged(
          (d) => listOf(d, 'leaveRecords').add(itemOf(d, 'leaveRecords', 0)),
        ),
        failsWith<InvalidBackupException>(),
      );
    });

    test('a record of a missing profile', () async {
      await expectRejected(
        () => restoreChanged(
          (d) => itemOf(d, 'overtimeRecords', 0)['profileId'] = 'missing',
        ),
        failsWith<InvalidBackupException>(),
      );
    });

    test('an active profile that is not in the file', () async {
      await expectRejected(
        () => restoreChanged(
          (d) => (d['settings'] as Map<String, dynamic>)['activeProfileId'] =
              'missing',
        ),
        failsWith<InvalidBackupException>(),
      );
    });

    test('a value the database does not allow', () async {
      await expectRejected(
        () => restoreChanged(
          (d) => itemOf(d, 'overtimeRecords', 0)['hours'] = -3,
        ),
        failsWith<InvalidBackupException>(),
      );
    });

    test('keeps the unchanged document valid', () async {
      // Guards the cases above: they fail because of their change only.
      expect(document['format'], DriftBackupCodec.format);
      expect(await restoreChanged((_) {}), isA<Ok<void>>());
      await expectSeededData();
    });
  });

  group('resetAll', () {
    test('deletes every profile, record and setting', () async {
      await seed();

      expect(await codec.resetAll(), isA<Ok<void>>());

      expect(await profiles.watchAll().first, isEmpty);
      expect(await leaves.watchForProfile('p1').first, isEmpty);
      expect(await leaves.watchForProfile('p2').first, isEmpty);
      expect(await overtimes.watchForProfile('p2').first, isEmpty);
      expect(await settings.watch().first, const AppSettings());
    });

    test('leaves a database that accepts new data', () async {
      await seed();
      await codec.resetAll();

      expect(await profiles.save(simpleProfile('p1')), isA<Ok<void>>());
      expect(await profiles.watchAll().first, [simpleProfile('p1')]);
    });
  });
}
