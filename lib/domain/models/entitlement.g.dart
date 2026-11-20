// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entitlement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Entitlement _$EntitlementFromJson(Map<String, dynamic> json) => _Entitlement(
  profileId: json['profileId'] as String,
  periods:
      (json['periods'] as List<dynamic>?)
          ?.map((e) => EntitlementPeriod.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <EntitlementPeriod>[],
  next: json['next'] == null
      ? null
      : NextAccrual.fromJson(json['next'] as Map<String, dynamic>),
);

Map<String, dynamic> _$EntitlementToJson(_Entitlement instance) =>
    <String, dynamic>{
      'profileId': instance.profileId,
      'periods': instance.periods.map((e) => e.toJson()).toList(),
      'next': ?instance.next?.toJson(),
    };
