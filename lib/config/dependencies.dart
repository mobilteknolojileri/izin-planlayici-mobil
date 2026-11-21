import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_planla/data/database/app_database.dart';
import 'package:izin_planla/data/repositories/asset_holiday_repository.dart';
import 'package:izin_planla/data/repositories/backup_codec.dart';
import 'package:izin_planla/data/repositories/drift_backup_codec.dart';
import 'package:izin_planla/data/repositories/drift_leave_repository.dart';
import 'package:izin_planla/data/repositories/drift_overtime_repository.dart';
import 'package:izin_planla/data/repositories/drift_profile_repository.dart';
import 'package:izin_planla/data/repositories/drift_settings_repository.dart';
import 'package:izin_planla/data/repositories/holiday_repository.dart';
import 'package:izin_planla/data/repositories/leave_repository.dart';
import 'package:izin_planla/data/repositories/overtime_repository.dart';
import 'package:izin_planla/data/repositories/profile_repository.dart';
import 'package:izin_planla/data/repositories/settings_repository.dart';
import 'package:izin_planla/data/services/export/default_export_service.dart';
import 'package:izin_planla/data/services/export/export_service.dart';
import 'package:izin_planla/data/services/home_widget/default_home_widget_service.dart';
import 'package:izin_planla/data/services/home_widget/home_widget_clicks.dart';
import 'package:izin_planla/data/services/home_widget/home_widget_service.dart';
import 'package:izin_planla/data/services/links/link_opener.dart';
import 'package:izin_planla/data/services/links/url_launcher_link_opener.dart';
import 'package:izin_planla/data/services/notifications/local_notification_service.dart';
import 'package:izin_planla/data/services/notifications/notification_service.dart';
import 'package:izin_planla/data/services/notifications/notification_sync.dart';
import 'package:izin_planla/data/services/notifications/plugin_notification_gateway.dart';
import 'package:izin_planla/domain/bridge/bridge_planner.dart';
import 'package:izin_planla/domain/bridge/default_bridge_planner.dart';
import 'package:izin_planla/domain/day_count/balance_calculator.dart';
import 'package:izin_planla/domain/day_count/default_balance_calculator.dart';
import 'package:izin_planla/domain/day_count/default_leave_day_counter.dart';
import 'package:izin_planla/domain/day_count/default_split_rule_checker.dart';
import 'package:izin_planla/domain/day_count/default_statutory_leave_advisor.dart';
import 'package:izin_planla/domain/day_count/default_year_summary_calculator.dart';
import 'package:izin_planla/domain/day_count/leave_day_counter.dart';
import 'package:izin_planla/domain/day_count/split_rule_checker.dart';
import 'package:izin_planla/domain/day_count/statutory_leave_advisor.dart';
import 'package:izin_planla/domain/day_count/year_summary_calculator.dart';
import 'package:izin_planla/domain/entitlement/default_entitlement_calculator.dart';
import 'package:izin_planla/domain/entitlement/entitlement_calculator.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

// Every dependency is exposed by its interface type and points to the real
// implementation. The fakes in lib/data/fakes/ are only used by tests,
// through ProviderScope overrides, so they stay out of the release build.

/// Installed app version, such as `1.0.0+2`. `main.dart` overrides it with
/// the value read from the platform before the first frame.
final appVersionProvider = Provider<String>((ref) => '0.0.0');

/// The on-device database. Opened lazily on first use.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase.open();
  ref.onDispose(() => unawaited(database.close()));
  return database;
});

/// Profile storage.
final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => DriftProfileRepository(ref.watch(appDatabaseProvider)),
);

/// Leave record storage.
final leaveRepositoryProvider = Provider<LeaveRepository>(
  (ref) => DriftLeaveRepository(ref.watch(appDatabaseProvider)),
);

/// Overtime record storage.
final overtimeRepositoryProvider = Provider<OvertimeRepository>(
  (ref) => DriftOvertimeRepository(ref.watch(appDatabaseProvider)),
);

/// Settings storage.
final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => DriftSettingsRepository(ref.watch(appDatabaseProvider)),
);

/// Bundled official holidays.
final holidayRepositoryProvider = Provider<HolidayRepository>(
  (ref) => AssetHolidayRepository(),
);

/// Backup export, restore and reset.
final backupCodecProvider = Provider<BackupCodec>(
  (ref) => DriftBackupCodec(ref.watch(appDatabaseProvider)),
);

/// Local reminders.
final notificationServiceProvider = Provider<NotificationService>(
  (ref) => LocalNotificationService(
    gateway: PluginNotificationGateway(),
    profileRepository: ref.watch(profileRepositoryProvider),
    leaveRepository: ref.watch(leaveRepositoryProvider),
    settingsRepository: ref.watch(settingsRepositoryProvider),
    holidayRepository: ref.watch(holidayRepositoryProvider),
    entitlementCalculator: ref.watch(entitlementCalculatorProvider),
    balanceCalculator: ref.watch(balanceCalculatorProvider),
    bridgePlanner: ref.watch(bridgePlannerProvider),
  ),
);

/// Reschedules the reminders whenever the data changes. `App` reads it once.
final notificationSyncProvider = Provider<NotificationSync>((ref) {
  final sync = NotificationSync(
    service: ref.watch(notificationServiceProvider),
    settings: ref.watch(settingsRepositoryProvider),
    profiles: ref.watch(profileRepositoryProvider),
    leaves: ref.watch(leaveRepositoryProvider),
  )..start();
  ref.onDispose(() => unawaited(sync.dispose()));
  return sync;
});

/// PDF, Excel, CSV and backup files.
final exportServiceProvider = Provider<ExportService>(
  (ref) => DefaultExportService(
    profiles: ref.watch(profileRepositoryProvider),
    leaves: ref.watch(leaveRepositoryProvider),
    holidays: ref.watch(holidayRepositoryProvider),
    entitlementCalculator: ref.watch(entitlementCalculatorProvider),
    balanceCalculator: ref.watch(balanceCalculatorProvider),
    backupCodec: ref.watch(backupCodecProvider),
    l10n: lookupAppLocalizations(const Locale('tr')),
    appVersion: ref.watch(appVersionProvider),
    schemaVersion: AppDatabase.currentSchemaVersion,
  ),
);

/// Android home screen widget. Watching it starts the data listeners, `App`
/// reads it once.
final homeWidgetServiceProvider = Provider<HomeWidgetService>((ref) {
  final service = DefaultHomeWidgetService(
    settingsRepository: ref.watch(settingsRepositoryProvider),
    profileRepository: ref.watch(profileRepositoryProvider),
    leaveRepository: ref.watch(leaveRepositoryProvider),
    holidayRepository: ref.watch(holidayRepositoryProvider),
    entitlementCalculator: ref.watch(entitlementCalculatorProvider),
    balanceCalculator: ref.watch(balanceCalculatorProvider),
  )..start();
  ref.onDispose(() => unawaited(service.dispose()));
  return service;
});

/// Taps on the home screen widget while the app runs.
final homeWidgetClicksProvider = Provider<Stream<void>>(
  (ref) => homeWidgetClicks(),
);

/// Opens source links in the browser.
final linkOpenerProvider = Provider<LinkOpener>(
  (ref) => const UrlLauncherLinkOpener(),
);

/// Annual leave rights.
final entitlementCalculatorProvider = Provider<EntitlementCalculator>(
  (ref) => const DefaultEntitlementCalculator(),
);

/// Leave day counting.
final leaveDayCounterProvider = Provider<LeaveDayCounter>(
  (ref) => const DefaultLeaveDayCounter(),
);

/// Leave balance.
final balanceCalculatorProvider = Provider<BalanceCalculator>(
  (ref) => const DefaultBalanceCalculator(),
);

/// Split rule and travel leave warnings.
final splitRuleCheckerProvider = Provider<SplitRuleChecker>(
  (ref) => const DefaultSplitRuleChecker(),
);

/// Legal day suggestions for excuse leave.
final statutoryLeaveAdvisorProvider = Provider<StatutoryLeaveAdvisor>(
  (ref) => const DefaultStatutoryLeaveAdvisor(),
);

/// Yearly statistics.
final yearSummaryCalculatorProvider = Provider<YearSummaryCalculator>(
  (ref) => const DefaultYearSummaryCalculator(),
);

/// Bridge holiday suggestions.
final bridgePlannerProvider = Provider<BridgePlanner>(
  (ref) => DefaultBridgePlanner(counter: ref.watch(leaveDayCounterProvider)),
);
