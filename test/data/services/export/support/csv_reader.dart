/// Parses RFC 4180 CSV [text] separated by [delimiter] into rows.
///
/// Strict on purpose: a quote inside an unquoted field or text after a
/// closing quote throws [FormatException]. Every row must end with CRLF.
List<List<String>> readCsv(String text, {String delimiter = ';'}) {
  final rows = <List<String>>[];
  var row = <String>[];
  final field = StringBuffer();
  var i = 0;
  var quoted = false;
  var fieldStarted = false;

  void endField() {
    row.add(field.toString());
    field.clear();
    fieldStarted = false;
  }

  while (i < text.length) {
    final char = text[i];
    if (quoted) {
      if (char == '"') {
        if (i + 1 < text.length && text[i + 1] == '"') {
          field.write('"');
          i += 2;
          continue;
        }
        quoted = false;
        i++;
        final next = i < text.length ? text[i] : '';
        if (next != delimiter && next != '\r') {
          throw FormatException('text after closing quote', text, i);
        }
        continue;
      }
      field.write(char);
      i++;
      continue;
    }
    if (char == '"') {
      if (fieldStarted || field.isNotEmpty) {
        throw FormatException('quote inside unquoted field', text, i);
      }
      quoted = true;
      fieldStarted = true;
      i++;
      continue;
    }
    if (char == delimiter) {
      endField();
      i++;
      continue;
    }
    if (char == '\r') {
      if (i + 1 >= text.length || text[i + 1] != '\n') {
        throw FormatException('CR without LF', text, i);
      }
      endField();
      rows.add(row);
      row = <String>[];
      i += 2;
      continue;
    }
    if (char == '\n') throw FormatException('LF without CR', text, i);
    field.write(char);
    i++;
  }
  if (quoted) throw FormatException('unclosed quote', text, i);
  if (field.isNotEmpty || row.isNotEmpty) {
    throw FormatException('last row without CRLF', text, i);
  }
  return rows;
}
