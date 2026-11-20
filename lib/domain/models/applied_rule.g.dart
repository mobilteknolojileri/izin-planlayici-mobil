// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'applied_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppliedRule _$AppliedRuleFromJson(Map<String, dynamic> json) => _AppliedRule(
  code: json['code'] as String,
  legalReference: json['legalReference'] as String,
  params:
      (json['params'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const <String, String>{},
);

Map<String, dynamic> _$AppliedRuleToJson(_AppliedRule instance) =>
    <String, dynamic>{
      'code': instance.code,
      'legalReference': instance.legalReference,
      'params': instance.params,
    };
