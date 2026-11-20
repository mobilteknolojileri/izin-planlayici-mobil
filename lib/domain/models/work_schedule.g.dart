// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkSchedule _$WorkScheduleFromJson(Map<String, dynamic> json) =>
    _WorkSchedule(
      workDays:
          (json['workDays'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const <int>[1, 2, 3, 4, 5],
      weeklyRestDay:
          (json['weeklyRestDay'] as num?)?.toInt() ?? DateTime.sunday,
      saturdayCountsAsLeave: json['saturdayCountsAsLeave'] as bool? ?? true,
      halfDayDeduction:
          $enumDecodeNullable(
            _$HalfDayDeductionEnumMap,
            json['halfDayDeduction'],
          ) ??
          HalfDayDeduction.half,
      dailyWorkingHours: (json['dailyWorkingHours'] as num?)?.toDouble() ?? 8,
    );

Map<String, dynamic> _$WorkScheduleToJson(_WorkSchedule instance) =>
    <String, dynamic>{
      'workDays': instance.workDays,
      'weeklyRestDay': instance.weeklyRestDay,
      'saturdayCountsAsLeave': instance.saturdayCountsAsLeave,
      'halfDayDeduction': _$HalfDayDeductionEnumMap[instance.halfDayDeduction]!,
      'dailyWorkingHours': instance.dailyWorkingHours,
    };

const _$HalfDayDeductionEnumMap = {
  HalfDayDeduction.zero: 'zero',
  HalfDayDeduction.half: 'half',
  HalfDayDeduction.full: 'full',
};
