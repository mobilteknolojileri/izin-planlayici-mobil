import 'package:izin_planla/domain/models/models.dart';

/// Counts how many leave days a date range costs.
///
/// Follows `docs/mevzuat.md` 1.9 (4857), 2.5 (657) and 4 (half days).
abstract interface class LeaveDayCounter {
  /// Days deducted for [range], with the reason for every day.
  DayCount count(DateRange range, Profile profile, List<Holiday> holidays);
}
