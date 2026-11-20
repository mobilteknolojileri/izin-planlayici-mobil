// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_count.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DayCount _$DayCountFromJson(Map<String, dynamic> json) => _DayCount(
  total: (json['total'] as num).toDouble(),
  days:
      (json['days'] as List<dynamic>?)
          ?.map((e) => DayBreakdown.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <DayBreakdown>[],
);

Map<String, dynamic> _$DayCountToJson(_DayCount instance) => <String, dynamic>{
  'total': instance.total,
  'days': instance.days.map((e) => e.toJson()).toList(),
};
