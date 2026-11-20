// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overtime_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OvertimeRecord _$OvertimeRecordFromJson(Map<String, dynamic> json) =>
    _OvertimeRecord(
      id: json['id'] as String,
      profileId: json['profileId'] as String,
      date: const DateOnlyConverter().fromJson(json['date'] as String),
      hours: (json['hours'] as num).toDouble(),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$OvertimeRecordToJson(_OvertimeRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'profileId': instance.profileId,
      'date': const DateOnlyConverter().toJson(instance.date),
      'hours': instance.hours,
      'note': ?instance.note,
    };
