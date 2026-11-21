import 'package:izin_planla/data/repositories/holiday_repository.dart';
import 'package:izin_planla/data/repositories/leave_repository.dart';
import 'package:izin_planla/data/repositories/profile_repository.dart';
import 'package:izin_planla/data/services/export/leave_report.dart';
import 'package:izin_planla/data/services/export/leave_report_entry.dart';
import 'package:izin_planla/domain/day_count/balance_calculator.dart';
import 'package:izin_planla/domain/entitlement/entitlement_calculator.dart';
import 'package:izin_planla/domain/models/models.dart';

/// Collects a profile's data and the domain results into a [LeaveReport].
///
/// All numbers come from the domain calculators, so an export shows the same
/// balance as the app.
class LeaveReportBuilder {
  /// Creates a builder over the given sources.
  const new({
    required this._profiles,
    required this._leaves,
    required this._holidays,
    required this._entitlementCalculator,
    required this._balanceCalculator,
  });

  final ProfileRepository _profiles;
  final LeaveRepository _leaves;
  final HolidayRepository _holidays;
  final EntitlementCalculator _entitlementCalculator;
  final BalanceCalculator _balanceCalculator;

  /// Builds the report of [profileId] on [date], or null when the profile
  /// does not exist.
  ///
  /// [date] is reduced to its calendar day. Errors of the sources are passed
  /// on to the caller.
  Future<LeaveReport?> build(String profileId, {required DateTime date}) async {
    final today = DateTime.utc(date.year, date.month, date.day);
    final profile = await _profiles.findById(profileId);
    if (profile == null) return null;
    final records = await _leaves.watchForProfile(profileId).first;
    final holidays = await _holidays.all();

    final periods = [..._entitlementCalculator.periods(profile, until: today)]
      ..sort((a, b) => a.accrualDate.compareTo(b.accrualDate));

    LeaveBalance balanceOf(List<LeaveRecord> leaves) =>
        _balanceCalculator.balance(
          profile: profile,
          periods: periods,
          leaves: leaves,
          holidays: holidays,
          today: today,
        );

    // A record's cost is how much it moves the balance on its own, so the
    // export never repeats the counting rules of the domain.
    final empty = balanceOf(const []);
    final baseline = empty.used + empty.planned;
    final sorted = [...records]..sort(_byRange);
    final entries = [
      for (final record in sorted)
        LeaveReportEntry(
          record: record,
          annualDays: _cost(balanceOf([record]), baseline),
          planned: record.range.start.isAfter(today),
        ),
    ];

    return LeaveReport(
      profile: profile,
      date: today,
      periods: periods,
      nextAccrual: _entitlementCalculator.nextAccrual(profile, today),
      balance: balanceOf(sorted),
      entries: entries,
      totalService: serviceDuration(profile, today),
      absenceDays: profile.absencePeriods.fold(
        0,
        (sum, range) => sum + range.dayCount,
      ),
    );
  }

  /// Prior service plus the time from the start date to [date], in years,
  /// months and days.
  ///
  /// Prior service is subtracted from the start date with calendar
  /// arithmetic and a missing day becomes the month's last day
  /// (`docs/mevzuat.md` 1.6, 2.1 and 5).
  static ServiceDuration serviceDuration(Profile profile, DateTime date) {
    final prior = profile.priorService;
    final start = _addMonths(
      profile.employmentStartDate,
      -(prior.years * 12 + prior.months),
    ).subtract(Duration(days: prior.days));
    final end = DateTime.utc(date.year, date.month, date.day);
    if (end.isBefore(start)) return const ServiceDuration();

    var months = (end.year - start.year) * 12 + end.month - start.month;
    if (_addMonths(start, months).isAfter(end)) months--;
    final days = end.difference(_addMonths(start, months)).inDays;
    return ServiceDuration(
      years: months ~/ 12,
      months: months % 12,
      days: days,
    );
  }

  static DateTime _addMonths(DateTime date, int months) {
    final index = date.year * 12 + date.month - 1 + months;
    final year = index ~/ 12;
    final month = index % 12 + 1;
    final lastDay = DateTime.utc(year, month + 1, 0).day;
    return DateTime.utc(year, month, date.day > lastDay ? lastDay : date.day);
  }

  static double _cost(LeaveBalance balance, double baseline) {
    final cost = balance.used + balance.planned - baseline;
    return cost < 0 ? 0 : cost;
  }

  static int _byRange(LeaveRecord a, LeaveRecord b) {
    final start = a.range.start.compareTo(b.range.start);
    if (start != 0) return start;
    final end = a.range.end.compareTo(b.range.end);
    return end != 0 ? end : a.id.compareTo(b.id);
  }
}
