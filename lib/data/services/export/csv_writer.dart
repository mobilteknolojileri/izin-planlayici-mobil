import 'dart:convert';
import 'dart:typed_data';

/// Writes RFC 4180 CSV that spreadsheets open safely.
///
/// Fields that contain the delimiter, a quote, CR or LF are quoted and their
/// quotes doubled. A field that starts with `=`, `+`, `-`, `@`, a tab or CR
/// gets a leading apostrophe, so a spreadsheet shows it as text instead of
/// running it as a formula (OWASP CSV injection).
class CsvWriter {
  /// Creates a writer that separates fields with [delimiter].
  ///
  /// Defaults to `;`, the list separator of Turkish Excel.
  const new({this.delimiter = ';'});

  /// Field separator, a single character.
  final String delimiter;

  /// Byte order mark that makes Excel read the file as UTF-8.
  static const _bom = [0xEF, 0xBB, 0xBF];

  static const _formulaStarts = {'=', '+', '-', '@', '\t', '\r'};

  /// Encodes [rows] as CSV text with CRLF line breaks after every row.
  String encode(List<List<String>> rows) {
    final buffer = StringBuffer();
    for (final row in rows) {
      buffer
        ..writeAll(row.map(escape), delimiter)
        ..write('\r\n');
    }
    return buffer.toString();
  }

  /// Encodes [rows] as UTF-8 bytes that start with a byte order mark.
  Uint8List encodeBytes(List<List<String>> rows) {
    final body = utf8.encode(encode(rows));
    return Uint8List(_bom.length + body.length)
      ..setAll(0, _bom)
      ..setAll(_bom.length, body);
  }

  /// Returns [field] made safe for one CSV cell.
  String escape(String field) {
    var value = field;
    if (value.isNotEmpty && _formulaStarts.contains(value[0])) {
      value = "'$value";
    }
    final needsQuotes =
        value.contains(delimiter) ||
        value.contains('"') ||
        value.contains('\r') ||
        value.contains('\n');
    if (!needsQuotes) return value;
    return '"${value.replaceAll('"', '""')}"';
  }
}
