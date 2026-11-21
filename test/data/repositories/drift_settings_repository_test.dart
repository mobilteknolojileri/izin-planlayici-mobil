import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/database/app_database.dart';
import 'package:izin_planla/data/fakes/fake_settings_repository.dart';
import 'package:izin_planla/data/fakes/sample_data.dart';
import 'package:izin_planla/data/repositories/drift_profile_repository.dart';
import 'package:izin_planla/data/repositories/drift_settings_repository.dart';
import 'package:izin_planla/data/repositories/settings_repository.dart';
import 'package:izin_planla/data/repositories/storage_exception.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/utils/result.dart';

import 'fixtures.dart';

void main() {
  late AppDatabase database;
  late DriftSettingsRepository repository;

  setUp(() async {
    database = openTestDatabase();
    repository = DriftSettingsRepository(database);
    await DriftProfileRepository(database).save(simpleProfile('p1'));
  });

  tearDown(() => database.close());

  const custom = AppSettings(
    themeMode: AppThemeMode.light,
    activeProfileId: 'p1',
    notifications: NotificationPreferences(
      holidayReminder: true,
      holidayDaysBefore: 3,
      yearEndReminder: true,
    ),
  );

  test('emits the defaults before the first save', () async {
    expect(await repository.watch().first, const AppSettings());
  });

  test('stores every field', () async {
    expect(await repository.save(custom), isA<Ok<void>>());

    expect(await repository.watch().first, custom);
  });

  test('stores every theme mode', () async {
    for (final mode in AppThemeMode.values) {
      await repository.save(AppSettings(themeMode: mode));

      expect((await repository.watch().first).themeMode, mode);
    }
  });

  test('a save replaces the previous settings', () async {
    await repository.save(custom);

    await repository.save(const AppSettings(themeMode: AppThemeMode.dark));

    expect(
      await repository.watch().first,
      const AppSettings(themeMode: AppThemeMode.dark),
    );
  });

  test('emits after every save', () async {
    final emissions = Emissions(repository.watch());
    addTearDown(emissions.cancel);

    expect(await emissions.next(), const AppSettings());
    await repository.save(custom);
    expect(await emissions.next(), custom);
  });

  test('an unknown active profile is rejected', () async {
    final result = await repository.save(
      const AppSettings(activeProfileId: 'missing'),
    );

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
    expect(await repository.watch().first, const AppSettings());
  });

  test('negative reminder days are rejected', () async {
    final result = await repository.save(
      const AppSettings(
        notifications: NotificationPreferences(holidayDaysBefore: -1),
      ),
    );

    expect(result, isA<Err<void>>());
  });

  group('behaves like FakeSettingsRepository', () {
    test('for the same calls', () async {
      final fake = FakeSettingsRepository();
      await DriftProfileRepository(database).save(SampleData.profile);
      // The fake starts with the sample profile active, so the real one does.
      await repository.save(
        const AppSettings(activeProfileId: SampleData.profileId),
      );
      expect(await repository.watch().first, await fake.watch().first);
      final steps = <Future<Result<void>> Function(SettingsRepository)>[
        (r) => r.save(custom),
        (r) => r.save(const AppSettings(themeMode: AppThemeMode.dark)),
        (r) => r.save(const AppSettings()),
      ];

      for (final step in steps) {
        final expected = await step(fake);
        final actual = await step(repository);

        expect(actual.runtimeType, expected.runtimeType);
        expect(await repository.watch().first, await fake.watch().first);
      }
    });
  });
}
