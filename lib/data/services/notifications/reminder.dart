import 'package:flutter/foundation.dart' show immutable;

/// What a scheduled reminder is about. The texts come from
/// `lib/l10n/parts/notifications.arb`, see `ReminderTexts`.
@immutable
sealed class Reminder {
  const new();
}

/// An official holiday is coming.
final class HolidayReminder extends Reminder {
  /// Creates a holiday reminder.
  const new({required this.holidayName, required this.daysUntil});

  /// Name of the first full holiday day, as in `assets/holidays/`.
  final String holidayName;

  /// Calendar days from the reminder day to the holiday, 0 means today.
  final int daysUntil;

  @override
  bool operator ==(Object other) =>
      other is HolidayReminder &&
      other.holidayName == holidayName &&
      other.daysUntil == daysUntil;

  @override
  int get hashCode => Object.hash(HolidayReminder, holidayName, daysUntil);
}

/// A holiday is coming and a few leave days turn it into a long break.
///
/// Replaces the [HolidayReminder] of the same holiday, so the user gets one
/// reminder per holiday.
final class BridgeReminder extends Reminder {
  /// Creates a bridge reminder.
  const new({
    required this.holidayName,
    required this.daysUntil,
    required this.leaveDays,
    required this.totalDaysOff,
  });

  /// Name of the first full holiday day inside the break.
  final String holidayName;

  /// Calendar days from the reminder day to the holiday, 0 means today.
  final int daysUntil;

  /// Leave days to take, an eve may count as half.
  final double leaveDays;

  /// Calendar days in the whole break.
  final int totalDaysOff;

  @override
  bool operator ==(Object other) =>
      other is BridgeReminder &&
      other.holidayName == holidayName &&
      other.daysUntil == daysUntil &&
      other.leaveDays == leaveDays &&
      other.totalDaysOff == totalDaysOff;

  @override
  int get hashCode => Object.hash(
    BridgeReminder,
    holidayName,
    daysUntil,
    leaveDays,
    totalDaysOff,
  );
}

/// A profile earns annual leave today.
final class AccrualReminder extends Reminder {
  /// Creates an accrual reminder.
  const new({required this.profileName, required this.days});

  /// Name of the profile that earns the days.
  final String profileName;

  /// Days earned on the accrual day.
  final int days;

  @override
  bool operator ==(Object other) =>
      other is AccrualReminder &&
      other.profileName == profileName &&
      other.days == days;

  @override
  int get hashCode => Object.hash(AccrualReminder, profileName, days);
}

/// A planned leave starts soon.
final class LeaveStartReminder extends Reminder {
  /// Creates a leave start reminder.
  const new({required this.profileName, required this.daysUntil});

  /// Name of the profile on leave.
  final String profileName;

  /// Calendar days from the reminder day to the first leave day, 0 means
  /// today.
  final int daysUntil;

  @override
  bool operator ==(Object other) =>
      other is LeaveStartReminder &&
      other.profileName == profileName &&
      other.daysUntil == daysUntil;

  @override
  int get hashCode => Object.hash(LeaveStartReminder, profileName, daysUntil);
}

/// The profile goes back to work tomorrow.
final class LeaveReturnReminder extends Reminder {
  /// Creates a leave return reminder.
  const new({required this.profileName});

  /// Name of the profile coming back from leave.
  final String profileName;

  @override
  bool operator ==(Object other) =>
      other is LeaveReturnReminder && other.profileName == profileName;

  @override
  int get hashCode => Object.hash(LeaveReturnReminder, profileName);
}

/// A civil servant's unused leave is dropped on 1 January (657 art. 103,
/// `docs/mevzuat.md` 2.4).
final class YearEndExpiringReminder extends Reminder {
  /// Creates a year-end warning.
  const new({required this.profileName, required this.days});

  /// Name of the civil servant.
  final String profileName;

  /// Days dropped on 1 January if unused.
  final double days;

  @override
  bool operator ==(Object other) =>
      other is YearEndExpiringReminder &&
      other.profileName == profileName &&
      other.days == days;

  @override
  int get hashCode => Object.hash(YearEndExpiringReminder, profileName, days);
}

/// A worker has unused leave. Information only, because 4857 leave is never
/// dropped (`docs/mevzuat.md` 1.8).
final class YearEndUnusedReminder extends Reminder {
  /// Creates a year-end information.
  const new({required this.profileName, required this.days});

  /// Name of the worker.
  final String profileName;

  /// Unused annual leave days.
  final double days;

  @override
  bool operator ==(Object other) =>
      other is YearEndUnusedReminder &&
      other.profileName == profileName &&
      other.days == days;

  @override
  int get hashCode => Object.hash(YearEndUnusedReminder, profileName, days);
}
