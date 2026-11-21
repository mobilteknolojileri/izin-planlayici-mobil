import 'package:izin_planla/data/services/notifications/reminder.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';

/// Notification texts from `lib/l10n/parts/notifications.arb`.
class ReminderTexts {
  /// Creates the texts from [localizations].
  const new(this.localizations);

  /// Source of every string.
  final AppLocalizations localizations;

  /// Name of the Android notification channel.
  String get channelName => localizations.notificationsChannelName;

  /// Description of the Android notification channel.
  String get channelDescription =>
      localizations.notificationsChannelDescription;

  /// Title of the test notification.
  String get testTitle => localizations.notificationsTestTitle;

  /// Body of the test notification.
  String get testBody => localizations.notificationsTestBody;

  /// Title and body of [reminder].
  ({String title, String body}) of(Reminder reminder) {
    final l10n = localizations;
    return switch (reminder) {
      HolidayReminder(:final holidayName, :final daysUntil) => (
        title: l10n.notificationsHolidayTitle,
        body: l10n.notificationsHolidayBody(daysUntil, holidayName),
      ),
      BridgeReminder(
        :final holidayName,
        :final daysUntil,
        :final leaveDays,
        :final totalDaysOff,
      ) =>
        (
          title: l10n.notificationsBridgeTitle,
          body: l10n.notificationsBridgeBody(
            daysUntil,
            holidayName,
            leaveDays,
            totalDaysOff,
          ),
        ),
      AccrualReminder(:final profileName, :final days) => (
        title: l10n.notificationsAccrualTitle,
        body: l10n.notificationsAccrualBody(profileName, days),
      ),
      LeaveStartReminder(:final profileName, :final daysUntil) => (
        title: l10n.notificationsLeaveStartTitle,
        body: l10n.notificationsLeaveStartBody(profileName, daysUntil),
      ),
      LeaveReturnReminder(:final profileName) => (
        title: l10n.notificationsLeaveReturnTitle,
        body: l10n.notificationsLeaveReturnBody(profileName),
      ),
      YearEndExpiringReminder(:final profileName, :final days) => (
        title: l10n.notificationsYearEndExpiringTitle,
        body: l10n.notificationsYearEndExpiringBody(profileName, days),
      ),
      YearEndUnusedReminder(:final profileName, :final days) => (
        title: l10n.notificationsYearEndUnusedTitle,
        body: l10n.notificationsYearEndUnusedBody(profileName, days),
      ),
    };
  }
}
