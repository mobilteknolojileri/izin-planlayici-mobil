import 'dart:typed_data';

import 'package:izin_planla/data/services/export/leave_report.dart';
import 'package:izin_planla/data/services/export/report_summary.dart';
import 'package:izin_planla/data/services/export/report_text.dart';
import 'package:izin_planla/data/services/export/xlsx_cell.dart';
import 'package:izin_planla/data/services/export/xlsx_sheet.dart';
import 'package:izin_planla/data/services/export/xlsx_writer.dart';

/// Writes a [LeaveReport] as an Excel workbook.
///
/// Three sheets: summary, entitlements and leaves. Dates are date cells and
/// day counts are number cells, so the user can sort and sum them.
class LeaveXlsxEncoder {
  /// Creates an encoder that labels cells with [text].
  const new(this.text, {this.writer = const XlsxWriter()});

  /// Labels and formats.
  final ReportText text;

  /// Workbook writer.
  final XlsxWriter writer;

  /// The sheets of [report], in tab order.
  List<XlsxSheet> sheets(LeaveReport report) => [
    _summary(report),
    _entitlements(report),
    _leaves(report),
  ];

  /// Workbook bytes of [report]. [modified] is the zip entry time.
  Uint8List encode(LeaveReport report, {DateTime? modified}) =>
      writer.encode(sheets(report), modified: modified);

  XlsxSheet _summary(LeaveReport report) {
    final l10n = text.l10n;
    return XlsxSheet(
      name: l10n.exportSheetSummary,
      columnWidths: const [34, 40],
      rows: [
        _header([l10n.exportColumnField, l10n.exportColumnValue]),
        for (final (label, value) in [
          ...ReportSummary.profile(report, text),
          ...ReportSummary.balance(report, text),
        ])
          [XlsxText(label), _value(value)],
        const [],
        [XlsxText(l10n.exportGeneratedOn(text.date(report.date)))],
      ],
    );
  }

  XlsxSheet _entitlements(LeaveReport report) {
    final l10n = text.l10n;
    final periods = report.periods;
    final hasYear = periods.any((period) => period.calendarYear != null);
    final hasExpiry = periods.any((period) => period.expiresOn != null);
    return XlsxSheet(
      name: l10n.exportSheetEntitlements,
      freezeFirstRow: true,
      columnWidths: [16, if (hasYear) 8, 8, if (hasExpiry) 28, 30],
      rows: [
        _header([
          l10n.exportColumnAccrualDate,
          if (hasYear) l10n.exportColumnYear,
          l10n.exportColumnDays,
          if (hasExpiry) l10n.exportColumnExpiresOn,
          l10n.exportColumnLegalBasis,
        ]),
        for (final period in periods)
          [
            XlsxDate(period.accrualDate),
            if (hasYear)
              if (period.calendarYear case final year?)
                XlsxNumber(year)
              else
                const XlsxBlank(),
            XlsxNumber(period.days),
            if (hasExpiry)
              if (period.expiresOn case final expires?)
                XlsxDate(expires)
              else
                const XlsxBlank(),
            XlsxText(text.legalBasis(period)),
          ],
      ],
    );
  }

  XlsxSheet _leaves(LeaveReport report) {
    final l10n = text.l10n;
    return XlsxSheet(
      name: l10n.exportSheetLeaves,
      freezeFirstRow: true,
      columnWidths: const [28, 12, 12, 18, 24, 12, 50],
      rows: [
        _header([
          l10n.exportColumnType,
          l10n.exportColumnStart,
          l10n.exportColumnEnd,
          l10n.exportColumnDuration,
          l10n.exportColumnAnnualDays,
          l10n.exportColumnStatus,
          l10n.exportColumnNote,
        ]),
        for (final entry in report.entries)
          [
            XlsxText(text.leaveType(entry.record)),
            XlsxDate(entry.record.range.start),
            XlsxDate(entry.record.range.end),
            XlsxText(text.duration(entry.record)),
            XlsxNumber(entry.annualDays),
            XlsxText(text.status(entry)),
            XlsxText(entry.record.note ?? ''),
          ],
      ],
    );
  }

  List<XlsxCell> _header(List<String> labels) => [
    for (final label in labels) XlsxText(label, bold: true),
  ];

  XlsxCell _value(Object value) => switch (value) {
    final num number => XlsxNumber(number),
    final DateTime date => XlsxDate(date),
    _ => XlsxText('$value'),
  };
}
