import 'dart:convert';

import 'package:izin_planla/data/services/export/export_file.dart';
import 'package:izin_planla/data/services/export/export_format.dart';
import 'package:izin_planla/data/services/export/export_service.dart';
import 'package:izin_planla/utils/result.dart';

/// [ExportService] that produces a tiny text file and shares nothing.
class FakeExportService implements ExportService {
  @override
  Future<Result<ExportFile>> exportLeaves({
    required String profileId,
    required ExportFormat format,
  }) async => Result.ok(
    ExportFile(
      fileName: 'izinler.${format.name}',
      mimeType: 'text/plain',
      bytes: utf8.encode('sample'),
    ),
  );

  @override
  Future<Result<void>> share(ExportFile file) async => const Result.ok(null);

  @override
  Future<Result<void>> saveToDevice(ExportFile file) async =>
      const Result.ok(null);

  @override
  Future<Result<void>> shareBackup() async => const Result.ok(null);

  @override
  Future<Result<String?>> pickBackupFile() async => const Result.ok(null);
}
