import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/database/app_database.dart';
import 'package:izin_planla/data/database/mappers/leave_record_mapper.dart';
import 'package:izin_planla/data/database/mappers/profile_mapper.dart';
import 'package:izin_planla/data/repositories/app_database_mutation.dart';
import 'package:izin_planla/data/repositories/drift_profile_repository.dart';
import 'package:izin_planla/data/repositories/storage_exception.dart';
import 'package:izin_planla/utils/result.dart';

import 'fixtures.dart';

void main() {
  late AppDatabase database;

  setUp(() => database = openTestDatabase());

  tearDown(() => database.close());

  test('commits every statement of the body', () async {
    final result = await database.mutate(() async {
      await database
          .into(database.profiles)
          .insert(ProfileMapper.toRow(simpleProfile('p1')));
      await database
          .into(database.leaveRecords)
          .insert(
            LeaveRecordMapper.toRow(
              leave('l1', start: DateTime.utc(2026, 7, 6)),
            ),
          );
    });

    expect(result, isA<Ok<void>>());
    expect(await database.select(database.profiles).get(), hasLength(1));
    expect(await database.select(database.leaveRecords).get(), hasLength(1));
  });

  test('rolls back every statement when one fails', () async {
    final result = await database.mutate(() async {
      await database
          .into(database.profiles)
          .insert(ProfileMapper.toRow(simpleProfile('p1')));
      // Same id again: the primary key rejects it.
      await database
          .into(database.profiles)
          .insert(ProfileMapper.toRow(simpleProfile('p1')));
    });

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
    expect(await database.select(database.profiles).get(), isEmpty);
  });

  test('watchers never see the writes of a failed mutation', () async {
    final repository = DriftProfileRepository(database);
    final emissions = <List<String>>[];
    final subscription = repository.watchAll().listen(
      (profiles) => emissions.add([for (final p in profiles) p.id]),
    );
    addTearDown(subscription.cancel);
    await repository.watchAll().first;

    await database.mutate(() async {
      await database
          .into(database.profiles)
          .insert(ProfileMapper.toRow(simpleProfile('p1')));
      throw const FormatException('fails after the insert');
    });
    await repository.save(simpleProfile('p2'));
    await repository.watchAll().first;

    expect(emissions.expand((ids) => ids), isNot(contains('p1')));
    expect(emissions.last, ['p2']);
  });

  test('programming errors are not turned into results', () async {
    await expectLater(
      database.mutate(() async => throw StateError('bug')),
      throwsStateError,
    );
  });
}
