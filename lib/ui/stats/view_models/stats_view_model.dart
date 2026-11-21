import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show StreamProviderFamily;
import 'package:izin_planla/config/dependencies.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/ui/stats/view_models/stats_content.dart';
import 'package:izin_planla/ui/stats/view_models/stats_state.dart';

/// Today as a UTC midnight date. Tests override it with a fixed day.
final statsTodayProvider = Provider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime.utc(now.year, now.month, now.day);
});

/// State and actions of the statistics screen.
final statsViewModelProvider = NotifierProvider<StatsViewModel, StatsState>(
  StatsViewModel.new,
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

class _Data {
  const new({
    required this.today,
    required this.profiles,
    required this.activeProfileId,
    required this.leaves,
    required this.holidays,
  });

  final DateTime today;
  final List<Profile> profiles;
  final String? activeProfileId;
  final Map<String, List<LeaveRecord>> leaves;
  final List<Holiday> holidays;
}

final _dataProvider = FutureProvider<_Data>((ref) async {
  final today = ref.watch(statsTodayProvider);
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
  return _Data(
    today: today,
    profiles: profiles,
    activeProfileId: settings.activeProfileId,
    leaves: leaves,
    holidays: holidays,
  );
});

/// The person and year the user chose. Empty values follow the data:
/// the active person and the current year.
final _uiProvider = NotifierProvider<_UiNotifier, _Ui>(_UiNotifier.new);

class _Ui {
  const new({this.year, this.profileId, this.everyone = false});

  final int? year;
  final String? profileId;
  final bool everyone;
}

class _UiNotifier extends Notifier<_Ui> {
  @override
  _Ui build() => const _Ui();

  _Ui get value => state;

  set value(_Ui value) => state = value;
}

/// View model of the statistics screen: earned and used leave per year,
/// leave per month and per type, and the days off of a year, for one
/// person or everyone together.
class StatsViewModel extends Notifier<StatsState> {
  /// Number of years in the earned and used chart.
  static const chartYears = 5;

  /// Number of years offered in the year filter.
  static const maxYears = 10;

  @override
  StatsState build() {
    final ui = ref.watch(_uiProvider);
    final data = ref.watch(_dataProvider);
    return StatsState(content: data.whenData((data) => _content(data, ui)));
  }

  StatsContent _content(_Data data, _Ui ui) {
    final ids = {for (final profile in data.profiles) profile.id};
    final String? selectedId;
    if (ui.everyone && data.profiles.length > 1) {
      selectedId = null;
    } else if (ids.contains(ui.profileId)) {
      selectedId = ui.profileId;
    } else if (ids.contains(data.activeProfileId)) {
      selectedId = data.activeProfileId;
    } else {
      selectedId = data.profiles.firstOrNull?.id;
    }
    final people = [
      for (final profile in data.profiles)
        if (selectedId == null || profile.id == selectedId) profile,
    ];
    final firstYear = people.isEmpty
        ? data.today.year
        : people
              .map((profile) => profile.employmentStartDate.year)
              .reduce(math.min);
    final years = [
      for (
        var year = math.max(firstYear, data.today.year - maxYears + 1);
        year <= data.today.year;
        year++
      )
        year,
    ];
    final year = years.contains(ui.year) ? ui.year! : data.today.year;
    final chartFrom = math.max(years.first, year - chartYears + 1);
    return StatsContent(
      profiles: data.profiles,
      selectedProfileId: selectedId,
      years: years,
      year: year,
      summary: _summary(year, people, data),
      byYear: [
        for (var y = chartFrom; y <= year; y++) _summary(y, people, data),
      ],
      hasLeaves: people.any(
        (profile) => data.leaves[profile.id]?.isNotEmpty ?? false,
      ),
    );
  }

  YearSummary _summary(int year, List<Profile> people, _Data data) {
    final entitlement = ref.read(entitlementCalculatorProvider);
    final calculator = ref.read(yearSummaryCalculatorProvider);
    var earned = 0.0;
    var used = 0.0;
    var daysOff = 0;
    final byType = <LeaveType, double>{};
    final byMonth = <int, double>{};
    for (final profile in people) {
      final summary = calculator.summary(
        year: year,
        profile: profile,
        periods: entitlement.periods(
          profile,
          until: DateTime.utc(year, 12, 31),
        ),
        // Statistics show what was used. Leave that starts after today is
        // planned and appears on the home page and in the leave list.
        leaves: [
          for (final leave in data.leaves[profile.id] ?? const <LeaveRecord>[])
            if (!leave.range.start.isAfter(data.today)) leave,
        ],
        holidays: data.holidays,
      );
      earned += summary.earned;
      used += summary.used;
      daysOff += summary.totalDaysOff;
      for (final MapEntry(:key, :value) in summary.usedByType.entries) {
        byType[key] = (byType[key] ?? 0) + value;
      }
      for (final MapEntry(:key, :value) in summary.usedByMonth.entries) {
        byMonth[key] = (byMonth[key] ?? 0) + value;
      }
    }
    return YearSummary(
      year: year,
      earned: earned,
      used: used,
      totalDaysOff: daysOff,
      usedByType: byType,
      usedByMonth: byMonth,
    );
  }

  _Ui get _ui => ref.read(_uiProvider);

  /// Shows the statistics of [year].
  void selectYear(int year) => ref.read(_uiProvider.notifier).value = _Ui(
    year: year,
    profileId: _ui.profileId,
    everyone: _ui.everyone,
  );

  /// Shows the statistics of the person [profileId].
  void selectProfile(String profileId) => ref.read(_uiProvider.notifier).value =
      _Ui(year: _ui.year, profileId: profileId);

  /// Shows everyone together.
  void selectEveryone() => ref.read(_uiProvider.notifier).value = _Ui(
    year: _ui.year,
    profileId: _ui.profileId,
    everyone: true,
  );
}
