import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/database/app_database.dart';
import 'package:izin_planla/data/fakes/fake_leave_repository.dart';
import 'package:izin_planla/data/fakes/sample_data.dart';
import 'package:izin_planla/data/repositories/drift_leave_repository.dart';
import 'package:izin_planla/data/repositories/drift_profile_repository.dart';
import 'package:izin_planla/data/repositories/leave_repository.dart';
import 'package:izin_planla/data/repositories/storage_exception.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/utils/result.dart';

import 'fixtures.dart';

void main() {
  late AppDatabase database;
  late DriftLeaveRepository repository;

  setUp(() async {
    database = openTestDatabase();
    repository = DriftLeaveRepository(database);
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
      expect(await repository.save(fullLeave('l1')), isA<Ok<void>>());

      expect(await repository.watchForProfile('p1').first, [fullLeave('l1')]);
    });

    test('stores every leave type and unit', () async {
      var day = DateTime.utc(2026);
      for (final type in LeaveType.values) {
        for (final unit in LeaveUnit.values) {
          final record = leave(
            '${type.name}-${unit.name}',
            start: day,
            type: type,
          ).copyWith(unit: unit, hours: unit == LeaveUnit.hours ? 3 : null);
          day = day.add(const Duration(days: 1));

          expect(await repository.save(record), isA<Ok<void>>());
        }
      }

      final stored = await repository.watchForProfile('p1').first;

      expect(
        stored,
        hasLength(LeaveType.values.length * LeaveUnit.values.length),
      );
      expect({for (final r in stored) r.type}, LeaveType.values.toSet());
    });

    test('saving an existing id replaces the record', () async {
      await repository.save(leave('l1', start: DateTime.utc(2026, 7, 6)));
      final moved = leave('l1', start: DateTime.utc(2026, 9));

      await repository.save(moved);

      expect(await repository.watchForProfile('p1').first, [moved]);
    });

    test('saving can clear optional fields', () async {
      await repository.save(fullLeave('l1'));
      final cleared = fullLeave('l1').copyWith(
        unit: LeaveUnit.days,
        hours: null,
        customTypeName: null,
        eventDate: null,
        note: null,
      );

      await repository.save(cleared);

      expect(await repository.watchForProfile('p1').first, [cleared]);
    });

    test('lists records by start date, then end date', () async {
      final december = leave('december', start: DateTime.utc(2026, 12, 28));
      final long = leave(
        'long',
        start: DateTime.utc(2026, 3, 2),
        end: DateTime.utc(2026, 3, 6),
      );
      final short = leave('short', start: DateTime.utc(2026, 3, 2));
      for (final record in [december, long, short]) {
        await repository.save(record);
      }

      expect(await repository.watchForProfile('p1').first, [
        short,
        long,
        december,
      ]);
    });

    test('a record of an unknown profile is rejected', () async {
      final orphan = leave(
        'l1',
        profileId: 'missing',
        start: DateTime.utc(2026, 7, 6),
      );

      expect(await repository.save(orphan), constraintError());
      expect(await repository.watchForProfile('missing').first, isEmpty);
    });

    test('non-positive hours are rejected', () async {
      final record = fullLeave('l1').copyWith(hours: 0);

      expect(await repository.save(record), constraintError());
      expect(await repository.watchForProfile('p1').first, isEmpty);
    });
  });

  group('watchForProfile', () {
    test('emits after every change of that profile', () async {
      final emissions = Emissions(repository.watchForProfile('p1'));
      addTearDown(emissions.cancel);
      final first = leave('l1', start: DateTime.utc(2026, 7, 6));

      expect(await emissions.next(), isEmpty);
      await repository.save(first);
      expect(await emissions.next(), [first]);
      await repository.delete('l1');
      expect(await emissions.next(), isEmpty);
    });

    test('only returns records of the given profile', () async {
      final own = leave('l1', start: DateTime.utc(2026, 7, 6));
      final other = leave(
        'l2',
        profileId: 'p2',
        start: DateTime.utc(2026, 7, 6),
      );
      await repository.save(own);
      await repository.save(other);

      expect(await repository.watchForProfile('p1').first, [own]);
      expect(await repository.watchForProfile('p2').first, [other]);
    });
  });

  group('delete', () {
    test('removes only the record with the id', () async {
      await repository.save(leave('l1', start: DateTime.utc(2026, 7, 6)));
      await repository.save(leave('l2', start: DateTime.utc(2026, 8, 3)));

      expect(await repository.delete('l1'), isA<Ok<void>>());

      expect(await repository.watchForProfile('p1').first, [
        leave('l2', start: DateTime.utc(2026, 8, 3)),
      ]);
    });

    test('an unknown id succeeds and changes nothing', () async {
      await repository.save(leave('l1', start: DateTime.utc(2026, 7, 6)));

      expect(await repository.delete('missing'), isA<Ok<void>>());
      expect(await repository.watchForProfile('p1').first, hasLength(1));
    });
  });

  group('behaves like FakeLeaveRepository', () {
    test('for the same calls', () async {
      final fake = FakeLeaveRepository();
      // The fake starts with the sample leaves, so the real one does too.
      await DriftProfileRepository(database).save(SampleData.profile);
      for (final record in SampleData.leaves) {
        await repository.save(record);
      }
      const profileId = SampleData.profileId;
      final steps = <Future<Result<void>> Function(LeaveRepository)>[
        (r) => r.save(
          leave('a', profileId: profileId, start: DateTime.utc(2027, 2)),
        ),
        (r) => r.save(fullLeave('b', profileId: profileId)),
        (r) => r.save(
          leave('a', profileId: profileId, start: DateTime.utc(2027, 3)),
        ),
        (r) => r.delete('sample-leave-1'),
        (r) => r.delete('missing'),
      ];

      for (final step in steps) {
        final expected = await step(fake);
        final actual = await step(repository);

        expect(actual.runtimeType, expected.runtimeType);
        // The fake keeps insertion order, the database sorts by date.
        expect(
          await repository.watchForProfile(profileId).first,
          unorderedEquals(await fake.watchForProfile(profileId).first),
        );
      }
    });
  });
}
