import 'package:izin_planla/data/services/export/leave_report_entry.dart';
import 'package:izin_planla/domain/models/models.dart';

/// Everything the PDF, Excel and CSV exports show for one profile.
///
/// Built once by `LeaveReportBuilder`, so all three formats show the same
/// numbers.
class LeaveReport {
  /// Creates a report.
  const new({
    required this.profile,
    required this.date,
    required this.periods,
    required this.nextAccrual,
    required this.balance,
    required this.entries,
    required this.totalService,
    required this.absenceDays,
  });

  /// The exported profile.
  final Profile profile;

  /// Report date as a UTC midnight date.
  final DateTime date;

  /// Entitlement periods earned up to [date], oldest first.
  final List<EntitlementPeriod> periods;

  /// The next accrual after [date], or null when none is expected.
  final NextAccrual? nextAccrual;

  /// Annual leave balance on [date].
  final LeaveBalance balance;

  /// Leave records ordered by start date.
  final List<LeaveReportEntry> entries;

  /// Prior service plus service from the start date up to [date].
  final ServiceDuration totalService;

  /// Days of absence that shift accrual dates (4857 art. 54/2).
  final int absenceDays;
}
