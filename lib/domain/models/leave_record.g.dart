// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeaveRecord _$LeaveRecordFromJson(Map<String, dynamic> json) => _LeaveRecord(
  id: json['id'] as String,
  profileId: json['profileId'] as String,
  type: $enumDecode(_$LeaveTypeEnumMap, json['type']),
  range: DateRange.fromJson(json['range'] as Map<String, dynamic>),
  unit: $enumDecodeNullable(_$LeaveUnitEnumMap, json['unit']) ?? LeaveUnit.days,
  hours: (json['hours'] as num?)?.toDouble(),
  customTypeName: json['customTypeName'] as String?,
  eventDate: _$JsonConverterFromJson<String, DateTime>(
    json['eventDate'],
    const DateOnlyConverter().fromJson,
  ),
  deductsFromAnnual: json['deductsFromAnnual'] as bool? ?? false,
  note: json['note'] as String?,
);

Map<String, dynamic> _$LeaveRecordToJson(_LeaveRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'profileId': instance.profileId,
      'type': _$LeaveTypeEnumMap[instance.type]!,
      'range': instance.range.toJson(),
      'unit': _$LeaveUnitEnumMap[instance.unit]!,
      'hours': ?instance.hours,
      'customTypeName': ?instance.customTypeName,
      'eventDate': ?_$JsonConverterToJson<String, DateTime>(
        instance.eventDate,
        const DateOnlyConverter().toJson,
      ),
      'deductsFromAnnual': instance.deductsFromAnnual,
      'note': ?instance.note,
    };

const _$LeaveTypeEnumMap = {
  LeaveType.annual: 'annual',
  LeaveType.sick: 'sick',
  LeaveType.unpaid: 'unpaid',
  LeaveType.maternity: 'maternity',
  LeaveType.paternity: 'paternity',
  LeaveType.marriage: 'marriage',
  LeaveType.bereavement: 'bereavement',
  LeaveType.adoption: 'adoption',
  LeaveType.disabledChildCare: 'disabledChildCare',
  LeaveType.union: 'union',
  LeaveType.excuse: 'excuse',
  LeaveType.travel: 'travel',
  LeaveType.other: 'other',
};

const _$LeaveUnitEnumMap = {
  LeaveUnit.days: 'days',
  LeaveUnit.halfDay: 'halfDay',
  LeaveUnit.hours: 'hours',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
