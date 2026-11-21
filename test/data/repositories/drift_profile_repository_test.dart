import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/database/app_database.dart';
import 'package:izin_planla/data/fakes/fake_profile_repository.dart';
import 'package:izin_planla/data/fakes/sample_data.dart';
import 'package:izin_planla/data/repositories/drift_leave_repository.dart';
import 'package:izin_planla/data/repositories/drift_overtime_repository.dart';
import 'package:izin_planla/data/repositories/drift_profile_repository.dart';
import 'package:izin_planla/data/repositories/drift_settings_repository.dart';
import 'package:izin_planla/data/repositories/profile_repository.dart';
import 'package:izin_planla/data/repositories/storage_exception.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/utils/result.dart';

import 'fixtures.dart';

void main() {
  late AppDatabase database;
  late DriftProfileRepository repository;

  setUp(() {
    database = openTestDatabase();
    repository = DriftProfileRepository(database);
  });

  tearDown(() => database.close());

  group('save and read', () {
    test('a new database has no profiles', () async {
      expect(await repository.watchAll().first, isEmpty);
      expect(await repository.findById('p1'), isNull);
    });

    test('stores every field of a profile', () async {
      final result = await repository.save(fullProfile('p1'));

      expect(result, isA<Ok<void>>());
      expect(await repository.findById('p1'), fullProfile('p1'));
      expect(await repository.watchAll().first, [fullProfile('p1')]);
    });

    test('stores every employment type and half day deduction', () async {
      for (final type in EmploymentType.values) {
        for (final deduction in HalfDayDeduction.values) {
          final profile = simpleProfile('${type.name}-${deduction.name}')
              .copyWith(
                employmentType: type,
                workSchedule: WorkSchedule(halfDayDeduction: deduction),
              );

          expect(await repository.save(profile), isA<Ok<void>>());
          expect(await repository.findById(profile.id), profile);
        }
      }
    });

    test('saving an existing id replaces it and keeps its place', () async {
      await repository.save(simpleProfile('p1'));
      await repository.save(simpleProfile('p2'));
      final renamed = simpleProfile('p1').copyWith(name: 'Renamed');

      await repository.save(renamed);

      expect(await repository.watchAll().first, [renamed, simpleProfile('p2')]);
    });

    test('lists profiles in the order they were first saved', () async {
      for (final id in ['c', 'a', 'b']) {
        await repository.save(simpleProfile(id));
      }

      final ids = [for (final p in await repository.watchAll().first) p.id];

      expect(ids, ['c', 'a', 'b']);
    });

    test('a broken schema rule fails without storing anything', () async {
      final invalid = simpleProfile('p1')
          .copyWith(priorService: const ServiceDuration(years: -1));

      final result = await repository.save(invalid);

      expect(
        result,
        isA<Err<void>>().having(
          (err) => err.error,
          'error',
          isA<StorageException>().having(
            (e) => e.isConstraintViolation,
            'isConstraintViolation',
            isTrue,
          ),
        ),
      );
      expect(await repository.findById('p1'), isNull);
    });
  });

  group('watchAll', () {
    test('emits after every save and delete', () async {
      final emissions = Emissions(repository.watchAll());
      addTearDown(emissions.cancel);

      expect(await emissions.next(), isEmpty);
      await repository.save(simpleProfile('p1'));
      expect(await emissions.next(), [simpleProfile('p1')]);
      await repository.save(simpleProfile('p2'));
      expect(await emissions.next(), [
        simpleProfile('p1'),
        simpleProfile('p2'),
      ]);
      await repository.delete('p1');
      expect(await emissions.next(), [simpleProfile('p2')]);
    });
  });

  group('delete', () {
    test('removes the profile with its leave and overtime records', () async {
      final leaves = DriftLeaveRepository(database);
      final overtimes = DriftOvertimeRepository(database);
      await repository.save(simpleProfile('p1'));
      await repository.save(simpleProfile('p2'));
      await leaves.save(leave('l1', start: DateTime.utc(2026, 7, 6)));
      await leaves.save(
        leave('l2', profileId: 'p2', start: DateTime.utc(2026, 8, 3)),
      );
      await overtimes.save(overtime('o1', date: DateTime.utc(2026, 2, 3)));

      final result = await repository.delete('p1');

      expect(result, isA<Ok<void>>());
      expect(await repository.findById('p1'), isNull);
      expect(await leaves.watchForProfile('p1').first, isEmpty);
      expect(await overtimes.watchForProfile('p1').first, isEmpty);
      expect(await leaves.watchForProfile('p2').first, hasLength(1));
    });

    test('emits the emptied leave list to watchers', () async {
      final leaves = DriftLeaveRepository(database);
      await repository.save(simpleProfile('p1'));
      await leaves.save(leave('l1', start: DateTime.utc(2026, 7, 6)));
      final emissions = Emissions(leaves.watchForProfile('p1'));
      addTearDown(emissions.cancel);
      expect(await emissions.next(), hasLength(1));

      await repository.delete('p1');

      expect(await emissions.next(), isEmpty);
    });

    test('makes the first remaining profile active', () async {
      final settings = DriftSettingsRepository(database);
      for (final id in ['p1', 'p2', 'p3']) {
        await repository.save(simpleProfile(id));
      }
      await settings.save(const AppSettings(activeProfileId: 'p2'));

      await repository.delete('p2');

      expect((await settings.watch().first).activeProfileId, 'p1');
    });

    test('keeps another active profile', () async {
      final settings = DriftSettingsRepository(database);
      await repository.save(simpleProfile('p1'));
      await repository.save(simpleProfile('p2'));
      await settings.save(const AppSettings(activeProfileId: 'p2'));

      await repository.delete('p1');

      expect((await settings.watch().first).activeProfileId, 'p2');
    });

    test('clears the active profile when the last one goes', () async {
      final settings = DriftSettingsRepository(database);
      await repository.save(simpleProfile('p1'));
      await settings.save(
        const AppSettings(activeProfileId: 'p1', themeMode: AppThemeMode.dark),
      );

      await repository.delete('p1');

      expect(
        await settings.watch().first,
        const AppSettings(themeMode: AppThemeMode.dark),
      );
    });

    test('an unknown id succeeds and changes nothing', () async {
      await repository.save(simpleProfile('p1'));

      expect(await repository.delete('missing'), isA<Ok<void>>());
      expect(await repository.watchAll().first, [simpleProfile('p1')]);
    });
  });

  group('behaves like FakeProfileRepository', () {
    test('for the same calls', () async {
      final fake = FakeProfileRepository();
      // The fake starts with the sample profile, so the real one does too.
      await repository.save(SampleData.profile);
      final steps = <Future<Result<void>> Function(ProfileRepository)>[
        (r) => r.save(simpleProfile('p1')),
        (r) => r.save(fullProfile('p2')),
        (r) => r.save(simpleProfile('p1').copyWith(name: 'Renamed')),
        (r) => r.delete(SampleData.profileId),
        (r) => r.delete('missing'),
      ];

      for (final step in steps) {
        final expected = await step(fake);
        final actual = await step(repository);

        expect(actual.runtimeType, expected.runtimeType);
        expect(await repository.watchAll().first, await fake.watchAll().first);
        for (final id in [SampleData.profileId, 'p1', 'p2']) {
          expect(await repository.findById(id), await fake.findById(id));
        }
      }
    });
  });
}
