import 'dart:typed_data';

import 'package:izin_planla/data/services/export/leave_report.dart';
import 'package:izin_planla/data/services/export/report_summary.dart';
import 'package:izin_planla/data/services/export/report_text.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Writes a [LeaveReport] as an A4 PDF.
///
/// Title, profile summary, balance, entitlement table, leave table and the
/// legal disclaimer, in that order. Every glyph comes from the embedded
/// [font], which must cover Turkish letters, so the file looks the same on
/// every device.
class LeavePdfEncoder {
  /// Creates an encoder that draws [text] with [font].
  ///
  /// Tests turn [compress] off to read the page objects.
  const new(this.text, {required this.font, this.compress = true});

  /// MIME type of the produced file.
  static const mimeType = 'application/pdf';

  /// Longest text drawn in one table cell. A table row cannot break across
  /// pages, so a longer note is cut.
  static const maxCellLength = 400;

  /// Upper bound of pages, far above any real leave history.
  static const maxPages = 400;

  /// Labels and formats.
  final ReportText text;

  /// Embedded font with Turkish glyphs.
  final pw.Font font;

  /// Whether page streams are compressed.
  final bool compress;

  static const _grey = PdfColor.fromInt(0xFF5F6368);
  static const _rule = PdfColor.fromInt(0xFFDADCE0);
  static const _headerFill = PdfColor.fromInt(0xFFF1F3F4);

  /// PDF bytes of [report].
  Future<Uint8List> encode(LeaveReport report) {
    final l10n = text.l10n;
    final document = pw.Document(
      compress: compress,
      title: l10n.exportPdfTitle,
      creator: l10n.appTitle,
      theme: pw.ThemeData.withFont(
        base: font,
        bold: font,
        italic: font,
        boldItalic: font,
      ),
    );
    final base = pw.TextStyle(font: font, fontSize: 9);

    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(40, 40, 40, 32),
        maxPages: maxPages,
        footer: (context) => pw.Padding(
          padding: const pw.EdgeInsets.only(top: 12),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(l10n.appTitle, style: base.copyWith(color: _grey)),
              pw.Text(
                l10n.exportPageNumber(context.pageNumber, context.pagesCount),
                style: base.copyWith(color: _grey),
              ),
            ],
          ),
        ),
        build: (context) => [
          pw.Text(l10n.exportPdfTitle, style: base.copyWith(fontSize: 20)),
          pw.SizedBox(height: 4),
          pw.Text(
            _cut(report.profile.name),
            style: base.copyWith(fontSize: 13),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            l10n.exportGeneratedOn(text.date(report.date)),
            style: base.copyWith(color: _grey),
          ),
          _heading(l10n.exportSectionProfile, base),
          _pairs(ReportSummary.profile(report, text), base),
          _heading(l10n.exportSectionBalance, base),
          _pairs(ReportSummary.balance(report, text), base),
          _heading(l10n.exportSectionEntitlements, base),
          if (report.periods.isEmpty)
            pw.Text(l10n.exportNoEntitlements, style: base)
          else
            _entitlements(report, base),
          _heading(l10n.exportSectionLeaves, base),
          if (report.entries.isEmpty)
            pw.Text(l10n.exportNoLeaves, style: base)
          else
            _leaves(report, base),
          _heading(l10n.exportSectionDisclaimer, base),
          pw.Paragraph(
            text: l10n.exportDisclaimer,
            style: base.copyWith(color: _grey, lineSpacing: 2),
          ),
        ],
      ),
    );
    return document.save();
  }

  pw.Widget _heading(String title, pw.TextStyle base) => pw.Padding(
    padding: const pw.EdgeInsets.only(top: 18, bottom: 6),
    child: pw.Text(title, style: base.copyWith(fontSize: 13)),
  );

  pw.Widget _pairs(List<(String, Object)> rows, pw.TextStyle base) {
    const cellPadding = pw.EdgeInsets.symmetric(vertical: 3);
    return pw.Table(
      columnWidths: const {0: pw.FlexColumnWidth(2), 1: pw.FlexColumnWidth(3)},
      border: const pw.TableBorder(
        horizontalInside: pw.BorderSide(color: _rule, width: 0.5),
      ),
      children: [
        for (final (label, value) in rows)
          pw.TableRow(
            children: [
              pw.Padding(
                padding: cellPadding,
                child: pw.Text(label, style: base.copyWith(color: _grey)),
              ),
              pw.Padding(
                padding: cellPadding,
                child: pw.Text(_format(value), style: base),
              ),
            ],
          ),
      ],
    );
  }

  pw.Widget _entitlements(LeaveReport report, pw.TextStyle base) {
    final l10n = text.l10n;
    final periods = report.periods;
    final hasYear = periods.any((period) => period.calendarYear != null);
    final hasExpiry = periods.any((period) => period.expiresOn != null);
    final headers = [
      l10n.exportColumnAccrualDate,
      if (hasYear) l10n.exportColumnYear,
      l10n.exportColumnDays,
      if (hasExpiry) l10n.exportColumnExpiresOn,
      l10n.exportColumnLegalBasis,
    ];
    final daysColumn = hasYear ? 2 : 1;
    return _table(
      base,
      headers: headers,
      numericColumns: {if (hasYear) 1, daysColumn},
      rows: [
        for (final period in periods)
          [
            text.date(period.accrualDate),
            if (hasYear) '${period.calendarYear ?? ''}',
            text.number(period.days),
            if (hasExpiry) _optionalDate(period.expiresOn),
            text.legalBasis(period),
          ],
      ],
    );
  }

  pw.Widget _leaves(LeaveReport report, pw.TextStyle base) {
    final l10n = text.l10n;
    return _table(
      base,
      headers: [
        l10n.exportColumnType,
        l10n.exportColumnStart,
        l10n.exportColumnEnd,
        l10n.exportColumnDuration,
        l10n.exportColumnAnnualDays,
        l10n.exportColumnStatus,
        l10n.exportColumnNote,
      ],
      numericColumns: const {4},
      flex: const [3, 2, 2, 2.2, 1.8, 1.8, 3.4],
      rows: [
        for (final entry in report.entries)
          [
            text.leaveType(entry.record),
            text.date(entry.record.range.start),
            text.date(entry.record.range.end),
            text.duration(entry.record),
            text.number(entry.annualDays),
            text.status(entry),
            entry.record.note ?? '',
          ],
      ],
    );
  }

  pw.Widget _table(
    pw.TextStyle base, {
    required List<String> headers,
    required List<List<String>> rows,
    Set<int> numericColumns = const {},
    List<double>? flex,
  }) => pw.TableHelper.fromTextArray(
    headers: headers,
    data: [
      for (final row in rows) [for (final cell in row) _cut(cell)],
    ],
    headerStyle: base.copyWith(fontSize: 8, color: _grey),
    headerDecoration: const pw.BoxDecoration(color: _headerFill),
    headerAlignment: pw.Alignment.centerLeft,
    cellStyle: base.copyWith(fontSize: 8),
    cellPadding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
    cellAlignments: {
      for (final column in numericColumns) column: pw.Alignment.topRight,
    },
    border: const pw.TableBorder(
      horizontalInside: pw.BorderSide(color: _rule, width: 0.5),
      bottom: pw.BorderSide(color: _rule, width: 0.5),
    ),
    columnWidths: flex == null
        ? null
        : {
            for (var i = 0; i < flex.length; i++)
              i: pw.FlexColumnWidth(flex[i]),
          },
  );

  String _optionalDate(DateTime? date) => date == null ? '' : text.date(date);

  String _format(Object value) => switch (value) {
    final num days => text.days(days),
    final DateTime date => text.date(date),
    _ => _cut('$value'),
  };

  /// Returns [value] cut to [maxCellLength], with every line break as LF,
  /// tabs as spaces and no other control characters, which the font cannot
  /// draw.
  static String _cut(String value) {
    var text = value
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n')
        .replaceAll('\t', ' ')
        .replaceAll(_controls, '');
    if (text.length <= maxCellLength) return text;
    var end = maxCellLength;
    final last = text.codeUnitAt(end - 1);
    if (last >= 0xD800 && last <= 0xDBFF) end--;
    text = text.substring(0, end);
    return '$text…';
  }

  static final _controls = RegExp(r'[\x00-\x09\x0B-\x1F\x7F-\x9F]');
}
