import 'package:izin_planla/data/fakes/sample_data.dart';
import 'package:izin_planla/data/repositories/holiday_repository.dart';
import 'package:izin_planla/domain/models/models.dart';

/// [HolidayRepository] returning [SampleData.holidays].
class FakeHolidayRepository implements HolidayRepository {
  @override
  Future<List<Holiday>> all() async => SampleData.holidays;

  @override
  Future<List<Holiday>> inRange(DateRange range) async => [
    ...SampleData.holidays.where((holiday) => range.contains(holiday.date)),
  ];
}
