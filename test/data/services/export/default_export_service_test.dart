import 'dart:convert';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/database/app_database.dart';
import 'package:izin_planla/data/repositories/backup_codec.dart';
import 'package:izin_planla/data/repositories/drift_backup_codec.dart';
import 'package:izin_planla/data/repositories/leave_repository.dart';
import 'package:izin_planla/data/services/export/backup_envelope_codec.dart';
import 'package:izin_planla/data/services/export/default_export_service.dart';
import 'package:izin_planla/data/services/export/export_failure.dart';
import 'package:izin_planla/data/services/export/export_failure_reason.dart';
import 'package:izin_planla/data/services/export/export_file.dart';
import 'package:izin_planla/data/services/export/export_format.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/utils/result.dart';

import 'support/bytes.dart';
import 'support/hostile_fixture.dart';
import 'support/recording_export_gateway.dart';
import 'support/report_factory.dart';
import 'support/stub_backup_codec.dart';
import 'support/stub_balance_calculator.dart';
import 'support/stub_entitlement_calculator.dart';
import 'support/stub_holiday_repository.dart';
import 'support/stub_leave_repository.dart';
import 'support/stub_profile_repository.dart';

class _FailingLeaveRepository implements LeaveRepository {
  @override
  Stream<List<LeaveRecord>> watchForProfile(String profileId) =>
      Stream.error(Exception('disk'));

  @override
  Future<Result<void>> save(LeaveRecord record) => throw UnimplementedError();

  @override
  Future<Result<void>> delete(String id) => throw UnimplementedError();
}

T okValue<T>(Result<T> result) => switch (result) {
  Ok(:final value) => value,
  Err(:final error) => fail('expected Ok, got $error'),
};

ExportFailureReason reasonOf(Result<Object?> result) => switch (result) {
  Ok(:final value) => fail('expected a failure, got $value'),
  Err(:final error) => (error as ExportFailure).reason,
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late RecordingExportGateway gateway;
  late StubBackupCodec codec;
  final now = DateTime(2026, 11, 21, 14, 5);

  setUp(() {
    gateway = RecordingExportGateway();
    codec = StubBackupCodec(HostileFixture.backupDocument());
  });

  DefaultExportService service({
    String appVersion = '1.0.0+1',
    int schemaVersion = 1,
    LeaveRepository? leaves,
  }) => DefaultExportService(
    profiles: StubProfileRepository([HostileFixture.profile()]),
    leaves: leaves ?? StubLeaveRepository(HostileFixture.leaves()),
    holidays: const StubHolidayRepository(),
    entitlementCalculator: StubEntitlementCalculator(
      result: civilServantPeriods(),
      next: NextAccrual(date: DateTime.utc(2027, 3, 31), days: 22),
    ),
    balanceCalculator: const StubBalanceCalculator(),
    backupCodec: codec,
    l10n: l10n,
    appVersion: appVersion,
    schemaVersion: schemaVersion,
    gateway: gateway,
    now: () => now,
  );

  Future<ExportFile> export(ExportFormat format) async => okValue<ExportFile>(
    await service().exportLeaves(
      profileId: HostileFixture.profileId,
      format: format,
    ),
  );

  group('exportLeaves', () {
    test('builds each format with its name, type and signature', () async {
      final csv = await export(ExportFormat.csv);
      final xlsx = await export(ExportFormat.xlsx);
      final pdf = await export(ExportFormat.pdf);
      const stem = 'izin-gecmisi-ayse-gul-cig-ozturk-hyperlink-x-ikinci-s';

      expect(csv.fileName, '$stem-2026-11-21.csv');
      expect(xlsx.fileName, '$stem-2026-11-21.xlsx');
      expect(pdf.fileName, '$stem-2026-11-21.pdf');
      expect(csv.mimeType, 'text/csv');
      expect(
        xlsx.mimeType,
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      );
      expect(pdf.mimeType, 'application/pdf');
      expect(csv.bytes.sublist(0, 3), [0xEF, 0xBB, 0xBF]);
      expect(xlsx.bytes.sublist(0, 2), 'PK'.codeUnits);
      expect(latin1.decode(pdf.bytes.sublist(0, 5)), '%PDF-');
      expect(utf8.decode(csv.bytes), contains('Yıllık izinden düşen gün'));
    });

    test('fails for an unknown profile', () async {
      final result = await service().exportLeaves(
        profileId: 'yok',
        format: ExportFormat.pdf,
      );
      expect(reasonOf(result), ExportFailureReason.profileNotFound);
    });

    test('turns a storage error into a failure', () async {
      final result = await service(leaves: _FailingLeaveRepository())
          .exportLeaves(
            profileId: HostileFixture.profileId,
            format: ExportFormat.csv,
          );
      expect(reasonOf(result), ExportFailureReason.buildFailed);
      expect((result as Err).error.toString(), contains('disk'));
    });
  });

  group('fileName', () {
    test('drops Turkish marks and joins parts with dashes', () {
      expect(
        DefaultExportService.fileName([
          'İzin geçmişi',
          'Ayşe IŞIK Çağrı Öğüt',
          '2026-11-21',
        ], 'pdf'),
        'izin-gecmisi-ayse-isik-cagri-ogut-2026-11-21.pdf',
      );
    });

    test('skips empty parts and cuts long ones', () {
      expect(
        DefaultExportService.fileName(['', '🌴 ', '../'], 'csv'),
        'export.csv',
      );
      expect(
        DefaultExportService.fileName(['a' * 60, 'b'], 'json'),
        '${'a' * 40}-b.json',
      );
      expect(
        DefaultExportService.fileName([r'a/b\c:d*e?f"g<h>i|j'], 'csv'),
        'a-b-c-d-e-f-g-h-i-j.csv',
      );
    });
  });

  group('share and save', () {
    test('share hands the file to the gateway', () async {
      final file = await export(ExportFormat.csv);
      expect(await service().share(file), isA<Ok<void>>());
      expect(gateway.shared.single, same(file));
    });

    test('a share error becomes a failure', () async {
      gateway.error = Exception('no activity');
      final file = await export(ExportFormat.csv);
      expect(
        reasonOf(await service().share(file)),
        ExportFailureReason.shareFailed,
      );
    });

    test('save succeeds, reports a cancel and wraps errors', () async {
      final file = await export(ExportFormat.xlsx);
      expect(await service().saveToDevice(file), isA<Ok<void>>());
      expect(gateway.saved.single, same(file));

      gateway.saveResult = false;
      expect(
        reasonOf(await service().saveToDevice(file)),
        ExportFailureReason.cancelled,
      );

      gateway.error = Exception('no space');
      expect(
        reasonOf(await service().saveToDevice(file)),
        ExportFailureReason.saveFailed,
      );
    });
  });

  group('backup', () {
    test('shares one versioned JSON file', () async {
      expect(await service().shareBackup(), isA<Ok<void>>());
      final file = gateway.shared.single;
      final map = jsonDecode(utf8.decode(file.bytes)) as Map<String, dynamic>;

      expect(file.fileName, 'izin-planla-yedek-2026-11-21-1405.json');
      expect(file.mimeType, 'application/json');
      expect(map['format'], BackupEnvelopeCodec.formatMarker);
      expect(map['appVersion'], '1.0.0+1');
      expect(map['schemaVersion'], 1);
      expect(map['exportedAtUtc'], now.toUtc().toIso8601String());
      expect(map['payload'], jsonDecode(HostileFixture.backupDocument()));
    });

    test('export, restore and export again gives the same file', () async {
      final first = okValue(await service().createBackup());
      final original = codec.document;

      gateway.picked = first.bytes;
      final payload = okValue(await service().pickBackupFile());
      expect(payload, isNotNull);
      expect(await codec.restoreJson(payload!), isA<Ok<void>>());
      expect(jsonDecode(codec.document), jsonDecode(original));

      final second = okValue(await service().createBackup());
      expect(second.bytes, first.bytes);
      expect(second.fileName, first.fileName);
    });

    test('a codec failure or a non JSON document fails the backup', () async {
      codec.exportError = Exception('locked');
      expect(
        reasonOf(await service().shareBackup()),
        ExportFailureReason.backupFailed,
      );
      codec
        ..exportError = null
        ..document = 'not json';
      expect(
        reasonOf(await service().shareBackup()),
        ExportFailureReason.backupFailed,
      );
      expect(gateway.shared, isEmpty);
    });

    test(
      'a share error after building the backup is a share failure',
      () async {
        gateway.error = Exception('no activity');
        expect(
          reasonOf(await service().shareBackup()),
          ExportFailureReason.shareFailed,
        );
      },
    );
  });

  group('pickBackupFile', () {
    test('returns null when the user cancels', () async {
      expect(okValue(await service().pickBackupFile()), isNull);
      expect(gateway.lastMaxBytes, BackupEnvelopeCodec.maxBytes);
      expect(codec.restores, 0);
    });

    test('passes picker failures through', () async {
      gateway.error = const ExportFailure(ExportFailureReason.tooLarge);
      expect(
        reasonOf(await service().pickBackupFile()),
        ExportFailureReason.tooLarge,
      );
      gateway.error = Exception('permission');
      expect(
        reasonOf(await service().pickBackupFile()),
        ExportFailureReason.pickFailed,
      );
    });

    test('refuses every export format as a restore source', () async {
      for (final format in ExportFormat.values) {
        gateway.picked = (await export(format)).bytes;
        expect(
          reasonOf(await service().pickBackupFile()),
          ExportFailureReason.notBackup,
          reason: format.name,
        );
      }
    });

    test('refuses a backup from a newer schema', () async {
      gateway.picked = okValue(await service(schemaVersion: 2).createBackup())
          .bytes;
      expect(
        reasonOf(await service().pickBackupFile()),
        ExportFailureReason.newerVersion,
      );
    });

    test('restores a backup from a newer app with the same schema', () async {
      gateway.picked = okValue(
        await service(appVersion: '1.0.1+2').createBackup(),
      ).bytes;
      final payload = okValue(await service().pickBackupFile());

      expect(payload, isNotNull);
      expect(await codec.restoreJson(payload!), isA<Ok<void>>());
      expect(
        jsonDecode(codec.document),
        jsonDecode(HostileFixture.backupDocument()),
      );
    });

    test('accepts a backup from an older app and schema', () async {
      gateway.picked = okValue(await service().createBackup()).bytes;
      final payload = okValue(
        await service(appVersion: '2.0.0+9', schemaVersion: 3).pickBackupFile(),
      );
      expect(jsonDecode(payload!), jsonDecode(HostileFixture.backupDocument()));
    });

    test('refuses a damaged backup', () async {
      gateway.picked = withChangedByte(
        okValue(await service().createBackup()).bytes,
        '"emptyText"',
        'E',
      );
      expect(
        reasonOf(await service().pickBackupFile()),
        ExportFailureReason.checksumMismatch,
      );
    });
  });

  group('with the drift backup codec', () {
    DefaultExportService over(BackupCodec backupCodec, int schemaVersion) =>
        DefaultExportService(
          profiles: StubProfileRepository(const []),
          leaves: StubLeaveRepository(const []),
          holidays: const StubHolidayRepository(),
          entitlementCalculator: const StubEntitlementCalculator(),
          balanceCalculator: const StubBalanceCalculator(),
          backupCodec: backupCodec,
          l10n: l10n,
          appVersion: '1.0.0+1',
          schemaVersion: schemaVersion,
          gateway: gateway,
          now: () => now,
        );

    test('backup, restore into an empty database and backup again', () async {
      driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
      final source = AppDatabase(NativeDatabase.memory());
      final target = AppDatabase(NativeDatabase.memory());
      addTearDown(source.close);
      addTearDown(target.close);
      final sourceCodec = DriftBackupCodec(source);
      final targetCodec = DriftBackupCodec(target);
      final seeded = await sourceCodec.restoreJson(
        jsonEncode({
          'format': DriftBackupCodec.format,
          'formatVersion': DriftBackupCodec.formatVersion,
          'settings': const AppSettings(
            activeProfileId: HostileFixture.profileId,
          ).toJson(),
          'profiles': [HostileFixture.profile().toJson()],
          'leaveRecords': [
            for (final leave in HostileFixture.leaves()) leave.toJson(),
          ],
          'overtimeRecords': <Object>[],
        }),
      );
      expect(seeded, isA<Ok<void>>());

      final schema = source.schemaVersion;
      final first = okValue(await over(sourceCodec, schema).createBackup());
      gateway.picked = first.bytes;
      final payload = okValue(await over(targetCodec, schema).pickBackupFile());
      expect(await targetCodec.restoreJson(payload!), isA<Ok<void>>());
      final second = okValue(await over(targetCodec, schema).createBackup());

      expect(utf8.decode(second.bytes), utf8.decode(first.bytes));
      expect(second.bytes, first.bytes);
    });
  });
}
