// Restoring decodes an untrusted file. The generated fromJson code reports
// bad input with Error subtypes, which are caught there on purpose.
// ignore_for_file: avoid_catching_errors

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:izin_planla/data/database/app_database.dart';
import 'package:izin_planla/data/database/mappers/leave_record_mapper.dart';
import 'package:izin_planla/data/database/mappers/overtime_record_mapper.dart';
import 'package:izin_planla/data/database/mappers/profile_mapper.dart';
import 'package:izin_planla/data/database/mappers/settings_mapper.dart';
import 'package:izin_planla/data/repositories/app_database_mutation.dart';
import 'package:izin_planla/data/repositories/backup_codec.dart';
import 'package:izin_planla/data/repositories/backup_exception.dart';
import 'package:izin_planla/data/repositories/storage_exception.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/utils/result.dart';

/// All user data at one moment.
typedef _Snapshot = ({
  AppSettings settings,
  List<Profile> profiles,
  List<LeaveRecord> leaveRecords,
  List<OvertimeRecord> overtimeRecords,
});

/// [BackupCodec] for the drift [AppDatabase].
///
/// The document is one JSON object:
/// `{"format": "izin-planla-data", "formatVersion": 1, "settings": {...},
/// "profiles": [...], "leaveRecords": [...], "overtimeRecords": [...]}`.
/// Each entry is the domain model's `toJson`, lists keep the save order.
/// The export service wraps this document in the backup file envelope.
final class DriftBackupCodec implements BackupCodec {
  /// Creates a codec on the app's [AppDatabase].
  const new(this._database);

  /// Value of the `format` field, marks the document as app data.
  static const format = 'izin-planla-data';

  /// Document version written by this build. A restore refuses documents
  /// with a higher version.
  static const formatVersion = 1;

  final AppDatabase _database;

  /// Reads all data in one transaction, so the document is consistent.
  @override
  Future<Result<String>> exportJson() async {
    try {
      final snapshot = await _database.transaction(_read);
      return Result.ok(jsonEncode(_encode(snapshot)));
    } on Exception catch (error, stackTrace) {
      return Result.error(StorageException.fromDatabase(error, stackTrace));
    }
  }

  /// Replaces all data with [json] in one transaction.
  ///
  /// Fails with [NewerBackupException] for a document from a newer app,
  /// [InvalidBackupException] for anything malformed or inconsistent and
  /// [StorageException] when the database fails. The existing data is kept
  /// in every failure case.
  @override
  Future<Result<void>> restoreJson(String json) async {
    final _Snapshot snapshot;
    switch (_decode(json)) {
      case Ok(:final value):
        snapshot = value;
      case Err(:final error):
        return Result.error(error);
    }
    try {
      await _database.transaction(() async {
        await _deleteAll();
        await _database.batch((batch) {
          batch
            ..insertAll(_database.profiles, [
              for (final profile in snapshot.profiles)
                ProfileMapper.toRow(profile),
            ])
            ..insert(
              _database.settings,
              SettingsMapper.toRow(snapshot.settings),
            )
            ..insertAll(_database.leaveRecords, [
              for (final record in snapshot.leaveRecords)
                LeaveRecordMapper.toRow(record),
            ])
            ..insertAll(_database.overtimeRecords, [
              for (final record in snapshot.overtimeRecords)
                OvertimeRecordMapper.toRow(record),
            ]);
        });
      });
      return const Result.ok(null);
    } on Exception catch (error, stackTrace) {
      final failure = StorageException.fromDatabase(error, stackTrace);
      return Result.error(
        failure.isConstraintViolation
            ? InvalidBackupException(
                'The data breaks a database rule.',
                cause: error,
              )
            : failure,
      );
    }
  }

  /// Deletes all profiles, records and settings in one transaction.
  /// Holidays are bundled with the app and stay.
  @override
  Future<Result<void>> resetAll() => _database.mutate(_deleteAll);

  Future<void> _deleteAll() async {
    // Children first, so no foreign key is ever left dangling.
    await _database.delete(_database.leaveRecords).go();
    await _database.delete(_database.overtimeRecords).go();
    await _database.delete(_database.settings).go();
    await _database.delete(_database.profiles).go();
  }

  Future<_Snapshot> _read() async {
    final settings = await _database
        .select(_database.settings)
        .getSingleOrNull();
    final profiles = await (_database.select(
      _database.profiles,
    )..orderBy([(table) => OrderingTerm.asc(table.rowId)])).get();
    final leaveRecords = await (_database.select(
      _database.leaveRecords,
    )..orderBy([(table) => OrderingTerm.asc(table.rowId)])).get();
    final overtimeRecords = await (_database.select(
      _database.overtimeRecords,
    )..orderBy([(table) => OrderingTerm.asc(table.rowId)])).get();
    return (
      settings: SettingsMapper.toModel(settings),
      profiles: [for (final row in profiles) ProfileMapper.toModel(row)],
      leaveRecords: [
        for (final row in leaveRecords) LeaveRecordMapper.toModel(row),
      ],
      overtimeRecords: [
        for (final row in overtimeRecords) OvertimeRecordMapper.toModel(row),
      ],
    );
  }

  static Map<String, Object?> _encode(_Snapshot snapshot) => {
    'format': format,
    'formatVersion': formatVersion,
    'settings': snapshot.settings.toJson(),
    'profiles': [for (final profile in snapshot.profiles) profile.toJson()],
    'leaveRecords': [
      for (final record in snapshot.leaveRecords) record.toJson(),
    ],
    'overtimeRecords': [
      for (final record in snapshot.overtimeRecords) record.toJson(),
    ],
  };

  static Result<_Snapshot> _decode(String json) {
    final Object? document;
    try {
      document = jsonDecode(json);
    } on FormatException catch (error) {
      return _invalid('The document is not complete JSON.', error);
    }
    if (document is! Map<String, Object?> || document['format'] != format) {
      return _invalid('The document is not İzin Planla data.');
    }
    final version = document['formatVersion'];
    if (version is! int || version < 1) {
      return _invalid('The document has no valid formatVersion.');
    }
    if (version > formatVersion) {
      return Result.error(NewerBackupException(version, formatVersion));
    }
    // Generated fromJson code reports a wrong type with TypeError, an unknown
    // enum name with ArgumentError and, in debug builds, a range ending
    // before it starts with AssertionError. For an untrusted file these are
    // expected failures, not bugs.
    try {
      return _checkConsistency((
        settings: AppSettings.fromJson(_object(document['settings'])),
        profiles: [
          for (final item in _array(document['profiles']))
            Profile.fromJson(_object(item)),
        ],
        leaveRecords: [
          for (final item in _array(document['leaveRecords']))
            LeaveRecord.fromJson(_object(item)),
        ],
        overtimeRecords: [
          for (final item in _array(document['overtimeRecords']))
            OvertimeRecord.fromJson(_object(item)),
        ],
      ));
    } on FormatException catch (error) {
      return _invalid('A field has a malformed value.', error);
    } on TypeError catch (error) {
      return _invalid('A field has the wrong type.', error);
    } on ArgumentError catch (error) {
      return _invalid('A field has an unknown value.', error);
    } on AssertionError catch (error) {
      return _invalid('A field breaks a model rule.', error);
    }
  }

  /// Rejects duplicate ids and references to missing profiles before the
  /// database is touched.
  static Result<_Snapshot> _checkConsistency(_Snapshot snapshot) {
    final profileIds = <String>{};
    for (final profile in snapshot.profiles) {
      if (!profileIds.add(profile.id)) {
        return _invalid('Profile id ${profile.id} appears twice.');
      }
    }
    final leaveIds = <String>{};
    for (final record in snapshot.leaveRecords) {
      if (!leaveIds.add(record.id)) {
        return _invalid('Leave id ${record.id} appears twice.');
      }
      if (!profileIds.contains(record.profileId)) {
        return _invalid('Leave ${record.id} has no profile.');
      }
    }
    final overtimeIds = <String>{};
    for (final record in snapshot.overtimeRecords) {
      if (!overtimeIds.add(record.id)) {
        return _invalid('Overtime id ${record.id} appears twice.');
      }
      if (!profileIds.contains(record.profileId)) {
        return _invalid('Overtime ${record.id} has no profile.');
      }
    }
    final activeProfileId = snapshot.settings.activeProfileId;
    if (activeProfileId != null && !profileIds.contains(activeProfileId)) {
      return _invalid('The active profile does not exist.');
    }
    return Result.ok(snapshot);
  }

  static Map<String, dynamic> _object(Object? value) => switch (value) {
    final Map<String, dynamic> map => map,
    _ => throw const FormatException('Expected a JSON object.'),
  };

  static List<dynamic> _array(Object? value) => switch (value) {
    final List<dynamic> list => list,
    _ => throw const FormatException('Expected a JSON array.'),
  };

  static Result<T> _invalid<T>(String reason, [Object? cause]) =>
      Result.error(InvalidBackupException(reason, cause: cause));
}
