import 'dart:typed_data';

import 'package:izin_planla/data/services/export/csv_writer.dart';
import 'package:izin_planla/data/services/export/leave_report.dart';
import 'package:izin_planla/data/services/export/report_text.dart';

/// Writes the leave records of a [LeaveReport] as CSV for Excel.
///
/// UTF-8 with a byte order mark and `;` between fields, so Turkish Excel
/// shows the letters and columns correctly. One header row, then one row per
/// leave.
class LeaveCsvEncoder {
  /// Creates an encoder that labels columns with [text].
  const new(this.text, {this.writer = const CsvWriter()});

  /// MIME type of the produced file.
  static const mimeType = 'text/csv';

  /// Labels and formats.
  final ReportText text;

  /// Field writer.
  final CsvWriter writer;

  /// Rows of [report], header first.
  List<List<String>> rows(LeaveReport report) {
    final l10n = text.l10n;
    return [
      [
        l10n.exportColumnType,
        l10n.exportColumnStart,
        l10n.exportColumnEnd,
        l10n.exportColumnDuration,
        l10n.exportColumnAnnualDays,
        l10n.exportColumnStatus,
        l10n.exportColumnNote,
      ],
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
    ];
  }

  /// CSV bytes of [report].
  Uint8List encode(LeaveReport report) => writer.encodeBytes(rows(report));
}
