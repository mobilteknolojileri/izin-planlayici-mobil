import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:izin_planla/domain/models/date_only_converter.dart';

part 'overtime_record.freezed.dart';
part 'overtime_record.g.dart';

/// Overtime hours worked on a day.
@freezed
abstract class OvertimeRecord with _$OvertimeRecord {
  /// Creates an overtime record.
  const factory({
    required String id,
    required String profileId,
    @DateOnlyConverter() required DateTime date,
    required double hours,
    String? note,
  }) = _OvertimeRecord;

  /// Creates an overtime record from JSON.
  factory fromJson(Map<String, dynamic> json) => _$OvertimeRecordFromJson(json);
}
