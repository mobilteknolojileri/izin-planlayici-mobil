import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:izin_planla/domain/models/date_only_converter.dart';

part 'date_range.freezed.dart';
part 'date_range.g.dart';

/// An inclusive range of calendar days, from [start] to [end].
@freezed
abstract class DateRange with _$DateRange {
  /// Creates a range. [end] must not be before [start]. Not const because
  /// the assert compares the dates.
  @Assert('!end.isBefore(start)', 'end must not be before start')
  factory({
    @DateOnlyConverter() required DateTime start,
    @DateOnlyConverter() required DateTime end,
  }) = _DateRange;

  const new _();

  /// Creates a range from JSON.
  factory fromJson(Map<String, dynamic> json) => _$DateRangeFromJson(json);

  /// Number of calendar days in the range, both ends included.
  int get dayCount => end.difference(start).inDays + 1;

  /// Whether [day] falls inside the range, both ends included.
  bool contains(DateTime day) => !day.isBefore(start) && !day.isAfter(end);
}
