import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:izin_planla/data/services/export/export_failure.dart';
import 'package:izin_planla/data/services/export/export_failure_reason.dart';
import 'package:izin_planla/data/services/export/export_file.dart';
import 'package:izin_planla/data/services/export/export_gateway.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// [ExportGateway] on `share_plus`, `file_picker` and `path_provider`.
///
/// A shared file is written to its own folder in the app cache, first under
/// a temporary name and then renamed, so a half written file is never
/// offered. Files of the previous share are deleted first, so personal data
/// does not pile up in the cache.
class PluginExportGateway implements ExportGateway {
  /// Creates the gateway.
  const new();

  static const _folder = 'shared_exports';

  @override
  Future<void> share(ExportFile file) async {
    final cache = await getTemporaryDirectory();
    final folder = Directory('${cache.path}/$_folder');
    if (folder.existsSync()) await folder.delete(recursive: true);
    await folder.create(recursive: true);

    final target = File('${folder.path}/${file.fileName}');
    final partial = File('${target.path}.part');
    try {
      await partial.writeAsBytes(file.bytes, flush: true);
      await partial.rename(target.path);
    } on Exception {
      if (partial.existsSync()) await partial.delete();
      rethrow;
    }

    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile(target.path, mimeType: file.mimeType, name: file.fileName),
        ],
      ),
    );
  }

  @override
  Future<bool> save(ExportFile file) async {
    final uri = await FilePicker.saveFile(
      fileName: file.fileName,
      bytes: file.bytes,
      mimeType: file.mimeType,
    );
    return uri != null;
  }

  @override
  Future<Uint8List?> pick({required int maxBytes}) async {
    final picked = await FilePicker.pickFile();
    if (picked == null) return null;
    final length = await picked.length();
    if (length != null && length > maxBytes) {
      throw const ExportFailure(ExportFailureReason.tooLarge);
    }
    return await picked.readAsBytes();
  }
}
