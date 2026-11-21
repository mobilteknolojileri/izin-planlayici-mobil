import 'package:intl/intl.dart';
import 'package:izin_planla/data/services/export/leave_report_entry.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';

/// Turkish labels and value formats shared by the PDF, Excel and CSV exports.
///
/// Dates are `dd.MM.yyyy` and numbers use a decimal comma, the way Turkish
/// spreadsheets read them. Exports are for people and are never restored.
class ReportText {
  /// Creates the formatter over [l10n].
  new(this.l10n) : _number = NumberFormat('#,##0.##', 'tr');

  /// Localized strings.
  final AppLocalizations l10n;

  final NumberFormat _number;

  /// [date] as `dd.MM.yyyy`.
  String date(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString().padLeft(4, '0');
    return '$d.$m.$y';
  }

  /// [value] with a decimal comma and at most two decimals, e.g. `1,5`.
  String number(num value) => _number.format(value);

  /// [value] followed by "gün".
  String days(num value) => l10n.exportDays(number(value));

  /// Name of the law that applies to [type].
  String law(EmploymentType type) => switch (type) {
    EmploymentType.laborLaw => l10n.exportLawLabor,
    EmploymentType.civilServant => l10n.exportLawCivilServant,
  };

  /// Label of the start date field for [type].
  String startDateLabel(EmploymentType type) => switch (type) {
    EmploymentType.laborLaw => l10n.exportFieldStartDateLabor,
    EmploymentType.civilServant => l10n.exportFieldStartDateCivilServant,
  };

  /// [duration] as years, months and days.
  String service(ServiceDuration duration) => l10n.exportServiceDuration(
    duration.years,
    duration.months,
    duration.days,
  );

  /// Type name of [record], the user's own name for [LeaveType.other].
  String leaveType(LeaveRecord record) {
    final custom = record.customTypeName?.trim();
    if (record.type == LeaveType.other && custom != null && custom.isNotEmpty) {
      return custom;
    }
    return switch (record.type) {
      LeaveType.annual => l10n.exportLeaveTypeAnnual,
      LeaveType.sick => l10n.exportLeaveTypeSick,
      LeaveType.unpaid => l10n.exportLeaveTypeUnpaid,
      LeaveType.maternity => l10n.exportLeaveTypeMaternity,
      LeaveType.paternity => l10n.exportLeaveTypePaternity,
      LeaveType.marriage => l10n.exportLeaveTypeMarriage,
      LeaveType.bereavement => l10n.exportLeaveTypeBereavement,
      LeaveType.adoption => l10n.exportLeaveTypeAdoption,
      LeaveType.disabledChildCare => l10n.exportLeaveTypeDisabledChildCare,
      LeaveType.union => l10n.exportLeaveTypeUnion,
      LeaveType.excuse => l10n.exportLeaveTypeExcuse,
      LeaveType.travel => l10n.exportLeaveTypeTravel,
      LeaveType.other => l10n.exportLeaveTypeOther,
    };
  }

  /// Length of [record]: calendar days, a half day or hours.
  String duration(LeaveRecord record) => switch (record.unit) {
    LeaveUnit.days => l10n.exportDurationDays(record.range.dayCount),
    LeaveUnit.halfDay => l10n.exportDurationHalfDay,
    LeaveUnit.hours => l10n.exportDurationHours(number(record.hours ?? 0)),
  };

  /// "Planlandı" or "Kullanıldı".
  String status(LeaveReportEntry entry) =>
      entry.planned ? l10n.exportStatusPlanned : l10n.exportStatusUsed;

  /// Legal references of [period] without repeats, e.g. `4857 md. 53`.
  String legalBasis(EntitlementPeriod period) => {
    for (final rule in period.rules)
      if (rule.legalReference.trim().isNotEmpty) rule.legalReference.trim(),
  }.join(', ');
}
