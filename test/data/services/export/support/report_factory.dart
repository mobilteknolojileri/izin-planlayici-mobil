import 'dart:ui';

import 'package:izin_planla/data/services/export/leave_report.dart';
import 'package:izin_planla/data/services/export/leave_report_builder.dart';
import 'package:izin_planla/data/services/export/report_text.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';

import 'hostile_fixture.dart';
import 'stub_balance_calculator.dart';
import 'stub_entitlement_calculator.dart';
import 'stub_holiday_repository.dart';
import 'stub_leave_repository.dart';
import 'stub_profile_repository.dart';

/// The app's Turkish strings.
final AppLocalizations l10n = lookupAppLocalizations(const Locale('tr'));

/// Labels and formats over [l10n].
final ReportText reportText = ReportText(l10n);

/// Builds a report through [LeaveReportBuilder] with stub sources.
Future<LeaveReport> buildReport({
  required Profile profile,
  List<LeaveRecord> leaves = const [],
  List<EntitlementPeriod> periods = const [],
  NextAccrual? next,
  DateTime? date,
}) async {
  final builder = LeaveReportBuilder(
    profiles: StubProfileRepository([profile]),
    leaves: StubLeaveRepository(leaves),
    holidays: const StubHolidayRepository(),
    entitlementCalculator: StubEntitlementCalculator(
      result: periods,
      next: next,
    ),
    balanceCalculator: const StubBalanceCalculator(),
  );
  final report = await builder.build(
    profile.id,
    date: date ?? HostileFixture.date,
  );
  return report!;
}

/// Entitlement periods of a civil servant with years and expiry dates.
List<EntitlementPeriod> civilServantPeriods() => [
  EntitlementPeriod(
    accrualDate: DateTime.utc(2026),
    days: 20,
    calendarYear: 2026,
    expiresOn: DateTime.utc(2028),
    rules: const [
      AppliedRule(code: 'base', legalReference: '657 md. 102'),
      AppliedRule(code: 'carry', legalReference: '657 md. 103'),
      AppliedRule(code: 'base2', legalReference: '657 md. 102'),
    ],
  ),
  EntitlementPeriod(
    accrualDate: DateTime.utc(2025),
    days: 20,
    calendarYear: 2025,
    expiresOn: DateTime.utc(2027),
  ),
];
