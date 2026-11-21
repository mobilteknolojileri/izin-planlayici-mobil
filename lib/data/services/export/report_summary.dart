import 'package:izin_planla/data/services/export/leave_report.dart';
import 'package:izin_planla/data/services/export/report_text.dart';
import 'package:izin_planla/domain/models/models.dart';

/// Label and value rows of the profile and balance summary.
///
/// A value is a [String], a [DateTime] or a [num] of days, so the PDF can
/// format it and Excel can store it as a typed cell. Optional rows appear
/// only when they apply to the profile.
abstract final class ReportSummary {
  /// Rows about the person and their service.
  static List<(String, Object)> profile(LeaveReport report, ReportText text) {
    final l10n = text.l10n;
    final profile = report.profile;
    final civilServant = profile.employmentType == EmploymentType.civilServant;
    return [
      (l10n.exportFieldName, profile.name),
      (l10n.exportFieldLaw, text.law(profile.employmentType)),
      (
        text.startDateLabel(profile.employmentType),
        profile.employmentStartDate,
      ),
      (l10n.exportFieldPriorService, text.service(profile.priorService)),
      (l10n.exportFieldTotalService, text.service(report.totalService)),
      if (report.absenceDays > 0)
        (l10n.exportFieldAbsence, text.days(report.absenceDays)),
      if (profile.contractExtraDays > 0)
        (l10n.exportFieldContractExtraDays, profile.contractExtraDays),
      if (profile.isUnderground) (l10n.exportFieldUnderground, l10n.exportYes),
      if (civilServant && profile.isTeacher)
        (l10n.exportFieldTeacher, l10n.exportYes),
      if (profile.leaveUsedBeforeTracking > 0)
        (l10n.exportFieldUsedBeforeTracking, profile.leaveUsedBeforeTracking),
    ];
  }

  /// Rows of the annual leave balance and the next accrual.
  static List<(String, Object)> balance(LeaveReport report, ReportText text) {
    final l10n = text.l10n;
    final balance = report.balance;
    final next = report.nextAccrual;
    return [
      (l10n.exportFieldEarned, balance.earned),
      (l10n.exportFieldUsed, balance.used),
      (l10n.exportFieldPlanned, balance.planned),
      (l10n.exportFieldRemaining, balance.remaining),
      if (balance.expiringAtYearEnd > 0)
        (l10n.exportFieldExpiring, balance.expiringAtYearEnd),
      if (next != null)
        (
          l10n.exportFieldNextAccrual,
          l10n.exportNextAccrual(text.date(next.date), text.number(next.days)),
        ),
    ];
  }
}
