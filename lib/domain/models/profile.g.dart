// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Profile _$ProfileFromJson(Map<String, dynamic> json) => _Profile(
  id: json['id'] as String,
  name: json['name'] as String,
  employmentType: $enumDecode(_$EmploymentTypeEnumMap, json['employmentType']),
  employmentStartDate: const DateOnlyConverter().fromJson(
    json['employmentStartDate'] as String,
  ),
  birthDate: const DateOnlyConverter().fromJson(json['birthDate'] as String),
  workSchedule: json['workSchedule'] == null
      ? const WorkSchedule()
      : WorkSchedule.fromJson(json['workSchedule'] as Map<String, dynamic>),
  priorService: json['priorService'] == null
      ? const ServiceDuration()
      : ServiceDuration.fromJson(json['priorService'] as Map<String, dynamic>),
  isUnderground: json['isUnderground'] as bool? ?? false,
  contractExtraDays: (json['contractExtraDays'] as num?)?.toInt() ?? 0,
  leaveUsedBeforeTracking:
      (json['leaveUsedBeforeTracking'] as num?)?.toDouble() ?? 0,
  isTeacher: json['isTeacher'] as bool? ?? false,
  administrativeLeaveDays:
      (json['administrativeLeaveDays'] as List<dynamic>?)
          ?.map((e) => const DateOnlyConverter().fromJson(e as String))
          .toList() ??
      const <DateTime>[],
  absencePeriods:
      (json['absencePeriods'] as List<dynamic>?)
          ?.map((e) => DateRange.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <DateRange>[],
);

Map<String, dynamic> _$ProfileToJson(_Profile instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'employmentType': _$EmploymentTypeEnumMap[instance.employmentType]!,
  'employmentStartDate': const DateOnlyConverter().toJson(
    instance.employmentStartDate,
  ),
  'birthDate': const DateOnlyConverter().toJson(instance.birthDate),
  'workSchedule': instance.workSchedule.toJson(),
  'priorService': instance.priorService.toJson(),
  'isUnderground': instance.isUnderground,
  'contractExtraDays': instance.contractExtraDays,
  'leaveUsedBeforeTracking': instance.leaveUsedBeforeTracking,
  'isTeacher': instance.isTeacher,
  'administrativeLeaveDays': instance.administrativeLeaveDays
      .map(const DateOnlyConverter().toJson)
      .toList(),
  'absencePeriods': instance.absencePeriods.map((e) => e.toJson()).toList(),
};

const _$EmploymentTypeEnumMap = {
  EmploymentType.laborLaw: 'laborLaw',
  EmploymentType.civilServant: 'civilServant',
};
