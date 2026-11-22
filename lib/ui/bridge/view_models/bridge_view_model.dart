import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show StreamProviderFamily;
import 'package:izin_planla/config/dependencies.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/ui/bridge/view_models/bridge_content.dart';
import 'package:izin_planla/ui/bridge/view_models/bridge_item.dart';
import 'package:izin_planla/ui/bridge/view_models/bridge_sort.dart';
import 'package:izin_planla/ui/bridge/view_models/bridge_state.dart';
import 'package:izin_planla/ui/core/theme/meaning.dart';
import 'package:izin_planla/ui/core/widgets/week_strip_day.dart';
import 'package:izin_planla/utils/result.dart';

/// Today as a UTC midnight date. Tests override it with a fixed day.
final bridgeTodayProvider = Provider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime.utc(now.year, now.month, now.day);
});

/// State and actions of the bridge planner screen.
final bridgeViewModelProvider = NotifierProvider<BridgeViewModel, BridgeState>(
  BridgeViewModel.new,
);

final _settingsProvider = StreamProvider<AppSettings>(
  (ref) => ref.watch(settingsRepositoryProvider).watch(),
);

final _profilesProvider = StreamProvider<List<Profile>>(
  (ref) => ref.watch(profileRepositoryProvider).watchAll(),
);

final StreamProviderFamily<List<LeaveRecord>, String> _leavesProvider =
    StreamProvider.family<List<LeaveRecord>, String>(
      (ref, profileId) =>
          ref.watch(leaveRepositoryProvider).watchForProfile(profileId),
    );

final _holidaysProvider = FutureProvider<List<Holiday>>(
  (ref) => ref.watch(holidayRepositoryProvider).all(),
);

/// Stored data the suggestions are built from.
class _Data {
  const new({
    required this.today,
    required this.profile,
    required this.holidays,
    required this.leaves,
    required this.remaining,
  });

  final DateTime today;
  final Profile? profile;
  final List<Holiday> holidays;
  final List<LeaveRecord> leaves;
  final double remaining;
}

final _dataProvider = FutureProvider<_Data>((ref) async {
  final today = ref.watch(bridgeTodayProvider);
  final settingsFuture = ref.watch(_settingsProvider.future);
  final profilesFuture = ref.watch(_profilesProvider.future);
  final holidaysFuture = ref.watch(_holidaysProvider.future);
  final settings = await settingsFuture;
  final profiles = await profilesFuture;
  final holidays = await holidaysFuture;
  final profile =
      profiles
          .where((profile) => profile.id == settings.activeProfileId)
          .firstOrNull ??
      profiles.firstOrNull;
  if (profile == null) {
    return _Data(
      today: today,
      profile: null,
      holidays: holidays,
      leaves: const [],
      remaining: 0,
    );
  }
  final leaves = await ref.watch(_leavesProvider(profile.id).future);
  final periods = ref
      .watch(entitlementCalculatorProvider)
      .periods(profile, until: today);
  final balance = ref
      .watch(balanceCalculatorProvider)
      .balance(
        profile: profile,
        periods: periods,
        leaves: leaves,
        holidays: holidays,
        today: today,
      );
  return _Data(
    today: today,
    profile: profile,
    holidays: holidays,
    leaves: leaves,
    remaining: balance.remaining,
  );
});

/// The user's choices, kept apart from the data so saving a leave does
/// not reset them. A null year or budget follows the data.
final _uiProvider = NotifierProvider<_UiNotifier, _Ui>(_UiNotifier.new);

class _Ui {
  const new({this.year, this.budget, this.sort = BridgeSort.efficiency});

  final int? year;
  final int? budget;
  final BridgeSort sort;
}

class _UiNotifier extends Notifier<_Ui> {
  @override
  _Ui build() => const _Ui();

  _Ui get value => state;

  set value(_Ui value) => state = value;
}

/// View model of the bridge planner: year and budget choice, suggestion
/// list with sorting, the yearly best plan and one-tap planning.
class BridgeViewModel extends Notifier<BridgeState> {
  @override
  BridgeState build() {
    final ui = ref.watch(_uiProvider);
    final data = ref.watch(_dataProvider);
    return BridgeState(
      sort: ui.sort,
      content: data.whenData((data) => _content(data, ui)),
    );
  }

  BridgeContent _content(_Data data, _Ui ui) {
    final years = {
      for (final holiday in data.holidays)
        if (holiday.date.year >= data.today.year) holiday.date.year,
    }.toList()..sort();
    final year = years.contains(ui.year)
        ? ui.year!
        : years.firstOrNull ?? data.today.year;
    final defaultBudget = math.max(
      BridgeContent.minBudget,
      data.remaining.floor(),
    );
    final budget = ui.budget ?? defaultBudget;
    final profile = data.profile;
    if (profile == null) {
      return BridgeContent(
        profile: null,
        years: years,
        year: year,
        budget: budget,
        remaining: data.remaining,
        planTotalDays: 0,
        planLeaveDays: 0,
        planCount: 0,
        items: const [],
      );
    }
    final planner = ref.read(bridgePlannerProvider);
    // Breaks that already started cannot be planned any more.
    final plan = planner.optimalPlan(
      year: year,
      profile: profile,
      holidays: data.holidays,
      budget: budget.toDouble(),
      after: data.today,
    );
    final suggestions = [
      ...planner.suggestions(
        year: year,
        profile: profile,
        holidays: data.holidays,
        budget: budget.toDouble(),
        after: data.today,
      ),
    ]..sort(_comparator(ui.sort));
    final holidays = {
      for (final holiday in data.holidays) holiday.date: holiday,
    };
    final leaveDays = {
      for (final leave in data.leaves)
        for (var i = 0; i < leave.range.dayCount; i++)
          leave.range.start.add(Duration(days: i)),
    };
    return BridgeContent(
      profile: profile,
      years: years,
      year: year,
      budget: budget,
      remaining: data.remaining,
      planTotalDays: plan.fold(0, (sum, item) => sum + item.totalDaysOff),
      planLeaveDays: plan.fold(0, (sum, item) => sum + item.leaveDaysUsed),
      planCount: plan.length,
      items: [
        for (final suggestion in suggestions)
          BridgeItem(
            suggestion: suggestion,
            days: _days(suggestion, holidays, profile.workSchedule),
            holidayNames: shortHolidayNames(suggestion.holidayNames),
            inPlan: plan.contains(suggestion),
            planned: suggestion.leaveDays.every(leaveDays.contains),
          ),
      ],
    );
  }

  static int Function(BridgeSuggestion, BridgeSuggestion) _comparator(
    BridgeSort sort,
  ) => switch (sort) {
    BridgeSort.efficiency => (a, b) {
      final byEfficiency = b.efficiency.compareTo(a.efficiency);
      return byEfficiency != 0
          ? byEfficiency
          : b.totalDaysOff.compareTo(a.totalDaysOff);
    },
    BridgeSort.length => (a, b) {
      final byLength = b.totalDaysOff.compareTo(a.totalDaysOff);
      return byLength != 0
          ? byLength
          : a.vacation.start.compareTo(b.vacation.start);
    },
    BridgeSort.date => (a, b) => a.vacation.start.compareTo(b.vacation.start),
  };

  static List<WeekStripDay> _days(
    BridgeSuggestion suggestion,
    Map<DateTime, Holiday> holidays,
    WorkSchedule schedule,
  ) => [
    for (var i = 0; i < suggestion.vacation.dayCount; i++)
      () {
        final date = suggestion.vacation.start.add(Duration(days: i));
        final holiday = holidays[date];
        final Meaning meaning;
        if (suggestion.leaveDays.contains(date)) {
          meaning = Meaning.bridge;
        } else if (holiday != null) {
          meaning = holiday.halfDay ? Meaning.eve : Meaning.holiday;
        } else if (!schedule.workDays.contains(date.weekday)) {
          meaning = Meaning.weekend;
        } else {
          meaning = Meaning.workday;
        }
        return WeekStripDay(date: date, meaning: meaning);
      }(),
  ];

  /// Holiday names without the day suffix of the holiday data, each name
  /// once: "Ramazan Bayramı 1. Gün" and "Ramazan Bayramı Arifesi" become
  /// "Ramazan Bayramı".
  static List<String> shortHolidayNames(List<String> names) {
    final suffix = RegExp(r'\s+(\d+\.\s*Gün|Arifesi)$');
    return {for (final name in names) name.replaceAll(suffix, '').trim()}
        .where((name) => name.isNotEmpty)
        .toList();
  }

  _Ui get _ui => ref.read(_uiProvider);

  /// Shows the suggestions of [year].
  void selectYear(int year) => ref.read(_uiProvider.notifier).value = _Ui(
    year: year,
    budget: _ui.budget,
    sort: _ui.sort,
  );

  /// Changes the order of the list.
  void selectSort(BridgeSort sort) => ref.read(_uiProvider.notifier).value =
      _Ui(year: _ui.year, budget: _ui.budget, sort: sort);

  /// Spends one leave day more.
  void increaseBudget() => _changeBudget(1);

  /// Spends one leave day less.
  void decreaseBudget() => _changeBudget(-1);

  void _changeBudget(int delta) {
    final content = state.content.value;
    if (content == null) return;
    final budget = (content.budget + delta).clamp(
      BridgeContent.minBudget,
      content.maxBudget,
    );
    ref.read(_uiProvider.notifier).value = _Ui(
      year: _ui.year,
      budget: budget,
      sort: _ui.sort,
    );
  }

  /// Saves [suggestion] as one planned annual leave from its first to its
  /// last leave day. Returns the new record's id, or null when saving
  /// failed.
  Future<String?> plan(BridgeSuggestion suggestion) async {
    final profile = state.content.value?.profile;
    if (profile == null || suggestion.leaveDays.isEmpty) return null;
    final days = [...suggestion.leaveDays]..sort();
    final id = 'bridge-${DateTime.now().microsecondsSinceEpoch}';
    final result = await ref
        .read(leaveRepositoryProvider)
        .save(
          LeaveRecord(
            id: id,
            profileId: profile.id,
            type: LeaveType.annual,
            range: DateRange(start: days.first, end: days.last),
          ),
        );
    return switch (result) {
      Ok() => id,
      Err() => null,
    };
  }

  /// Deletes the leave [id] created by [plan].
  Future<void> undoPlan(String id) async {
    await ref.read(leaveRepositoryProvider).delete(id);
  }
}
