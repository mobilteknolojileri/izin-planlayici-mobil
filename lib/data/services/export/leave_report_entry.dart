import 'package:izin_planla/domain/models/models.dart';

/// One leave record of a `LeaveReport` with its computed numbers.
class LeaveReportEntry {
  /// Creates an entry.
  const new({
    required this.record,
    required this.annualDays,
    required this.planned,
  });

  /// The stored record.
  final LeaveRecord record;

  /// Days this record takes from the annual balance, 0 for leave types that
  /// do not reduce it.
  final double annualDays;

  /// Whether the leave starts after the report date.
  final bool planned;
}
