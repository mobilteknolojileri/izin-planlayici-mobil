// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entitlement_period.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EntitlementPeriod _$EntitlementPeriodFromJson(Map<String, dynamic> json) =>
    _EntitlementPeriod(
      accrualDate: const DateOnlyConverter().fromJson(
        json['accrualDate'] as String,
      ),
      days: (json['days'] as num).toInt(),
      calendarYear: (json['calendarYear'] as num?)?.toInt(),
      expiresOn: _$JsonConverterFromJson<String, DateTime>(
        json['expiresOn'],
        const DateOnlyConverter().fromJson,
      ),
      rules:
          (json['rules'] as List<dynamic>?)
              ?.map((e) => AppliedRule.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <AppliedRule>[],
    );

Map<String, dynamic> _$EntitlementPeriodToJson(_EntitlementPeriod instance) =>
    <String, dynamic>{
      'accrualDate': const DateOnlyConverter().toJson(instance.accrualDate),
      'days': instance.days,
      'calendarYear': ?instance.calendarYear,
      'expiresOn': ?_$JsonConverterToJson<String, DateTime>(
        instance.expiresOn,
        const DateOnlyConverter().toJson,
      ),
      'rules': instance.rules.map((e) => e.toJson()).toList(),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
