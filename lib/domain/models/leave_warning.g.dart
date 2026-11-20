// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_warning.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeaveWarning _$LeaveWarningFromJson(Map<String, dynamic> json) =>
    _LeaveWarning(
      type: $enumDecode(_$LeaveWarningTypeEnumMap, json['type']),
      params:
          (json['params'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
    );

Map<String, dynamic> _$LeaveWarningToJson(_LeaveWarning instance) =>
    <String, dynamic>{
      'type': _$LeaveWarningTypeEnumMap[instance.type]!,
      'params': instance.params,
    };

const _$LeaveWarningTypeEnumMap = {
  LeaveWarningType.splitRule: 'splitRule',
  LeaveWarningType.insufficientBalance: 'insufficientBalance',
  LeaveWarningType.travelLeaveLimit: 'travelLeaveLimit',
};
