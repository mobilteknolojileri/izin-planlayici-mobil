// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationPreferences _$NotificationPreferencesFromJson(
  Map<String, dynamic> json,
) => _NotificationPreferences(
  holidayReminder: json['holidayReminder'] as bool? ?? false,
  holidayDaysBefore: (json['holidayDaysBefore'] as num?)?.toInt() ?? 7,
  accrualReminder: json['accrualReminder'] as bool? ?? false,
  plannedLeaveReminder: json['plannedLeaveReminder'] as bool? ?? false,
  plannedLeaveDaysBefore:
      (json['plannedLeaveDaysBefore'] as num?)?.toInt() ?? 1,
  yearEndReminder: json['yearEndReminder'] as bool? ?? false,
);

Map<String, dynamic> _$NotificationPreferencesToJson(
  _NotificationPreferences instance,
) => <String, dynamic>{
  'holidayReminder': instance.holidayReminder,
  'holidayDaysBefore': instance.holidayDaysBefore,
  'accrualReminder': instance.accrualReminder,
  'plannedLeaveReminder': instance.plannedLeaveReminder,
  'plannedLeaveDaysBefore': instance.plannedLeaveDaysBefore,
  'yearEndReminder': instance.yearEndReminder,
};
