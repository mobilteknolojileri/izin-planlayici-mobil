import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_planla/config/dependencies.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/ui/people/view_models/people_state.dart';
import 'package:izin_planla/ui/people/view_models/profile_draft.dart';
import 'package:izin_planla/utils/result.dart';

final StreamProvider<AppSettings> _settingsProvider =
    StreamProvider.autoDispose(
      (ref) => ref.watch(settingsRepositoryProvider).watch(),
    );

final StreamProvider<List<Profile>> _profilesProvider =
    StreamProvider.autoDispose(
      (ref) => ref.watch(profileRepositoryProvider).watchAll(),
    );

/// State and actions of the people screen.
final NotifierProvider<PeopleViewModel, PeopleState> peopleViewModelProvider =
    NotifierProvider.autoDispose(PeopleViewModel.new);

/// View model of the people screen: add, edit, delete and pick the active
/// profile. A delete can be undone, with the profile's leave and overtime
/// records.
class PeopleViewModel extends Notifier<PeopleState> {
  /// Creates the view model. [clock] gives the current time, tests pass a
  /// fixed one.
  new({DateTime Function()? clock}) : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;

  @override
  PeopleState build() {
    final settings = ref.watch(_settingsProvider);
    final profiles = ref.watch(_profilesProvider);
    if (settings.hasError || profiles.hasError) return const PeopleError();
    final settingsValue = settings.value;
    final profileList = profiles.value;
    if (settingsValue == null || profileList == null) {
      return const PeopleLoading();
    }
    final now = _clock();
    final active =
        profileList
            .where((p) => p.id == settingsValue.activeProfileId)
            .firstOrNull ??
        profileList.firstOrNull;
    return PeopleReady(
      profiles: profileList,
      activeId: active?.id,
      today: DateTime.utc(now.year, now.month, now.day),
    );
  }

  /// Makes the profile with [id] the one shown on the home screen.
  Future<void> select(String id) => _setActive(id);

  /// Saves [draft] as a new profile, or over [existing]. A new profile
  /// becomes active when no profile is active yet.
  Future<Result<void>> save(ProfileDraft draft, {Profile? existing}) async {
    final id = existing?.id ?? 'profile-${_clock().microsecondsSinceEpoch}';
    final hadActive = switch (state) {
      PeopleReady(:final activeId) => activeId != null,
      _ => false,
    };
    final result = await ref
        .read(profileRepositoryProvider)
        .save(draft.toProfile(id: id, base: existing));
    if (result is Ok<void> && !hadActive) await _setActive(id);
    return result;
  }

  /// Deletes [profile] with its leave and overtime records. Returns the
  /// undo action, or null when the delete failed.
  Future<Future<void> Function()?> delete(Profile profile) async {
    final profiles = ref.read(profileRepositoryProvider);
    final leaves = ref.read(leaveRepositoryProvider);
    final overtime = ref.read(overtimeRepositoryProvider);
    final settingsRepository = ref.read(settingsRepositoryProvider);
    final savedLeaves = await leaves.watchForProfile(profile.id).first;
    final savedOvertime = await overtime.watchForProfile(profile.id).first;
    final settings = await settingsRepository.watch().first;
    final deleted = await profiles.delete(profile.id);
    if (deleted is! Ok<void>) return null;
    final current = state;
    if (current is PeopleReady && current.activeId == profile.id) {
      final other = current.profiles.where((p) => p.id != profile.id);
      await settingsRepository.save(
        settings.copyWith(activeProfileId: other.firstOrNull?.id),
      );
    }
    return () async {
      await profiles.save(profile);
      for (final record in savedLeaves) {
        await leaves.save(record);
      }
      for (final record in savedOvertime) {
        await overtime.save(record);
      }
      await settingsRepository.save(settings);
    };
  }

  /// Loads the data again after an error.
  void retry() {
    ref
      ..invalidate(_settingsProvider)
      ..invalidate(_profilesProvider);
  }

  Future<void> _setActive(String id) async {
    final repository = ref.read(settingsRepositoryProvider);
    final settings = await repository.watch().first;
    await repository.save(settings.copyWith(activeProfileId: id));
  }
}
