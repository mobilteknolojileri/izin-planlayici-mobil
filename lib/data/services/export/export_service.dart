import 'package:izin_planla/data/services/export/export_file.dart';
import 'package:izin_planla/data/services/export/export_format.dart';
import 'package:izin_planla/utils/result.dart';

/// Exports leave history and backups. Implemented by task 13.
abstract interface class ExportService {
  /// Builds the leave history of [profileId] in [format].
  Future<Result<ExportFile>> exportLeaves({
    required String profileId,
    required ExportFormat format,
  });

  /// Opens the system share sheet for [file].
  Future<Result<void>> share(ExportFile file);

  /// Lets the user pick a location and saves [file] there.
  Future<Result<void>> saveToDevice(ExportFile file);

  /// Shares a backup of all data.
  Future<Result<void>> shareBackup();

  /// Lets the user pick a backup file and returns its content, or null when
  /// the user cancels. Restoring is done by the caller after confirmation.
  Future<Result<String?>> pickBackupFile();
}
