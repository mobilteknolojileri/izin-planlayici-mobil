import 'dart:math' as math;

import 'package:izin_planla/domain/day_count/balance_calculator.dart';
import 'package:izin_planla/domain/day_count/leave_cost.dart';
import 'package:izin_planla/domain/models/models.dart';

/// Implementation of [BalanceCalculator]. Written by task 08.
///
/// Usage is taken from the oldest live accrual first (`docs/mevzuat.md` 1.8
/// for 4857, 2.4 and 657 md. 103/1 for civil servants). A record that starts
/// after `today` is planned, every other record is used. Leave used before
/// tracking (`Profile.leaveUsedBeforeTracking`) counts as used on `today`.
/// The remaining balance may be negative.
class DefaultBalanceCalculator implements BalanceCalculator {
  /// Creates the calculator.
  const new();

  @override
  LeaveBalance balance({
    required Profile profile,
    required List<EntitlementPeriod> periods,
    required List<LeaveRecord> leaves,
    required List<Holiday> holidays,
    required DateTime today,
  }) {
    const cost = LeaveCost();
    final day = _dateOnly(today);
    final civilServant = profile.employmentType == EmploymentType.civilServant;
    final ledger = _Ledger([
      for (final period in periods)
        _Bucket(
          accrual: _dateOnly(period.accrualDate),
          // Unused 4857 leave never expires (mevzuat 1.8, 4857 md. 59).
          expires: civilServant ? _expiryOf(period) : null,
          days: period.days.toDouble(),
        ),
    ]);

    final used = <_Deduction>[];
    final planned = <_Deduction>[];
    for (final leave in leaves) {
      if (!cost.deductsFromAnnual(leave, profile)) continue;
      final days = cost.total(leave, profile, holidays);
      if (days == 0) continue;
      final start = _dateOnly(leave.range.start);
      (start.isAfter(day) ? planned : used).add((date: start, days: days));
    }
    used.sort((a, b) => a.date.compareTo(b.date));
    planned.sort((a, b) => a.date.compareTo(b.date));

    for (final deduction in used) {
      ledger.deduct(deduction.date, deduction.days);
    }
    ledger
      ..advanceTo(day)
      ..deduct(day, profile.leaveUsedBeforeTracking);

    final earned = ledger.earnedOn(day);
    final remaining = ledger.leftOn(day);
    final plannedDays = planned.fold<double>(0, (sum, d) => sum + d.days);

    return LeaveBalance(
      earned: earned,
      used: earned - remaining,
      planned: plannedDays,
      remaining: remaining - plannedDays,
      expiringAtYearEnd: civilServant
          ? _expiringAtYearEnd(ledger, day, planned)
          : 0,
    );
  }

  /// Day the unused part of a civil servant's period is dropped.
  ///
  /// Uses `EntitlementPeriod.expiresOn`. Without it the right of calendar
  /// year Y is dropped on 1 January Y+2 (657 md. 103/1, mevzuat 2.4).
  static DateTime? _expiryOf(EntitlementPeriod period) {
    final expires = period.expiresOn;
    if (expires != null) return _dateOnly(expires);
    final year = period.calendarYear;
    return year == null ? null : DateTime.utc(year + 2);
  }

  /// Days still unused on 1 January of next year that are dropped that day,
  /// after the planned leave of this year is taken (mevzuat 2.4).
  static double _expiringAtYearEnd(
    _Ledger ledger,
    DateTime today,
    List<_Deduction> planned,
  ) {
    final yearEnd = DateTime.utc(today.year + 1);
    for (final deduction in planned) {
      if (!deduction.date.isBefore(yearEnd)) break;
      ledger.deduct(deduction.date, deduction.days);
    }
    return ledger.leftExpiringBetween(today, yearEnd);
  }

  static DateTime _dateOnly(DateTime date) =>
      DateTime.utc(date.year, date.month, date.day);
}

/// Annual leave days deducted on a date.
typedef _Deduction = ({DateTime date, double days});

/// Days earned on one accrual date and what is left of them.
class _Bucket {
  new({required this.accrual, required this.expires, required this.days})
    : left = days;

  final DateTime accrual;
  final DateTime? expires;
  final double days;
  double left;
  bool accrued = false;

  /// Whether the right exists on [date]: earned and not yet dropped.
  bool isLiveOn(DateTime date) {
    final expires = this.expires;
    return !accrual.isAfter(date) && (expires == null || expires.isAfter(date));
  }
}

/// Replays accruals and deductions in date order.
///
/// A deduction takes from the oldest live bucket first. What no bucket
/// covers becomes debt, paid by the next accrual.
class _Ledger {
  new(List<_Bucket> buckets)
    : _buckets = [...buckets]..sort((a, b) => a.accrual.compareTo(b.accrual));

  final List<_Bucket> _buckets;
  double _debt = 0;

  /// Accrues every bucket earned up to [date], paying debt first.
  void advanceTo(DateTime date) {
    for (final bucket in _buckets) {
      if (bucket.accrued || bucket.accrual.isAfter(date)) continue;
      bucket.accrued = true;
      final paid = math.min(_debt, bucket.left);
      bucket.left -= paid;
      _debt -= paid;
    }
  }

  /// Deducts [days] on [date].
  void deduct(DateTime date, double days) {
    if (days <= 0) return;
    advanceTo(date);
    var rest = days;
    for (final bucket in _buckets) {
      if (rest <= 0) break;
      if (!bucket.isLiveOn(date)) continue;
      final taken = math.min(rest, bucket.left);
      bucket.left -= taken;
      rest -= taken;
    }
    _debt += rest;
  }

  /// Days of all rights live on [date].
  double earnedOn(DateTime date) => _buckets
      .where((b) => b.isLiveOn(date))
      .fold<double>(0, (sum, b) => sum + b.days);

  /// Days left on [date], minus debt. May be negative.
  double leftOn(DateTime date) =>
      _buckets
          .where((b) => b.isLiveOn(date))
          .fold<double>(0, (sum, b) => sum + b.left) -
      _debt;

  /// Days left in buckets live on [from] that are dropped by [until].
  double leftExpiringBetween(DateTime from, DateTime until) => _buckets
      .where((b) {
        final expires = b.expires;
        return b.isLiveOn(from) && expires != null && !expires.isAfter(until);
      })
      .fold<double>(0, (sum, b) => sum + b.left);
}
