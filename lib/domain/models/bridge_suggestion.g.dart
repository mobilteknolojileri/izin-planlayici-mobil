// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bridge_suggestion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BridgeSuggestion _$BridgeSuggestionFromJson(Map<String, dynamic> json) =>
    _BridgeSuggestion(
      leaveDays: (json['leaveDays'] as List<dynamic>)
          .map((e) => const DateOnlyConverter().fromJson(e as String))
          .toList(),
      vacation: DateRange.fromJson(json['vacation'] as Map<String, dynamic>),
      totalDaysOff: (json['totalDaysOff'] as num).toInt(),
      leaveDaysUsed: (json['leaveDaysUsed'] as num).toDouble(),
      holidayNames:
          (json['holidayNames'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$BridgeSuggestionToJson(_BridgeSuggestion instance) =>
    <String, dynamic>{
      'leaveDays': instance.leaveDays
          .map(const DateOnlyConverter().toJson)
          .toList(),
      'vacation': instance.vacation.toJson(),
      'totalDaysOff': instance.totalDaysOff,
      'leaveDaysUsed': instance.leaveDaysUsed,
      'holidayNames': instance.holidayNames,
    };
