import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:izin_planla/config/dependencies.dart';
import 'package:izin_planla/domain/entitlement/entitlement_rule.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/ui/explain/view_models/explain_state.dart';

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

/// State and actions of the explain screen.
final NotifierProvider<ExplainViewModel, ExplainState>
explainViewModelProvider = NotifierProvider.autoDispose(ExplainViewModel.new);

/// View model of the "how was it calculated" screen: every accrual of the
/// active profile with the rules the entitlement calculator applied.
class ExplainViewModel extends Notifier<ExplainState> {
  /// Creates the view model. [clock] gives the current time, tests pass a
  /// fixed one.
  new({DateTime Function()? clock}) : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;

  @override
  ExplainState build() {
    final settings = ref.watch(_settingsProvider);
    final profiles = ref.watch(_profilesProvider);
    final holidays = ref.watch(_holidaysProvider);
    if (settings.hasError || profiles.hasError || holidays.hasError) {
      return const ExplainError();
    }
    final settingsValue = settings.value;
    final profileList = profiles.value;
    final holidayList = holidays.value;
    if (settingsValue == null || profileList == null || holidayList == null) {
      return const ExplainLoading();
    }
    final profile =
        profileList
            .where((p) => p.id == settingsValue.activeProfileId)
            .firstOrNull ??
        profileList.firstOrNull;
    if (profile == null) return const ExplainNoProfile();
    final leaves = ref.watch(_leavesProvider(profile.id));
    if (leaves.hasError) return const ExplainError();
    final leaveList = leaves.value;
    if (leaveList == null) return const ExplainLoading();

    final now = _clock();
    final today = DateTime.utc(now.year, now.month, now.day);
    final teacher =
        profile.isTeacher &&
        profile.employmentType == EmploymentType.civilServant;
    if (teacher) {
      return ExplainReady(
        profile: profile,
        isTeacher: true,
        periods: const [],
        showNoAbsenceNote: false,
      );
    }
    final entitlement = ref.watch(entitlementCalculatorProvider);
    final periods = entitlement.periods(profile, until: today);
    final balance = ref
        .watch(balanceCalculatorProvider)
        .balance(
          profile: profile,
          periods: periods,
          leaves: leaveList,
          holidays: holidayList,
          today: today,
        );
    final continuousCode = EntitlementRule.laborContinuousService.code;
    final saysContinuous = periods.any(
      (period) => period.rules.any((rule) => rule.code == continuousCode),
    );
    return ExplainReady(
      profile: profile,
      isTeacher: false,
      periods: periods.reversed.toList(),
      showNoAbsenceNote:
          profile.employmentType == EmploymentType.laborLaw &&
          profile.absencePeriods.isEmpty &&
          !saysContinuous,
      balance: balance,
      nextAccrual: entitlement.nextAccrual(profile, today),
    );
  }

  /// Loads the data again after an error.
  void retry() {
    ref
      ..invalidate(_settingsProvider)
      ..invalidate(_profilesProvider)
      ..invalidate(_holidaysProvider);
  }
}
