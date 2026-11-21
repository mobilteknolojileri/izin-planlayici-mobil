import 'package:flutter/foundation.dart';
import 'package:izin_planla/domain/models/models.dart';

/// The answers of the leave form while the user is filling it in.
///
/// The hours are kept as typed, so a half typed "1," stays on screen.
@immutable
class LeaveDraft {
  /// Creates a draft.
  const new({
    this.type = LeaveType.annual,
    this.unit = LeaveUnit.days,
    this.start,
    this.end,
    this.hours = '',
    this.customName = '',
    this.eventDate,
    this.secondExcuse = false,
    this.note = '',
  });

  /// The answers stored in [record].
  factory fromRecord(LeaveRecord record) => LeaveDraft(
    type: record.type,
    unit: record.unit,
    start: record.range.start,
    end: record.range.end,
    hours: switch (record.hours) {
      null => '',
      final hours when hours == hours.roundToDouble() => '${hours.round()}',
      final hours => '$hours'.replaceAll('.', ','),
    },
    customName: record.customTypeName ?? '',
    eventDate: record.eventDate,
    secondExcuse: record.deductsFromAnnual,
    note: record.note ?? '',
  );

  /// Leave type.
  final LeaveType type;

  /// Whole days, a half day or hours.
  final LeaveUnit unit;

  /// First day, UTC midnight, null until chosen.
  final DateTime? start;

  /// Last day, UTC midnight. Only used for [LeaveUnit.days].
  final DateTime? end;

  /// Hours as typed, for [LeaveUnit.hours].
  final String hours;

  /// Name of an [LeaveType.other] leave.
  final String customName;

  /// Child's birth date for paternity leave.
  final DateTime? eventDate;

  /// Whether this is a civil servant's second excuse block, which reduces
  /// the annual balance (657 art. 104/C).
  final bool secondExcuse;

  /// Free note.
  final String note;

  /// The hours as a number, null when empty or not a number.
  double? get hoursValue {
    final text = hours.trim();
    if (text.isEmpty) return null;
    return double.tryParse(text.replaceAll(',', '.'));
  }

  /// The chosen days, null until a date is chosen. A half day or hourly
  /// leave is a single day.
  DateRange? get range {
    final start = this.start;
    if (start == null) return null;
    final end = this.end;
    if (unit != LeaveUnit.days || end == null || end.isBefore(start)) {
      return DateRange(start: start, end: start);
    }
    return DateRange(start: start, end: end);
  }

  /// A copy with the given answers replaced. A new [start] after the
  /// current end moves the end to the same day, so the end never comes
  /// before the start.
  LeaveDraft copyWith({
    LeaveType? type,
    LeaveUnit? unit,
    DateTime? start,
    DateTime? end,
    String? hours,
    String? customName,
    DateTime? eventDate,
    bool? secondExcuse,
    String? note,
  }) {
    final newStart = start ?? this.start;
    var newEnd = end ?? this.end;
    if (newStart != null && (newEnd == null || newEnd.isBefore(newStart))) {
      newEnd = newStart;
    }
    return LeaveDraft(
      type: type ?? this.type,
      unit: unit ?? this.unit,
      start: newStart,
      end: newEnd,
      hours: hours ?? this.hours,
      customName: customName ?? this.customName,
      eventDate: eventDate ?? this.eventDate,
      secondExcuse: secondExcuse ?? this.secondExcuse,
      note: note ?? this.note,
    );
  }
}
