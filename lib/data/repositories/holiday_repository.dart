import 'package:izin_planla/domain/models/models.dart';

/// Reads official holidays from `assets/holidays/`. Implemented by task 10.
abstract interface class HolidayRepository {
  /// All bundled holidays, ordered by date.
  Future<List<Holiday>> all();

  /// Holidays inside [range], ordered by date.
  Future<List<Holiday>> inRange(DateRange range);
}
