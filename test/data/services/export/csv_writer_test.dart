import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/services/export/csv_writer.dart';

import 'support/csv_reader.dart';
import 'support/hostile_fixture.dart';

void main() {
  const writer = CsvWriter();

  group('CsvWriter.escape', () {
    test('leaves plain text unquoted', () {
      expect(writer.escape('Yıllık izin'), 'Yıllık izin');
      expect(writer.escape(''), '');
    });

    test('quotes delimiter, quote, CR and LF and doubles quotes', () {
      expect(writer.escape('a;b'), '"a;b"');
      expect(writer.escape('5 "gün"'), '"5 ""gün"""');
      expect(writer.escape('a\nb'), '"a\nb"');
      expect(writer.escape('a\rb'), '"a\rb"');
      expect(writer.escape('a,b'), 'a,b');
    });

    test('neutralizes formula starts with an apostrophe', () {
      expect(writer.escape('=1+1'), "'=1+1");
      expect(writer.escape('+90 555'), "'+90 555");
      expect(writer.escape('-2'), "'-2");
      expect(writer.escape('@SUM(A1)'), "'@SUM(A1)");
      expect(writer.escape('\tx'), "'\tx");
      expect(writer.escape('\rx'), '"\'\rx"');
      expect(writer.escape('a=b'), 'a=b');
    });

    test('quotes a formula that also has a delimiter', () {
      expect(
        writer.escape('=HYPERLINK("x";"y")'),
        '"\'=HYPERLINK(""x"";""y"")"',
      );
    });
  });

  group('CsvWriter.encode', () {
    test('ends every row with CRLF', () {
      expect(
        writer.encode([
          ['a', 'b'],
          ['c', ''],
        ]),
        'a;b\r\nc;\r\n',
      );
    });

    test('writes a UTF-8 byte order mark before the text', () {
      final bytes = writer.encodeBytes([
        ['ığüşöç İĞÜŞÖÇ'],
      ]);
      expect(bytes.sublist(0, 3), [0xEF, 0xBB, 0xBF]);
      expect(utf8.decode(bytes.sublist(3)), 'ığüşöç İĞÜŞÖÇ\r\n');
    });

    test('hostile cells survive a strict RFC 4180 parser', () {
      final rows = [
        for (final text in HostileFixture.texts) [text, 'sabit', text],
      ];
      final parsed = readCsv(writer.encode(rows));

      expect(parsed, hasLength(rows.length));
      for (var i = 0; i < rows.length; i++) {
        final original = rows[i].first;
        final escaped = original.isNotEmpty && '=+-@\t\r'.contains(original[0])
            ? "'$original"
            : original;
        expect(parsed[i], [escaped, 'sabit', escaped], reason: 'row $i');
      }
    });

    test('a comma delimiter quotes commas instead', () {
      const commaWriter = CsvWriter(delimiter: ',');
      expect(commaWriter.escape('a,b'), '"a,b"');
      expect(commaWriter.escape('a;b'), 'a;b');
    });
  });
}
