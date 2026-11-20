import 'dart:typed_data';

/// A generated file ready to share or save.
class ExportFile {
  /// Creates an export file.
  const new({
    required this.fileName,
    required this.mimeType,
    required this.bytes,
  });

  /// File name including extension.
  final String fileName;

  /// MIME type, e.g. `application/pdf`.
  final String mimeType;

  /// File content.
  final Uint8List bytes;
}
