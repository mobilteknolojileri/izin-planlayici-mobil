// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_range.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DateRange _$DateRangeFromJson(Map<String, dynamic> json) => _DateRange(
  start: const DateOnlyConverter().fromJson(json['start'] as String),
  end: const DateOnlyConverter().fromJson(json['end'] as String),
);

Map<String, dynamic> _$DateRangeToJson(_DateRange instance) =>
    <String, dynamic>{
      'start': const DateOnlyConverter().toJson(instance.start),
      'end': const DateOnlyConverter().toJson(instance.end),
    };
