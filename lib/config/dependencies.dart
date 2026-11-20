import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_planla/data/fakes/fake_backup_codec.dart';
import 'package:izin_planla/data/fakes/fake_calculators.dart';
import 'package:izin_planla/data/fakes/fake_export_service.dart';
import 'package:izin_planla/data/fakes/fake_holiday_repository.dart';
import 'package:izin_planla/data/fakes/fake_home_widget_service.dart';
import 'package:izin_planla/data/fakes/fake_leave_repository.dart';
import 'package:izin_planla/data/fakes/fake_notification_service.dart';
import 'package:izin_planla/data/fakes/fake_overtime_repository.dart';
import 'package:izin_planla/data/fakes/fake_profile_repository.dart';
import 'package:izin_planla/data/fakes/fake_settings_repository.dart';
import 'package:izin_planla/data/repositories/backup_codec.dart';
import 'package:izin_planla/data/repositories/holiday_repository.dart';
import 'package:izin_planla/data/repositories/leave_repository.dart';
import 'package:izin_planla/data/repositories/overtime_repository.dart';
import 'package:izin_planla/data/repositories/profile_repository.dart';
import 'package:izin_planla/data/repositories/settings_repository.dart';
import 'package:izin_planla/data/services/export/export_service.dart';
import 'package:izin_planla/data/services/home_widget/home_widget_service.dart';
import 'package:izin_planla/data/services/notifications/notification_service.dart';
import 'package:izin_planla/domain/bridge/bridge_planner.dart';
import 'package:izin_planla/domain/day_count/balance_calculator.dart';
import 'package:izin_planla/domain/day_count/leave_day_counter.dart';
import 'package:izin_planla/domain/day_count/split_rule_checker.dart';
import 'package:izin_planla/domain/day_count/statutory_leave_advisor.dart';
import 'package:izin_planla/domain/day_count/year_summary_calculator.dart';
import 'package:izin_planla/domain/entitlement/entitlement_calculator.dart';

// Every dependency is exposed by its interface type. The app starts with the
// fakes in lib/data/fakes/. Task 16 points these providers to the real
// implementations. Tests override them with ProviderScope overrides.

/// Profile storage.
final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => FakeProfileRepository(),
);

/// Leave record storage.
final leaveRepositoryProvider = Provider<LeaveRepository>(
  (ref) => FakeLeaveRepository(),
);

/// Overtime record storage.
final overtimeRepositoryProvider = Provider<OvertimeRepository>(
  (ref) => FakeOvertimeRepository(),
);

/// Settings storage.
final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => FakeSettingsRepository(),
);

/// Bundled official holidays.
final holidayRepositoryProvider = Provider<HolidayRepository>(
  (ref) => FakeHolidayRepository(),
);

/// Backup export, restore and reset.
final backupCodecProvider = Provider<BackupCodec>((ref) => FakeBackupCodec());

/// Local reminders.
final notificationServiceProvider = Provider<NotificationService>(
  (ref) => FakeNotificationService(),
);

/// PDF, Excel, CSV and backup files.
final exportServiceProvider = Provider<ExportService>(
  (ref) => FakeExportService(),
);

/// Android home screen widget.
final homeWidgetServiceProvider = Provider<HomeWidgetService>(
  (ref) => FakeHomeWidgetService(),
);

/// Annual leave rights.
final entitlementCalculatorProvider = Provider<EntitlementCalculator>(
  (ref) => FakeEntitlementCalculator(),
);

/// Leave day counting.
final leaveDayCounterProvider = Provider<LeaveDayCounter>(
  (ref) => FakeLeaveDayCounter(),
);

/// Leave balance.
final balanceCalculatorProvider = Provider<BalanceCalculator>(
  (ref) => FakeBalanceCalculator(),
);

/// Split rule and travel leave warnings.
final splitRuleCheckerProvider = Provider<SplitRuleChecker>(
  (ref) => FakeSplitRuleChecker(),
);

/// Legal day suggestions for excuse leave.
final statutoryLeaveAdvisorProvider = Provider<StatutoryLeaveAdvisor>(
  (ref) => FakeStatutoryLeaveAdvisor(),
);

/// Yearly statistics.
final yearSummaryCalculatorProvider = Provider<YearSummaryCalculator>(
  (ref) => FakeYearSummaryCalculator(),
);

/// Bridge holiday suggestions.
final bridgePlannerProvider = Provider<BridgePlanner>(
  (ref) => FakeBridgePlanner(),
);
