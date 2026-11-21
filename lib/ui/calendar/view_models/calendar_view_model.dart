import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show StreamProviderFamily;
import 'package:izin_planla/config/dependencies.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/ui/calendar/view_models/calendar_data.dart';
import 'package:izin_planla/ui/calendar/view_models/calendar_state.dart';
import 'package:izin_planla/ui/calendar/view_models/calendar_view_mode.dart';

/// Today as a UTC midnight date. Tests override it with a fixed day.
final calendarTodayProvider = Provider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime.utc(now.year, now.month, now.day);
});

/// State and actions of the calendar screen.
final calendarViewModelProvider =
    NotifierProvider<CalendarViewModel, CalendarState>(CalendarViewModel.new);

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

final _dataProvider = FutureProvider<CalendarData>((ref) async {
  final today = ref.watch(calendarTodayProvider);
  final settingsFuture = ref.watch(_settingsProvider.future);
  final profilesFuture = ref.watch(_profilesProvider.future);
  final holidaysFuture = ref.watch(_holidaysProvider.future);
  final settings = await settingsFuture;
  final profiles = await profilesFuture;
  final holidays = await holidaysFuture;
  final leaves = <String, List<LeaveRecord>>{};
  for (final profile in profiles) {
    leaves[profile.id] = await ref.watch(_leavesProvider(profile.id).future);
  }
  final active =
      profiles
          .where((profile) => profile.id == settings.activeProfileId)
          .firstOrNull ??
      profiles.firstOrNull;
  final bridges = <BridgeSuggestion>[];
  if (active != null) {
    final periods = ref
        .watch(entitlementCalculatorProvider)
        .periods(active, until: today);
    final balance = ref
        .watch(balanceCalculatorProvider)
        .balance(
          profile: active,
          periods: periods,
          leaves: leaves[active.id] ?? const [],
          holidays: holidays,
          today: today,
        );
    final planner = ref.watch(bridgePlannerProvider);
    final years = {for (final holiday in holidays) holiday.date.year}
      ..removeWhere((year) => year < today.year);
    for (final year in years) {
      bridges.addAll(
        planner.optimalPlan(
          year: year,
          profile: active,
          holidays: holidays,
          budget: math.max(0, balance.remaining),
        ),
      );
    }
  }
  return CalendarData(
    today: today,
    profiles: profiles,
    activeProfile: active,
    leaves: leaves,
    holidays: holidays,
    bridges: bridges,
  );
});

/// The user's choices on the calendar, kept apart from the data so a data
/// change does not reset them.
final _uiProvider = NotifierProvider<_UiNotifier, _Ui>(_UiNotifier.new);

class _Ui {
  const new({
    required this.focusedMonth,
    this.mode = CalendarViewMode.month,
    this.everyone = false,
    this.rangeMode = false,
    this.selectedDay,
    this.rangeStart,
    this.rangeEnd,
  });

  final DateTime focusedMonth;
  final CalendarViewMode mode;
  final bool everyone;
  final bool rangeMode;
  final DateTime? selectedDay;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;
}

class _UiNotifier extends Notifier<_Ui> {
  @override
  _Ui build() {
    final today = ref.read(calendarTodayProvider);
    return _Ui(
      focusedMonth: DateTime.utc(today.year, today.month),
      selectedDay: today,
    );
  }

  _Ui get value => state;

  set value(_Ui value) => state = value;
}

/// View model of the calendar screen: month and year views, the everyone
/// view, day details and range selection for a new leave.
class CalendarViewModel extends Notifier<CalendarState> {
  static const _yearsBack = 3;
  static const _yearsForward = 2;

  @override
  CalendarState build() {
    final today = ref.watch(calendarTodayProvider);
    final ui = ref.watch(_uiProvider);
    final data = ref.watch(_dataProvider);
    final everyone = ui.everyone && (data.value?.hasManyPeople ?? false);
    return CalendarState(
      data: data,
      focusedMonth: ui.focusedMonth,
      firstDay: DateTime.utc(today.year - _yearsBack),
      lastDay: DateTime.utc(today.year + _yearsForward, 12, 31),
      mode: ui.mode,
      everyone: everyone,
      rangeMode: ui.rangeMode,
      selectedDay: ui.selectedDay,
      rangeStart: ui.rangeStart,
      rangeEnd: ui.rangeEnd,
    );
  }

  _Ui get _ui => ref.read(_uiProvider);

  void _set({
    DateTime? focusedMonth,
    CalendarViewMode? mode,
    bool? everyone,
    bool? rangeMode,
    DateTime? selectedDay,
    DateTime? rangeStart,
    DateTime? rangeEnd,
    bool clearRange = false,
  }) {
    final ui = _ui;
    ref.read(_uiProvider.notifier).value = _Ui(
      focusedMonth: focusedMonth ?? ui.focusedMonth,
      mode: mode ?? ui.mode,
      everyone: everyone ?? ui.everyone,
      rangeMode: rangeMode ?? ui.rangeMode,
      selectedDay: selectedDay ?? ui.selectedDay,
      rangeStart: clearRange ? null : rangeStart ?? ui.rangeStart,
      rangeEnd: clearRange ? null : rangeEnd ?? ui.rangeEnd,
    );
  }

  DateTime _clampMonth(DateTime month) {
    final first = state.firstDay;
    final last = DateTime.utc(state.lastDay.year, state.lastDay.month);
    final value = DateTime.utc(month.year, month.month);
    if (value.isBefore(first)) return first;
    if (value.isAfter(last)) return last;
    return value;
  }

  /// Shows the month layout.
  void showMonth() => _set(mode: CalendarViewMode.month);

  /// Shows the year layout.
  void showYear() =>
      _set(mode: CalendarViewMode.year, rangeMode: false, clearRange: true);

  /// Turns the everyone view on or off.
  void toggleEveryone() => _set(everyone: !_ui.everyone);

  /// Turns range selection on or off and clears a started range.
  void toggleRangeMode() => _set(rangeMode: !_ui.rangeMode, clearRange: true);

  /// Shows the details of [day] and moves to its month.
  void selectDay(DateTime day) => _set(
    selectedDay: DateTime.utc(day.year, day.month, day.day),
    focusedMonth: _clampMonth(day),
    rangeMode: false,
    clearRange: true,
  );

  /// Stores the range the user picks. [end] is null until the second tap.
  void selectRange(DateTime? start, DateTime? end) {
    if (start == null) {
      _set(rangeMode: true, clearRange: true);
      return;
    }
    final ui = _ui;
    ref.read(_uiProvider.notifier).value = _Ui(
      focusedMonth: _clampMonth(end ?? start),
      mode: ui.mode,
      everyone: ui.everyone,
      rangeMode: true,
      selectedDay: ui.selectedDay,
      rangeStart: DateTime.utc(start.year, start.month, start.day),
      rangeEnd: end == null ? null : DateTime.utc(end.year, end.month, end.day),
    );
  }

  /// Moves to the month of [day], for example after a swipe.
  void focusMonth(DateTime day) => _set(focusedMonth: _clampMonth(day));

  /// Opens [month] in the month layout, from the year layout.
  void openMonth(DateTime month) =>
      _set(focusedMonth: _clampMonth(month), mode: CalendarViewMode.month);

  /// Moves one month, or one year in the year layout, back.
  void previous() {
    final month = _ui.focusedMonth;
    focusMonth(
      state.mode == CalendarViewMode.month
          ? DateTime.utc(month.year, month.month - 1)
          : DateTime.utc(month.year - 1, month.month),
    );
  }

  /// Moves one month, or one year in the year layout, forward.
  void next() {
    final month = _ui.focusedMonth;
    focusMonth(
      state.mode == CalendarViewMode.month
          ? DateTime.utc(month.year, month.month + 1)
          : DateTime.utc(month.year + 1, month.month),
    );
  }
}
