import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/services/export/xlsx_cell.dart';
import 'package:izin_planla/data/services/export/xlsx_sheet.dart';
import 'package:izin_planla/data/services/export/xlsx_writer.dart';

import 'support/hostile_fixture.dart';
import 'support/xlsx_parts.dart';
import 'support/xml_element.dart';

void main() {
  const writer = XlsxWriter();
  final modified = DateTime(2026, 11, 21, 10, 30);

  Uint8List write(List<XlsxSheet> sheets) =>
      writer.encode(sheets, modified: modified);

  group('package structure', () {
    late Archive archive;
    late Map<String, XmlElement> parts;

    setUp(() {
      final bytes = write([
        const XlsxSheet(
          name: 'Özet',
          rows: [
            [XlsxText('a')],
          ],
        ),
        const XlsxSheet(
          name: 'İzinler',
          rows: [
            [XlsxNumber(1)],
          ],
        ),
      ]);
      archive = ZipDecoder().decodeBytes(bytes);
      parts = readParts(bytes);
    });

    test('has every part Excel and LibreOffice need', () {
      expect(archive.files.first.name, '[Content_Types].xml');
      expect(
        parts.keys,
        unorderedEquals([
          '[Content_Types].xml',
          '_rels/.rels',
          'xl/workbook.xml',
          'xl/_rels/workbook.xml.rels',
          'xl/styles.xml',
          'xl/sharedStrings.xml',
          'xl/worksheets/sheet1.xml',
          'xl/worksheets/sheet2.xml',
        ]),
      );
    });

    test('every relationship target exists', () {
      final root = parts['_rels/.rels']!.descendants('Relationship').single;
      expect(parts.containsKey(root.attributes['Target']), isTrue);
      for (final rel in parts['xl/_rels/workbook.xml.rels']!.descendants(
        'Relationship',
      )) {
        expect(parts.containsKey('xl/${rel.attributes['Target']}'), isTrue);
      }
    });

    test('every part has a content type', () {
      final types = parts['[Content_Types].xml']!;
      final overrides = {
        for (final o in types.descendants('Override')) o.attributes['PartName'],
      };
      for (final name in parts.keys.where((n) => !n.endsWith('.rels'))) {
        if (name == '[Content_Types].xml') continue;
        expect(overrides, contains('/$name'));
      }
      expect(
        types.descendants('Default').map((d) => d.attributes['Extension']),
        containsAll(['rels', 'xml']),
      );
    });

    test('workbook sheets point to their relationships', () {
      final sheets = parts['xl/workbook.xml']!.descendants('sheet').toList();
      expect(sheets.map((s) => s.attributes['name']), ['Özet', 'İzinler']);
      expect(sheets.map((s) => s.attributes['r:id']), ['rId1', 'rId2']);
      expect(sheets.map((s) => s.attributes['sheetId']), ['1', '2']);
    });

    test('styles hold the two required fills and the date format', () {
      final styles = parts['xl/styles.xml']!;
      final fills = styles.descendants('patternFill').toList();
      expect(fills.map((f) => f.attributes['patternType']), [
        'none',
        'gray125',
      ]);
      expect(
        styles.descendants('numFmt').single.attributes['formatCode'],
        r'dd\.mm\.yyyy',
      );
      expect(styles.descendants('cellXfs').single.children, hasLength(4));
    });
  });

  group('cells', () {
    test('writes text, number, date and blank cells', () {
      final parts = readParts(
        write([
          XlsxSheet(
            name: 'S',
            rows: [
              [
                const XlsxText('Başlık', bold: true),
                const XlsxNumber(1.5),
                XlsxDate(DateTime.utc(2026, 11, 21)),
                const XlsxBlank(),
                const XlsxNumber(-3),
                const XlsxText('iki\nsatır'),
              ],
            ],
          ),
        ]),
      );
      final cells = parts['xl/worksheets/sheet1.xml']!
          .descendants('c')
          .toList();

      expect(cells.map((c) => c.attributes['r']), [
        'A1',
        'B1',
        'C1',
        'E1',
        'F1',
      ]);
      expect(cells[0].attributes, {'r': 'A1', 't': 's', 's': '1'});
      expect(cells[1].attributes, {'r': 'B1'});
      expect(cells[1].descendants('v').single.text, '1.5');
      expect(cells[2].attributes['s'], '2');
      expect(cells[2].descendants('v').single.text, '46347');
      expect(cells[3].descendants('v').single.text, '-3');
      expect(cells[4].attributes['s'], '3');
      expect(sharedStrings(parts), ['Başlık', 'iki\nsatır']);
    });

    test('Excel serial dates match known values', () {
      expect(XlsxWriter.serialDate(DateTime.utc(1900, 3)), 61);
      expect(XlsxWriter.serialDate(DateTime.utc(2026)), 46023);
      expect(XlsxWriter.serialDate(DateTime(2026, 11, 21, 23, 59)), 46347);
    });

    test('shares repeated strings and counts every use', () {
      final parts = readParts(
        write([
          const XlsxSheet(
            name: 'S',
            rows: [
              [XlsxText('a'), XlsxText('b'), XlsxText('a')],
            ],
          ),
        ]),
      );
      final sst = parts['xl/sharedStrings.xml']!;
      expect(sst.attributes['count'], '3');
      expect(sst.attributes['uniqueCount'], '2');
      expect(sharedStrings(parts), ['a', 'b']);
    });

    test('names columns past Z with two letters', () {
      final parts = readParts(
        write([
          XlsxSheet(name: 'S', rows: [List.filled(28, const XlsxNumber(1))]),
        ]),
      );
      final refs = parts['xl/worksheets/sheet1.xml']!
          .descendants('c')
          .map((c) => c.attributes['r'])
          .toList();
      expect(refs.sublist(24), ['Y1', 'Z1', 'AA1', 'AB1']);
      expect(
        parts['xl/worksheets/sheet1.xml']!
            .descendants('dimension')
            .single
            .attributes['ref'],
        'A1:AB1',
      );
    });

    test('hostile text gives valid XML with the cleaned value', () {
      final parts = readParts(
        write([
          XlsxSheet(
            name: 'S',
            rows: [
              for (final text in HostileFixture.texts) [XlsxText(text)],
            ],
          ),
        ]),
      );
      final strings = sharedStrings(parts);
      final expected = <String>{
        for (final text in HostileFixture.texts) XlsxWriter.cleanText(text),
      };

      expect(strings.toSet(), hasLength(expected.length));
      for (final text in expected) {
        final shown = text.replaceAll('_x0041_', '_x005F_x0041_');
        expect(strings, contains(shown));
      }
      expect(
        strings.every((s) => s.length <= XlsxWriter.maxCellLength),
        isTrue,
      );
      expect(strings, contains('Kontrol  karakterleri'));
    });

    test('cleanText drops forbidden characters and lone surrogates', () {
      expect(XlsxWriter.cleanText('a\u0000b\u0008c\tç'), 'abc\tç');
      expect(XlsxWriter.cleanText('x\uD800y'), 'xy');
      expect(XlsxWriter.cleanText('🌴'), '🌴');
      final long = XlsxWriter.cleanText('${'a' * 32766}🌴');
      expect(long, 'a' * 32766);
    });

    test('a non-finite number is a programming error', () {
      expect(
        () => write([
          const XlsxSheet(
            name: 'S',
            rows: [
              [XlsxNumber(double.nan)],
            ],
          ),
        ]),
        throwsArgumentError,
      );
      expect(() => write(const []), throwsArgumentError);
    });
  });

  group('sheets', () {
    test('cleans, cuts and deduplicates sheet names', () {
      final parts = readParts(
        write([
          const XlsxSheet(name: r'a/b:c*d?e[f]g\h', rows: []),
          const XlsxSheet(
            name: 'Çok uzun bir sayfa adı ğüşiöç İĞÜŞÖÇ',
            rows: [],
          ),
          const XlsxSheet(name: 'izinler', rows: []),
          const XlsxSheet(name: 'İZİNLER', rows: []),
          const XlsxSheet(name: 'izinler', rows: []),
          const XlsxSheet(name: "''", rows: []),
        ]),
      );
      final names = [
        for (final s in parts['xl/workbook.xml']!.descendants('sheet'))
          s.attributes['name']!,
      ];

      expect(names[0], 'a b c d e f g h');
      expect(names[1], hasLength(31));
      expect(names[2], 'izinler');
      expect(names[3], 'İZİNLER (2)');
      expect(names[4], 'izinler (3)');
      expect(names[5], 'Sheet6');
      expect(names.map((n) => n.toLowerCase()).toSet(), hasLength(6));
      expect(names.every((n) => n.length <= 31), isTrue);
    });

    test('freezes the header row and sets column widths', () {
      final sheet = readParts(
        write([
          const XlsxSheet(
            name: 'S',
            freezeFirstRow: true,
            columnWidths: [12, 30.5],
            rows: [
              [XlsxText('a'), XlsxText('b')],
              [XlsxNumber(1), XlsxNumber(2)],
            ],
          ),
        ]),
      )['xl/worksheets/sheet1.xml']!;

      final pane = sheet.descendants('pane').single;
      expect(pane.attributes['state'], 'frozen');
      expect(pane.attributes['ySplit'], '1');
      expect(sheet.descendants('col').map((c) => c.attributes['width']), [
        '12.0',
        '30.5',
      ]);
      expect(sheet.descendants('dimension').single.attributes['ref'], 'A1:B2');
      expect(sheet.children.map((c) => c.name), [
        'dimension',
        'sheetViews',
        'sheetFormatPr',
        'cols',
        'sheetData',
      ], reason: 'Excel rejects worksheet children out of schema order');
    });

    test('an empty sheet is still valid', () {
      final sheet = readParts(
        write([const XlsxSheet(name: 'Boş', rows: [])]),
      )['xl/worksheets/sheet1.xml']!;
      expect(sheet.descendants('dimension').single.attributes['ref'], 'A1');
      expect(sheet.descendants('row'), isEmpty);
    });
  });

  test('the same input gives the same bytes', () {
    const sheets = [
      XlsxSheet(
        name: 'S',
        rows: [
          [XlsxText('ğ'), XlsxNumber(2)],
        ],
      ),
    ];
    expect(write(sheets), write(sheets));
  });
}
