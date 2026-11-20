import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:izin_planla/domain/models/half_day_deduction.dart';

part 'work_schedule.freezed.dart';
part 'work_schedule.g.dart';

/// Weekly working pattern of a profile.
@freezed
abstract class WorkSchedule with _$WorkSchedule {
  /// Creates a schedule. Defaults to Monday-Friday with Sunday as weekly rest.
  const factory({
    /// Working weekdays as [DateTime.monday] ... [DateTime.sunday].
    @Default(<int>[1, 2, 3, 4, 5]) List<int> workDays,

    /// Legal weekly rest day (hafta tatili), see 4857 art. 46.
    @Default(DateTime.sunday) int weeklyRestDay,

    /// Whether a non-working Saturday counts as a leave day (4857 only).
    /// See `docs/mevzuat.md` section 1.10.
    @Default(true) bool saturdayCountsAsLeave,

    /// Cost of an eve or 28 October morning, see `docs/mevzuat.md` 4.
    @Default(HalfDayDeduction.half) HalfDayDeduction halfDayDeduction,

    /// Working hours per day, used to convert hourly leave to days.
    @Default(8) double dailyWorkingHours,
  }) = _WorkSchedule;

  /// Creates a schedule from JSON.
  factory fromJson(Map<String, dynamic> json) => _$WorkScheduleFromJson(json);
}
