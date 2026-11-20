// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'holiday.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Holiday _$HolidayFromJson(Map<String, dynamic> json) => _Holiday(
  date: const DateOnlyConverter().fromJson(json['date'] as String),
  name: json['name'] as String,
  type: $enumDecode(_$HolidayTypeEnumMap, json['type']),
  halfDay: json['halfDay'] as bool,
);

Map<String, dynamic> _$HolidayToJson(_Holiday instance) => <String, dynamic>{
  'date': const DateOnlyConverter().toJson(instance.date),
  'name': instance.name,
  'type': _$HolidayTypeEnumMap[instance.type]!,
  'halfDay': instance.halfDay,
};

const _$HolidayTypeEnumMap = {
  HolidayType.national: 'national',
  HolidayType.religious: 'religious',
  HolidayType.eve: 'eve',
};
