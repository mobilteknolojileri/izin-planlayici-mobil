import 'package:izin_planla/domain/models/models.dart';

/// Suggests the legal number of days for excuse leave types.
abstract interface class StatutoryLeaveAdvisor {
  /// Days the law grants for [type], or null when the law sets no number.
  ///
  /// [eventDate] matters for paternity leave, see `docs/mevzuat.md` 1.13.
  int? suggestedDays(LeaveType type, Profile profile, {DateTime? eventDate});
}
