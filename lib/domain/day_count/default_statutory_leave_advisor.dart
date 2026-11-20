import 'package:izin_planla/domain/day_count/statutory_leave_advisor.dart';
import 'package:izin_planla/domain/models/models.dart';

/// Implementation of [StatutoryLeaveAdvisor]. Written by task 08.
class DefaultStatutoryLeaveAdvisor implements StatutoryLeaveAdvisor {
  /// Creates the calculator.
  const new();

  @override
  int? suggestedDays(LeaveType type, Profile profile, {DateTime? eventDate}) =>
      throw UnimplementedError();
}
