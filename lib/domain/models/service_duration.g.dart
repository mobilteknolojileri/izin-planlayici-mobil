// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_duration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ServiceDuration _$ServiceDurationFromJson(Map<String, dynamic> json) =>
    _ServiceDuration(
      years: (json['years'] as num?)?.toInt() ?? 0,
      months: (json['months'] as num?)?.toInt() ?? 0,
      days: (json['days'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ServiceDurationToJson(_ServiceDuration instance) =>
    <String, dynamic>{
      'years': instance.years,
      'months': instance.months,
      'days': instance.days,
    };
