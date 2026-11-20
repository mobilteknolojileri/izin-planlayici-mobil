import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:izin_planla/domain/models/date_only_converter.dart';
import 'package:izin_planla/domain/models/date_range.dart';
import 'package:izin_planla/domain/models/leave_type.dart';
import 'package:izin_planla/domain/models/leave_unit.dart';

part 'leave_record.freezed.dart';
part 'leave_record.g.dart';

/// A leave taken or planned by a profile.
///
/// A record whose range starts after today is planned, otherwise used.
@freezed
abstract class LeaveRecord with _$LeaveRecord {
  /// Creates a leave record.
  const factory({
    required String id,
    required String profileId,
    required LeaveType type,
    required DateRange range,
    @Default(LeaveUnit.days) LeaveUnit unit,

    /// Hours, only when [unit] is [LeaveUnit.hours].
    double? hours,

    /// Name shown for [LeaveType.other].
    String? customTypeName,

    /// Event date, e.g. the child's birth date for paternity leave.
    @DateOnlyConverter() DateTime? eventDate,

    /// Whether this record reduces the annual balance although [type] is not
    /// annual. Used for the second excuse block of 657 art. 104/C.
    @Default(false) bool deductsFromAnnual,
    String? note,
  }) = _LeaveRecord;

  /// Creates a leave record from JSON.
  factory fromJson(Map<String, dynamic> json) => _$LeaveRecordFromJson(json);
}
