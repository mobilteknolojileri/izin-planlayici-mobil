import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:izin_planla/config/dependencies.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/ui/core/theme/meaning.dart';
import 'package:izin_planla/ui/core/widgets/week_strip_day.dart';
import 'package:izin_planla/ui/home/view_models/home_state.dart';

final StreamProvider<AppSettings> _settingsProvider =
    StreamProvider.autoDispose(
      (ref) => ref.watch(settingsRepositoryProvider).watch(),
    );

final StreamProvider<List<Profile>> _profilesProvider =
    StreamProvider.autoDispose(
      (ref) => ref.watch(profileRepositoryProvider).watchAll(),
    );

final FutureProvider<List<Holiday>> _holidaysProvider =
    FutureProvider.autoDispose(
      (ref) => ref.watch(holidayRepositoryProvider).all(),
    );

final StreamProviderFamily<List<LeaveRecord>, String> _leavesProvider =
    StreamProvider.autoDispose.family(
      (ref, profileId) =>
          ref.watch(leaveRepositoryProvider).watchForProfile(profileId),
    );

/// State and actions of the home screen.
final NotifierProvider<HomeViewModel, HomeState> homeViewModelProvider =
    NotifierProvider.autoDispose(HomeViewModel.new);

/// View model of the home screen: the balance of the active profile, the
/// next accrual, the next holiday and the best bridge ahead. Every number
/// comes from the domain calculators.
class HomeViewModel extends Notifier<HomeState> {
  /// Creates the view model. [clock] gives the current time, tests pass a
  /// fixed one.
  new({DateTime Function()? clock}) : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;

  @override
  HomeState build() {
    final settings = ref.watch(_settingsProvider);
    final profiles = ref.watch(_profilesProvider);
    final holidays = ref.watch(_holidaysProvider);
    if (settings.hasError || profiles.hasError || holidays.hasError) {
      return const HomeError();
    }
    final settingsValue = settings.value;
    final profileList = profiles.value;
    final holidayList = holidays.value;
    if (settingsValue == null || profileList == null || holidayList == null) {
      return const HomeLoading();
    }
    final profile =
        profileList
            .where((p) => p.id == settingsValue.activeProfileId)
            .firstOrNull ??
        profileList.firstOrNull;
    if (profile == null) return const HomeNoProfile();
    final leaves = ref.watch(_leavesProvider(profile.id));
    if (leaves.hasError) return const HomeError();
    final leaveList = leaves.value;
    if (leaveList == null) return const HomeLoading();
    return _ready(profile, profileList.length > 1, leaveList, holidayList);
  }

  /// Loads the data again after an error.
  void retry() {
    ref
      ..invalidate(_settingsProvider)
      ..invalidate(_profilesProvider)
      ..invalidate(_holidaysProvider);
  }

  HomeReady _ready(
    Profile profile,
    bool severalProfiles,
    List<LeaveRecord> leaves,
    List<Holiday> holidays,
  ) {
    final now = _clock();
    final today = DateTime.utc(now.year, now.month, now.day);
    final nextHoliday = holidays
        .where((holiday) => !holiday.halfDay && holiday.date.isAfter(today))
        .firstOrNull;
    final teacher =
        profile.isTeacher &&
        profile.employmentType == EmploymentType.civilServant;
    final entitlement = ref.watch(entitlementCalculatorProvider);
    final next = teacher ? null : entitlement.nextAccrual(profile, today);
    LeaveBalance? balance;
    if (!teacher) {
      balance = ref
          .watch(balanceCalculatorProvider)
          .balance(
            profile: profile,
            periods: entitlement.periods(profile, until: today),
            leaves: leaves,
            holidays: holidays,
            today: today,
          );
    }
    final bridge = _bestBridge(
      profile,
      holidays,
      today,
      math.max<double>(0, balance?.remaining ?? 0),
    );
    final bridgeDays = bridge == null
        ? const <WeekStripDay>[]
        : _stripDays(bridge, profile, holidays);
    return HomeReady(
      today: today,
      profileName: profile.name,
      hasSeveralProfiles: severalProfiles,
      isTeacher: teacher,
      balance: balance,
      nextAccrual: next,
      daysUntilAccrual: next?.date.difference(today).inDays,
      nextHoliday: nextHoliday,
      daysUntilHoliday: nextHoliday?.date.difference(today).inDays,
      bridge: bridge,
      bridgeDays: bridgeDays,
      bridgeMeanings: [
        for (final meaning in _legendOrder)
          if (bridgeDays.any((day) => day.meaning == meaning)) meaning,
      ],
    );
  }

  /// The first suggestion of this year or next year that starts after
  /// today. The planner returns the best first.
  BridgeSuggestion? _bestBridge(
    Profile profile,
    List<Holiday> holidays,
    DateTime today,
    double budget,
  ) {
    if (budget <= 0) return null;
    final planner = ref.watch(bridgePlannerProvider);
    for (final year in [today.year, today.year + 1]) {
      final suggestion = planner
          .suggestions(
            year: year,
            profile: profile,
            holidays: holidays,
            budget: budget,
          )
          .where((s) => s.vacation.start.isAfter(today))
          .firstOrNull;
      if (suggestion != null) return suggestion;
    }
    return null;
  }

  static const List<Meaning> _legendOrder = [
    Meaning.bridge,
    Meaning.holiday,
    Meaning.eve,
    Meaning.weekend,
    Meaning.workday,
  ];

  static List<WeekStripDay> _stripDays(
    BridgeSuggestion suggestion,
    Profile profile,
    List<Holiday> holidays,
  ) {
    final byDate = {for (final holiday in holidays) holiday.date: holiday};
    final leaveDays = suggestion.leaveDays.toSet();
    final workDays = profile.workSchedule.workDays;
    final range = suggestion.vacation;
    return [
      for (var i = 0; i < range.dayCount; i++)
        _day(
          DateTime.utc(
            range.start.year,
            range.start.month,
            range.start.day + i,
          ),
          leaveDays,
          byDate,
          workDays,
        ),
    ];
  }

  static WeekStripDay _day(
    DateTime date,
    Set<DateTime> leaveDays,
    Map<DateTime, Holiday> holidays,
    List<int> workDays,
  ) {
    final holiday = holidays[date];
    final Meaning meaning;
    if (leaveDays.contains(date)) {
      meaning = Meaning.bridge;
    } else if (holiday != null) {
      meaning = holiday.halfDay ? Meaning.eve : Meaning.holiday;
    } else if (!workDays.contains(date.weekday)) {
      meaning = Meaning.weekend;
    } else {
      meaning = Meaning.workday;
    }
    return WeekStripDay(date: date, meaning: meaning);
  }
}
