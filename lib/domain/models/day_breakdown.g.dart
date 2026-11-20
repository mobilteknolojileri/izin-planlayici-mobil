// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_breakdown.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DayBreakdown _$DayBreakdownFromJson(Map<String, dynamic> json) =>
    _DayBreakdown(
      date: const DateOnlyConverter().fromJson(json['date'] as String),
      value: (json['value'] as num).toDouble(),
      reason: $enumDecode(_$DayReasonEnumMap, json['reason']),
      holidayName: json['holidayName'] as String?,
    );

Map<String, dynamic> _$DayBreakdownToJson(_DayBreakdown instance) =>
    <String, dynamic>{
      'date': const DateOnlyConverter().toJson(instance.date),
      'value': instance.value,
      'reason': _$DayReasonEnumMap[instance.reason]!,
      'holidayName': ?instance.holidayName,
    };

const _$DayReasonEnumMap = {
  DayReason.workday: 'workday',
  DayReason.weeklyRest: 'weeklyRest',
  DayReason.holiday: 'holiday',
  DayReason.contractualRest: 'contractualRest',
  DayReason.halfDayHoliday: 'halfDayHoliday',
  DayReason.administrativeLeave: 'administrativeLeave',
  DayReason.weekendInsideLeave: 'weekendInsideLeave',
  DayReason.trimmedEdge: 'trimmedEdge',
};
