// XML parts are glued without spaces on purpose.
// ignore_for_file: missing_whitespace_between_adjacent_strings

import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:izin_planla/data/services/export/xlsx_cell.dart';
import 'package:izin_planla/data/services/export/xlsx_sheet.dart';

/// Writes a minimal Office Open XML workbook (`.xlsx`) with `archive`.
///
/// The package holds content types, relationships, the workbook, one part
/// per sheet, styles and shared strings, the parts Excel and LibreOffice
/// need. Text is cleaned of characters XML 1.0 forbids, so any user input
/// gives a file that opens.
class XlsxWriter {
  /// Creates a writer.
  const new();

  /// MIME type of the produced file.
  static const mimeType =
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';

  /// Excel's limit for the characters in one cell.
  static const maxCellLength = 32767;

  static const _maxSheetNameLength = 31;

  // Style indexes in styles.xml cellXfs.
  static const _styleBold = 1;
  static const _styleDate = 2;
  static const _styleWrap = 3;

  static const _xmlHeader =
      '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n';
  static const _mainNs =
      'http://schemas.openxmlformats.org/spreadsheetml/2006/main';
  static const _relNs =
      'http://schemas.openxmlformats.org/officeDocument/2006/relationships';
  static const _packageRelNs =
      'http://schemas.openxmlformats.org/package/2006/relationships';
  static const _contentType =
      'application/vnd.openxmlformats-officedocument.spreadsheetml';

  /// Encodes [sheets] as xlsx bytes.
  ///
  /// [modified] is stored as the time of every zip entry, so the same input
  /// gives the same bytes. Throws [ArgumentError] when [sheets] is empty or
  /// a number is not finite, both programming errors.
  Uint8List encode(List<XlsxSheet> sheets, {DateTime? modified}) {
    if (sheets.isEmpty) {
      throw ArgumentError.value(sheets, 'sheets', 'must not be empty');
    }
    final strings = _SharedStrings();
    final names = _sheetNames(sheets);
    final sheetXml = [
      for (var i = 0; i < sheets.length; i++)
        _sheet(sheets[i], strings, selected: i == 0),
    ];

    final archive = Archive()
      ..add(_file('[Content_Types].xml', _contentTypes(sheets.length)))
      ..add(_file('_rels/.rels', _rootRels()))
      ..add(_file('xl/workbook.xml', _workbook(names)))
      ..add(_file('xl/_rels/workbook.xml.rels', _workbookRels(sheets.length)))
      ..add(_file('xl/styles.xml', _styles()))
      ..add(_file('xl/sharedStrings.xml', strings.toXml()));
    for (var i = 0; i < sheetXml.length; i++) {
      archive.add(_file('xl/worksheets/sheet${i + 1}.xml', sheetXml[i]));
    }
    return ZipEncoder().encodeBytes(
      archive,
      modified: modified ?? DateTime(2026),
    );
  }

  ArchiveFile _file(String name, String xml) =>
      ArchiveFile.bytes(name, utf8.encode(xml));

  String _contentTypes(int sheetCount) {
    final buffer = StringBuffer(_xmlHeader)
      ..write(
        '<Types xmlns="http://schemas.openxmlformats.org/package/2006/'
        'content-types">',
      )
      ..write(
        '<Default Extension="rels" ContentType="application/'
        'vnd.openxmlformats-package.relationships+xml"/>',
      )
      ..write('<Default Extension="xml" ContentType="application/xml"/>')
      ..write(
        '<Override PartName="/xl/workbook.xml" '
        'ContentType="$_contentType.sheet.main+xml"/>',
      );
    for (var i = 1; i <= sheetCount; i++) {
      buffer.write(
        '<Override PartName="/xl/worksheets/sheet$i.xml" '
        'ContentType="$_contentType.worksheet+xml"/>',
      );
    }
    buffer
      ..write(
        '<Override PartName="/xl/styles.xml" '
        'ContentType="$_contentType.styles+xml"/>',
      )
      ..write(
        '<Override PartName="/xl/sharedStrings.xml" '
        'ContentType="$_contentType.sharedStrings+xml"/>',
      )
      ..write('</Types>');
    return buffer.toString();
  }

  String _rootRels() =>
      '$_xmlHeader<Relationships xmlns="$_packageRelNs">'
      '<Relationship Id="rId1" Type="$_relNs/officeDocument" '
      'Target="xl/workbook.xml"/>'
      '</Relationships>';

  String _workbook(List<String> names) {
    final buffer = StringBuffer(_xmlHeader)
      ..write('<workbook xmlns="$_mainNs" xmlns:r="$_relNs">')
      ..write('<bookViews><workbookView activeTab="0"/></bookViews>')
      ..write('<sheets>');
    for (var i = 0; i < names.length; i++) {
      buffer.write(
        '<sheet name="${_escape(names[i])}" sheetId="${i + 1}" '
        'r:id="rId${i + 1}"/>',
      );
    }
    buffer.write('</sheets></workbook>');
    return buffer.toString();
  }

  String _workbookRels(int sheetCount) {
    final buffer = StringBuffer(_xmlHeader)
      ..write('<Relationships xmlns="$_packageRelNs">');
    for (var i = 1; i <= sheetCount; i++) {
      buffer.write(
        '<Relationship Id="rId$i" Type="$_relNs/worksheet" '
        'Target="worksheets/sheet$i.xml"/>',
      );
    }
    buffer
      ..write(
        '<Relationship Id="rId${sheetCount + 1}" Type="$_relNs/styles" '
        'Target="styles.xml"/>',
      )
      ..write(
        '<Relationship Id="rId${sheetCount + 2}" '
        'Type="$_relNs/sharedStrings" Target="sharedStrings.xml"/>',
      )
      ..write('</Relationships>');
    return buffer.toString();
  }

  String _styles() =>
      '$_xmlHeader<styleSheet xmlns="$_mainNs">'
      r'<numFmts count="1"><numFmt numFmtId="164" formatCode="dd\.mm\.yyyy"/>'
      '</numFmts>'
      '<fonts count="2">'
      '<font><sz val="11"/><name val="Calibri"/><family val="2"/></font>'
      '<font><b/><sz val="11"/><name val="Calibri"/><family val="2"/></font>'
      '</fonts>'
      '<fills count="2">'
      '<fill><patternFill patternType="none"/></fill>'
      '<fill><patternFill patternType="gray125"/></fill>'
      '</fills>'
      '<borders count="1"><border><left/><right/><top/><bottom/><diagonal/>'
      '</border></borders>'
      '<cellStyleXfs count="1">'
      '<xf numFmtId="0" fontId="0" fillId="0" borderId="0"/>'
      '</cellStyleXfs>'
      '<cellXfs count="4">'
      '<xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0"/>'
      '<xf numFmtId="0" fontId="1" fillId="0" borderId="0" xfId="0" '
      'applyFont="1"/>'
      '<xf numFmtId="164" fontId="0" fillId="0" borderId="0" xfId="0" '
      'applyNumberFormat="1"/>'
      '<xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0" '
      'applyAlignment="1"><alignment vertical="top" wrapText="1"/></xf>'
      '</cellXfs>'
      '<cellStyles count="1">'
      '<cellStyle name="Normal" xfId="0" builtinId="0"/>'
      '</cellStyles>'
      '</styleSheet>';

  String _sheet(
    XlsxSheet sheet,
    _SharedStrings strings, {
    required bool selected,
  }) {
    final rows = sheet.rows;
    final columnCount = rows.fold(0, (max, row) {
      return row.length > max ? row.length : max;
    });
    final dimension = rows.isEmpty || columnCount == 0
        ? 'A1'
        : 'A1:${_column(columnCount - 1)}${rows.length}';

    final buffer = StringBuffer(_xmlHeader)
      ..write('<worksheet xmlns="$_mainNs" xmlns:r="$_relNs">')
      ..write('<dimension ref="$dimension"/>')
      ..write('<sheetViews><sheetView ')
      ..write(selected ? 'tabSelected="1" ' : '')
      ..write('workbookViewId="0"');
    if (sheet.freezeFirstRow && rows.length > 1) {
      buffer.write(
        '><pane ySplit="1" topLeftCell="A2" activePane="bottomLeft" '
        'state="frozen"/><selection pane="bottomLeft" activeCell="A2" '
        'sqref="A2"/></sheetView>',
      );
    } else {
      buffer.write('/>');
    }
    buffer
      ..write('</sheetViews>')
      ..write('<sheetFormatPr defaultRowHeight="15"/>');

    if (sheet.columnWidths.isNotEmpty) {
      buffer.write('<cols>');
      for (var i = 0; i < sheet.columnWidths.length; i++) {
        buffer.write(
          '<col min="${i + 1}" max="${i + 1}" '
          'width="${sheet.columnWidths[i]}" customWidth="1"/>',
        );
      }
      buffer.write('</cols>');
    }

    buffer.write('<sheetData>');
    for (var r = 0; r < rows.length; r++) {
      buffer.write('<row r="${r + 1}">');
      for (var c = 0; c < rows[r].length; c++) {
        buffer.write(_cell(rows[r][c], '${_column(c)}${r + 1}', strings));
      }
      buffer.write('</row>');
    }
    buffer.write('</sheetData></worksheet>');
    return buffer.toString();
  }

  String _cell(XlsxCell cell, String ref, _SharedStrings strings) {
    switch (cell) {
      case XlsxBlank():
        return '';
      case XlsxText(:final value, :final bold):
        final text = cleanText(value);
        final style = bold
            ? _styleBold
            : text.contains('\n')
            ? _styleWrap
            : 0;
        final styleAttribute = style == 0 ? '' : ' s="$style"';
        return '<c r="$ref" t="s"$styleAttribute>'
            '<v>${strings.indexOf(text)}</v></c>';
      case XlsxNumber(:final value):
        if (!value.isFinite) {
          throw ArgumentError.value(value, 'value', 'must be finite');
        }
        // A whole double is written like an int, `5` instead of `5.0`.
        final whole = value is double && value == value.truncateToDouble();
        final text = whole && value.abs() < 1e15
            ? '${value.toInt()}'
            : '$value';
        return '<c r="$ref"><v>$text</v></c>';
      case XlsxDate(:final value):
        return '<c r="$ref" s="$_styleDate"><v>${serialDate(value)}</v></c>';
    }
  }

  /// Excel serial number of the calendar day of [date] in the 1900 system.
  static int serialDate(DateTime date) => DateTime.utc(
    date.year,
    date.month,
    date.day,
  ).difference(DateTime.utc(1899, 12, 30)).inDays;

  /// Column letters for the zero based [index], `0` is `A`, `26` is `AA`.
  static String _column(int index) {
    var n = index + 1;
    final letters = <int>[];
    while (n > 0) {
      final rest = (n - 1) % 26;
      letters.insert(0, 65 + rest);
      n = (n - 1) ~/ 26;
    }
    return String.fromCharCodes(letters);
  }

  /// Returns [value] cut to [maxCellLength] without characters that XML 1.0
  /// forbids, such as NUL or a lone surrogate.
  static String cleanText(String value) {
    var text = value;
    if (text.length > maxCellLength) {
      var end = maxCellLength;
      final last = text.codeUnitAt(end - 1);
      if (last >= 0xD800 && last <= 0xDBFF) end--;
      text = text.substring(0, end);
    }
    final buffer = StringBuffer();
    for (final rune in text.runes) {
      final allowed =
          rune == 0x9 ||
          rune == 0xA ||
          rune == 0xD ||
          (rune >= 0x20 && rune <= 0xD7FF) ||
          (rune >= 0xE000 && rune <= 0xFFFD) ||
          (rune >= 0x10000 && rune <= 0x10FFFF);
      if (allowed) buffer.writeCharCode(rune);
    }
    return buffer.toString();
  }

  List<String> _sheetNames(List<XlsxSheet> sheets) {
    final used = <String>{};
    final names = <String>[];
    for (var i = 0; i < sheets.length; i++) {
      var name = cleanText(sheets[i].name)
          .replaceAll(RegExp(r'[\[\]:*?/\\]'), ' ')
          .trim();
      name = name.replaceAll(RegExp(r"^'+|'+$"), '').trim();
      if (name.isEmpty) name = 'Sheet${i + 1}';
      if (name.length > _maxSheetNameLength) {
        name = name.substring(0, _maxSheetNameLength).trim();
      }
      var unique = name;
      var suffix = 2;
      while (used.contains(unique.toLowerCase())) {
        final tail = ' ($suffix)';
        final room = _maxSheetNameLength - tail.length;
        unique = '${name.length > room ? name.substring(0, room) : name}$tail';
        suffix++;
      }
      used.add(unique.toLowerCase());
      names.add(unique);
    }
    return names;
  }
}

/// Escapes [text] for XML element content and attribute values.
///
/// `_xHHHH_` sequences are protected too, because Excel reads them as
/// escaped characters.
String _escape(String text) => text
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&apos;')
    .replaceAllMapped(
      RegExp('_(x[0-9A-Fa-f]{4}_)'),
      (match) => '_x005F_${match[1]}',
    );

/// Deduplicated strings of a workbook, in first use order.
class _SharedStrings {
  final _index = <String, int>{};
  var _count = 0;

  int indexOf(String text) {
    _count++;
    return _index.putIfAbsent(text, () => _index.length);
  }

  String toXml() {
    final buffer = StringBuffer(XlsxWriter._xmlHeader)
      ..write(
        '<sst xmlns="${XlsxWriter._mainNs}" count="$_count" '
        'uniqueCount="${_index.length}">',
      );
    for (final text in _index.keys) {
      buffer.write('<si><t xml:space="preserve">${_escape(text)}</t></si>');
    }
    buffer.write('</sst>');
    return buffer.toString();
  }
}
