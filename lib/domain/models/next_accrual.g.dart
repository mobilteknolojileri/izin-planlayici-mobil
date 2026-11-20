// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'next_accrual.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NextAccrual _$NextAccrualFromJson(Map<String, dynamic> json) => _NextAccrual(
  date: const DateOnlyConverter().fromJson(json['date'] as String),
  days: (json['days'] as num).toInt(),
);

Map<String, dynamic> _$NextAccrualToJson(_NextAccrual instance) =>
    <String, dynamic>{
      'date': const DateOnlyConverter().toJson(instance.date),
      'days': instance.days,
    };
