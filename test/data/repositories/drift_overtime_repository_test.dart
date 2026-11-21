import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/database/app_database.dart';
import 'package:izin_planla/data/fakes/fake_overtime_repository.dart';
import 'package:izin_planla/data/repositories/drift_overtime_repository.dart';
import 'package:izin_planla/data/repositories/drift_profile_repository.dart';
import 'package:izin_planla/data/repositories/overtime_repository.dart';
import 'package:izin_planla/data/repositories/storage_exception.dart';
import 'package:izin_planla/utils/result.dart';

import 'fixtures.dart';

void main() {
  late AppDatabase database;
  late DriftOvertimeRepository repository;

  setUp(() async {
    database = openTestDatabase();
    repository = DriftOvertimeRepository(database);
    final profiles = DriftProfileRepository(database);
    await profiles.save(simpleProfile('p1'));
    await profiles.save(simpleProfile('p2'));
  });

  tearDown(() => database.close());

  Matcher constraintError() => isA<Err<void>>().having(
    (err) => err.error,
    'error',
    isA<StorageException>().having(
      (e) => e.isConstraintViolation,
      'isConstraintViolation',
      isTrue,
    ),
  );

  group('save and read', () {
    test('stores every field of a record', () async {
      final record = overtime(
        'o1',
        date: DateTime.utc(2026, 2, 3),
        hours: 1.5,
        note: 'Sayım',
      );

      expect(await repository.save(record), isA<Ok<void>>());
      expect(await repository.watchForProfile('p1').first, [record]);
    });

    test('saving an existing id replaces the record', () async {
      await repository.save(overtime('o1', date: DateTime.utc(2026, 2, 3)));
      final changed = overtime('o1', date: DateTime.utc(2026, 2, 3), hours: 4);

      await repository.save(changed);

      expect(await repository.watchForProfile('p1').first, [changed]);
    });

    test('saving can clear the note', () async {
      final day = DateTime.utc(2026, 2, 3);
      await repository.save(overtime('o1', date: day, note: 'Sayım'));

      await repository.save(overtime('o1', date: day));

      expect(await repository.watchForProfile('p1').first, [
        overtime('o1', date: day),
      ]);
    });

    test('lists records by date', () async {
      final march = overtime('march', date: DateTime.utc(2026, 3, 2));
      final january = overtime('january', date: DateTime.utc(2026, 1, 5));
      await repository.save(march);
      await repository.save(january);

      expect(await repository.watchForProfile('p1').first, [january, march]);
    });

    test('a record of an unknown profile is rejected', () async {
      final orphan = overtime(
        'o1',
        profileId: 'missing',
        date: DateTime.utc(2026, 2, 3),
      );

      expect(await repository.save(orphan), constraintError());
    });

    test('non-positive hours are rejected', () async {
      final record = overtime('o1', date: DateTime.utc(2026, 2, 3), hours: 0);

      expect(await repository.save(record), constraintError());
      expect(await repository.watchForProfile('p1').first, isEmpty);
    });
  });

  group('watchForProfile', () {
    test('emits after every change of that profile', () async {
      final emissions = Emissions(repository.watchForProfile('p1'));
      addTearDown(emissions.cancel);
      final record = overtime('o1', date: DateTime.utc(2026, 2, 3));

      expect(await emissions.next(), isEmpty);
      await repository.save(record);
      expect(await emissions.next(), [record]);
      await repository.delete('o1');
      expect(await emissions.next(), isEmpty);
    });

    test('only returns records of the given profile', () async {
      final own = overtime('o1', date: DateTime.utc(2026, 2, 3));
      final other = overtime(
        'o2',
        profileId: 'p2',
        date: DateTime.utc(2026, 2, 3),
      );
      await repository.save(own);
      await repository.save(other);

      expect(await repository.watchForProfile('p1').first, [own]);
      expect(await repository.watchForProfile('p2').first, [other]);
    });
  });

  group('delete', () {
    test('removes only the record with the id', () async {
      final kept = overtime('o2', date: DateTime.utc(2026, 2, 4));
      await repository.save(overtime('o1', date: DateTime.utc(2026, 2, 3)));
      await repository.save(kept);

      expect(await repository.delete('o1'), isA<Ok<void>>());
      expect(await repository.watchForProfile('p1').first, [kept]);
    });

    test('an unknown id succeeds and changes nothing', () async {
      await repository.save(overtime('o1', date: DateTime.utc(2026, 2, 3)));

      expect(await repository.delete('missing'), isA<Ok<void>>());
      expect(await repository.watchForProfile('p1').first, hasLength(1));
    });
  });

  group('behaves like FakeOvertimeRepository', () {
    test('for the same calls', () async {
      final fake = FakeOvertimeRepository();
      final steps = <Future<Result<void>> Function(OvertimeRepository)>[
        (r) => r.save(overtime('o1', date: DateTime.utc(2026, 2, 3))),
        (r) => r.save(overtime('o2', date: DateTime.utc(2026, 1, 5))),
        (r) => r.save(overtime('o1', date: DateTime.utc(2026, 2, 3), hours: 5)),
        (r) => r.save(
          overtime('o3', profileId: 'p2', date: DateTime.utc(2026, 2, 3)),
        ),
        (r) => r.delete('o2'),
        (r) => r.delete('missing'),
      ];

      for (final step in steps) {
        final expected = await step(fake);
        final actual = await step(repository);

        expect(actual.runtimeType, expected.runtimeType);
        for (final profileId in ['p1', 'p2']) {
          // The fake keeps insertion order, the database sorts by date.
          expect(
            await repository.watchForProfile(profileId).first,
            unorderedEquals(await fake.watchForProfile(profileId).first),
          );
        }
      }
    });
  });
}
