import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:izin_planla/config/dependencies.dart';
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
import 'package:izin_planla/data/services/links/link_opener.dart';

/// [overrides] plus sample data fakes from `lib/data/fakes/` for every
/// dependency the test does not override itself, so a widget test never
/// opens the database, a plugin or an asset by accident.
List<Override> withFakeDependencies([List<Override> overrides = const []]) {
  final taken = {for (final override in overrides) override.origin};
  return [
    for (final fake in _fakes())
      if (!taken.contains(fake.origin)) fake,
    ...overrides,
  ];
}

List<Override> _fakes() => [
  profileRepositoryProvider.overrideWithValue(FakeProfileRepository()),
  leaveRepositoryProvider.overrideWithValue(FakeLeaveRepository()),
  overtimeRepositoryProvider.overrideWithValue(FakeOvertimeRepository()),
  settingsRepositoryProvider.overrideWithValue(FakeSettingsRepository()),
  holidayRepositoryProvider.overrideWithValue(FakeHolidayRepository()),
  backupCodecProvider.overrideWithValue(FakeBackupCodec()),
  notificationServiceProvider.overrideWithValue(FakeNotificationService()),
  exportServiceProvider.overrideWithValue(FakeExportService()),
  homeWidgetServiceProvider.overrideWithValue(FakeHomeWidgetService()),
  homeWidgetClicksProvider.overrideWithValue(const Stream.empty()),
  linkOpenerProvider.overrideWithValue(RecordingLinkOpener()),
  entitlementCalculatorProvider.overrideWithValue(FakeEntitlementCalculator()),
  leaveDayCounterProvider.overrideWithValue(FakeLeaveDayCounter()),
  balanceCalculatorProvider.overrideWithValue(FakeBalanceCalculator()),
  splitRuleCheckerProvider.overrideWithValue(FakeSplitRuleChecker()),
  statutoryLeaveAdvisorProvider.overrideWithValue(FakeStatutoryLeaveAdvisor()),
  yearSummaryCalculatorProvider.overrideWithValue(FakeYearSummaryCalculator()),
  bridgePlannerProvider.overrideWithValue(FakeBridgePlanner()),
];

/// A [LinkOpener] that records the links and answers with [opens].
class RecordingLinkOpener implements LinkOpener {
  /// Creates the opener.
  new({this.opens = true});

  /// What [open] answers, false acts like a phone without a browser.
  final bool opens;

  /// Every link asked for, in order.
  final List<String> opened = [];

  @override
  Future<bool> open(String url) async {
    opened.add(url);
    return opens;
  }
}
