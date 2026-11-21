import 'dart:typed_data';

import 'package:izin_planla/data/services/export/export_file.dart';
import 'package:izin_planla/data/services/export/export_gateway.dart';

/// [ExportGateway] that records calls instead of opening system dialogs.
class RecordingExportGateway implements ExportGateway {
  /// Files passed to [share].
  final List<ExportFile> shared = [];

  /// Files passed to [save].
  final List<ExportFile> saved = [];

  /// Value [save] returns, false simulates a cancelled dialog.
  bool saveResult = true;

  /// Bytes [pick] returns, null simulates a cancelled picker.
  Uint8List? picked;

  /// When set, every call throws it.
  Exception? error;

  /// Last `maxBytes` passed to [pick].
  int? lastMaxBytes;

  @override
  Future<void> share(ExportFile file) async {
    if (error case final error?) throw error;
    shared.add(file);
  }

  @override
  Future<bool> save(ExportFile file) async {
    if (error case final error?) throw error;
    saved.add(file);
    return saveResult;
  }

  @override
  Future<Uint8List?> pick({required int maxBytes}) async {
    if (error case final error?) throw error;
    lastMaxBytes = maxBytes;
    return picked;
  }
}
