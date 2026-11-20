import 'package:izin_planla/domain/day_count/leave_day_counter.dart';
import 'package:izin_planla/domain/models/models.dart';

/// Implementation of [LeaveDayCounter]. Written by task 08.
class DefaultLeaveDayCounter implements LeaveDayCounter {
  /// Creates the calculator.
  const new();

  @override
  DayCount count(DateRange range, Profile profile, List<Holiday> holidays) =>
      throw UnimplementedError();
}
