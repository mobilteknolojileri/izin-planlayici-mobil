import 'package:izin_planla/data/repositories/holiday_repository.dart';
import 'package:izin_planla/domain/models/models.dart';

/// [HolidayRepository] over a fixed list of holidays.
class StubHolidayRepository implements HolidayRepository {
  /// Creates a repository holding [holidays].
  const new([this.holidays = const []]);

  /// The holidays returned.
  final List<Holiday> holidays;

  @override
  Future<List<Holiday>> all() async => holidays;

  @override
  Future<List<Holiday>> inRange(DateRange range) async => [
    ...holidays.where((holiday) => range.contains(holiday.date)),
  ];
}
