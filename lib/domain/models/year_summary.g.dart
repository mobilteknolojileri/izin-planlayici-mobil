// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'year_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_YearSummary _$YearSummaryFromJson(Map<String, dynamic> json) => _YearSummary(
  year: (json['year'] as num).toInt(),
  earned: (json['earned'] as num).toDouble(),
  used: (json['used'] as num).toDouble(),
  totalDaysOff: (json['totalDaysOff'] as num).toInt(),
  usedByType:
      (json['usedByType'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry($enumDecode(_$LeaveTypeEnumMap, k), (e as num).toDouble()),
      ) ??
      const <LeaveType, double>{},
  usedByMonth:
      (json['usedByMonth'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(int.parse(k), (e as num).toDouble()),
      ) ??
      const <int, double>{},
);

Map<String, dynamic> _$YearSummaryToJson(
  _YearSummary instance,
) => <String, dynamic>{
  'year': instance.year,
  'earned': instance.earned,
  'used': instance.used,
  'totalDaysOff': instance.totalDaysOff,
  'usedByType': instance.usedByType.map(
    (k, e) => MapEntry(_$LeaveTypeEnumMap[k]!, e),
  ),
  'usedByMonth': instance.usedByMonth.map((k, e) => MapEntry(k.toString(), e)),
};

const _$LeaveTypeEnumMap = {
  LeaveType.annual: 'annual',
  LeaveType.sick: 'sick',
  LeaveType.unpaid: 'unpaid',
  LeaveType.maternity: 'maternity',
  LeaveType.paternity: 'paternity',
  LeaveType.marriage: 'marriage',
  LeaveType.bereavement: 'bereavement',
  LeaveType.adoption: 'adoption',
  LeaveType.disabledChildCare: 'disabledChildCare',
  LeaveType.union: 'union',
  LeaveType.excuse: 'excuse',
  LeaveType.travel: 'travel',
  LeaveType.other: 'other',
};
