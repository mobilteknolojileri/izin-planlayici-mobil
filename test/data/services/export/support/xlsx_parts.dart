import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';

import 'xml_element.dart';

/// Unzips [bytes] and parses every XML part, failing on malformed XML.
Map<String, XmlElement> readParts(Uint8List bytes) {
  final archive = ZipDecoder().decodeBytes(bytes);
  return {
    for (final file in archive.files)
      file.name: XmlElement.parse(utf8.decode(file.content)),
  };
}

/// The shared strings of a workbook in index order.
List<String> sharedStrings(Map<String, XmlElement> parts) => [
  for (final si in parts['xl/sharedStrings.xml']!.descendants('si'))
    si.descendants('t').single.text,
];

/// Cell values of sheet [index] (1 based) as text, row by row.
///
/// Shared strings are resolved, numbers and date serials stay as written.
List<List<String>> sheetValues(Map<String, XmlElement> parts, int index) {
  final strings = sharedStrings(parts);
  final sheet = parts['xl/worksheets/sheet$index.xml']!;
  return [
    for (final row in sheet.descendants('row'))
      [
        for (final cell in row.children)
          if (cell.attributes['t'] == 's')
            strings[int.parse(cell.descendants('v').single.text)]
          else
            cell.descendants('v').single.text,
      ],
  ];
}
