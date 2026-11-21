import 'package:izin_planla/domain/day_count/statutory_leave_advisor.dart';
import 'package:izin_planla/domain/models/models.dart';

/// Implementation of [StatutoryLeaveAdvisor]. Written by task 08.
///
/// Numbers come from `docs/mevzuat.md` 1.13 (4857 Ek md. 2 and md. 74) and
/// 2.8 (657 md. 104). Where the law gives "up to" a number, that number is
/// suggested. Types the law gives no number for return null.
class DefaultStatutoryLeaveAdvisor implements StatutoryLeaveAdvisor {
  /// Creates the calculator.
  const new();

  /// Maternity leave: 8 weeks before and 16 weeks after birth (4857 md. 74,
  /// 657 md. 104/A). Extra weeks for multiple pregnancy are not suggested.
  static const int maternityDays = 24 * 7;

  /// Births on or after this day give 10 days of paternity leave to a Labour
  /// Law worker, earlier births 5 (7578 md. 16 and 27, mevzuat 1.13).
  static final paternityRaiseDate = DateTime.utc(2026, 5);

  @override
  int? suggestedDays(LeaveType type, Profile profile, {DateTime? eventDate}) =>
      switch (profile.employmentType) {
        EmploymentType.laborLaw => _laborLaw(type, eventDate),
        EmploymentType.civilServant => _civilServant(type),
      };

  /// 4857 Ek md. 2 and md. 74.
  static int? _laborLaw(LeaveType type, DateTime? eventDate) => switch (type) {
    LeaveType.marriage || LeaveType.adoption || LeaveType.bereavement => 3,
    // Without a birth date the law in force today applies.
    LeaveType.paternity =>
      eventDate != null && _isBeforeRaise(eventDate) ? 5 : 10,
    LeaveType.disabledChildCare => 10,
    LeaveType.maternity => maternityDays,
    LeaveType.annual ||
    LeaveType.sick ||
    LeaveType.unpaid ||
    LeaveType.union ||
    LeaveType.excuse ||
    LeaveType.travel ||
    LeaveType.other => null,
  };

  /// 657 md. 104.
  static int? _civilServant(LeaveType type) => switch (type) {
    // 104/B.
    LeaveType.paternity => 10,
    LeaveType.marriage || LeaveType.bereavement => 7,
    // 104/C: the first 10 days of the year, the second 10 are optional.
    LeaveType.excuse => 10,
    // 104/E.
    LeaveType.disabledChildCare => 10,
    // 104/A.
    LeaveType.maternity => maternityDays,
    LeaveType.annual ||
    LeaveType.sick ||
    LeaveType.unpaid ||
    LeaveType.adoption ||
    LeaveType.union ||
    LeaveType.travel ||
    LeaveType.other => null,
  };

  static bool _isBeforeRaise(DateTime date) => DateTime.utc(
    date.year,
    date.month,
    date.day,
  ).isBefore(paternityRaiseDate);
}
