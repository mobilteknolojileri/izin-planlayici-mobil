// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_balance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeaveBalance _$LeaveBalanceFromJson(Map<String, dynamic> json) =>
    _LeaveBalance(
      earned: (json['earned'] as num).toDouble(),
      used: (json['used'] as num).toDouble(),
      planned: (json['planned'] as num).toDouble(),
      remaining: (json['remaining'] as num).toDouble(),
      expiringAtYearEnd: (json['expiringAtYearEnd'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$LeaveBalanceToJson(_LeaveBalance instance) =>
    <String, dynamic>{
      'earned': instance.earned,
      'used': instance.used,
      'planned': instance.planned,
      'remaining': instance.remaining,
      'expiringAtYearEnd': instance.expiringAtYearEnd,
    };
