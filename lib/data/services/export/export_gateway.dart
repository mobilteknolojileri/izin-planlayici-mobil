import 'dart:typed_data';

import 'package:izin_planla/data/services/export/export_file.dart';

/// Thin seam over the share sheet, the save dialog and the file picker.
///
/// Keeps plugins out of `DefaultExportService`, so the formats and the
/// backup checks are tested without a device. Methods may throw, the
/// service turns errors into failures.
abstract interface class ExportGateway {
  /// Opens the system share sheet for [file].
  Future<void> share(ExportFile file);

  /// Lets the user pick a location and writes [file] there. Returns false
  /// when the user cancels.
  Future<bool> save(ExportFile file);

  /// Lets the user pick one file and returns its bytes, or null when the
  /// user cancels.
  ///
  /// Throws `ExportFailure` with `ExportFailureReason.tooLarge` before
  /// reading a file longer than [maxBytes].
  Future<Uint8List?> pick({required int maxBytes});
}
