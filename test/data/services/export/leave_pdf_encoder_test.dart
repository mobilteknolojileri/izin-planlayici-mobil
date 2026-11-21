import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/services/export/default_export_service.dart';
import 'package:izin_planla/data/services/export/leave_pdf_encoder.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'support/hostile_fixture.dart';
import 'support/report_factory.dart';

/// Number of page objects in an uncompressed PDF.
int pageCount(Uint8List bytes) =>
    RegExp(r'/Type\s*/Page(?![a-zA-Z])')
        .allMatches(latin1.decode(bytes))
        .length;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late pw.Font font;

  setUpAll(() async {
    font = pw.Font.ttf(await rootBundle.load(DefaultExportService.fontAsset));
  });

  LeaveRecord annual(int i) => LeaveRecord(
    id: 'izin-${i.toString().padLeft(3, '0')}',
    profileId: HostileFixture.profileId,
    type: LeaveType.annual,
    range: DateRange(
      start: DateTime.utc(2020 + i ~/ 40, 1 + i % 12, 1 + i % 20),
      end: DateTime.utc(2020 + i ~/ 40, 1 + i % 12, 3 + i % 20),
    ),
    note: 'Not $i: ağaç, ışık, şeker, ödül, çiçek, üzüm',
  );

  Future<Uint8List> encode({
    List<LeaveRecord> leaves = const [],
    List<EntitlementPeriod> periods = const [],
    bool compress = false,
  }) async {
    final report = await buildReport(
      profile: HostileFixture.profile(),
      leaves: leaves,
      periods: periods,
      next: NextAccrual(date: DateTime.utc(2027, 3, 31), days: 22),
    );
    return await LeavePdfEncoder(
      reportText,
      font: font,
      compress: compress,
    ).encode(report);
  }

  test('writes a complete PDF', () async {
    final bytes = await encode(compress: true);
    expect(latin1.decode(bytes.sublist(0, 5)), '%PDF-');
    expect(latin1.decode(bytes).trimRight().endsWith('%%EOF'), isTrue);
  });

  test('a short history fits on one page', () async {
    final bytes = await encode(
      leaves: [annual(0), annual(1)],
      periods: civilServantPeriods(),
    );
    expect(pageCount(bytes), 1);
  });

  test('a long history spreads over the expected pages', () async {
    final sixty = pageCount(await encode(leaves: List.generate(60, annual)));
    final twoHundred = pageCount(
      await encode(leaves: List.generate(200, annual)),
    );

    // About 40 leave rows fit on an A4 page.
    expect(sixty, inInclusiveRange(2, 4));
    expect(twoHundred, inInclusiveRange(5, 10));
    expect(twoHundred, greaterThan(sixty));
  });

  test('embeds the font with every Turkish letter mapped', () async {
    final text = latin1.decode(
      await encode(leaves: [annual(0).copyWith(note: 'ÇĞİÖŞÜ çğıöşü')]),
    );

    expect(text, contains('/FontFile2'));
    for (final letter in 'çğıöşüÇĞİÖŞÜ'.runes) {
      final hex = letter.toRadixString(16).toUpperCase().padLeft(4, '0');
      expect(text, contains('> <$hex>'), reason: String.fromCharCode(letter));
    }
  });

  test('the bundled font has glyphs for Turkish letters', () async {
    final data = await rootBundle.load(DefaultExportService.fontAsset);
    final ttf = TtfParser(data);
    for (final letter in 'çğıöşüÇĞİÖŞÜâîû…'.runes) {
      expect(
        ttf.charToGlyphIndexMap[letter],
        isNotNull,
        reason: String.fromCharCode(letter),
      );
    }
  });

  test('hostile text, long words and empty tables do not break it', () async {
    final hostile = await encode(
      leaves: [
        ...HostileFixture.leaves(),
        LeaveRecord(
          id: 'uzun-kelime',
          profileId: HostileFixture.profileId,
          type: LeaveType.other,
          customTypeName: 'ğ' * 300,
          range: DateRange(
            start: DateTime.utc(2026, 2, 2),
            end: DateTime.utc(2026, 2, 3),
          ),
          note: 'ş' * 5000,
        ),
      ],
    );
    expect(pageCount(hostile), greaterThanOrEqualTo(1));

    final empty = await encode();
    expect(pageCount(empty), 1);
  });
}
