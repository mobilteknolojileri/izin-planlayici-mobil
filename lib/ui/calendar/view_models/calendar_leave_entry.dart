import 'package:izin_planla/domain/models/models.dart';
import 'package:material_ui/material_ui.dart';

/// A leave record shown on one calendar day.
@immutable
class CalendarLeaveEntry {
  /// Creates an entry.
  const new({required this.record, required this.planned, this.personName});

  /// The stored leave.
  final LeaveRecord record;

  /// Whether the leave starts after today.
  final bool planned;

  /// Name of the person, only in the everyone view.
  final String? personName;
}
