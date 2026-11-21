import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_planla/config/dependencies.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/ui/guide/view_models/guide_state.dart';

/// State and actions of the legislation guide screen.
final guideViewModelProvider = NotifierProvider<GuideViewModel, GuideState>(
  GuideViewModel.new,
);

final _settingsProvider = StreamProvider<AppSettings>(
  (ref) => ref.watch(settingsRepositoryProvider).watch(),
);

final _profilesProvider = StreamProvider<List<Profile>>(
  (ref) => ref.watch(profileRepositoryProvider).watchAll(),
);

/// The law of the active person, labour law before setup.
final _defaultLawProvider = FutureProvider<EmploymentType>((ref) async {
  final settingsFuture = ref.watch(_settingsProvider.future);
  final profilesFuture = ref.watch(_profilesProvider.future);
  final settings = await settingsFuture;
  final profiles = await profilesFuture;
  final active =
      profiles
          .where((profile) => profile.id == settings.activeProfileId)
          .firstOrNull ??
      profiles.firstOrNull;
  return active?.employmentType ?? EmploymentType.laborLaw;
});

/// The law the user picked, null until they pick one.
final _chosenLawProvider = NotifierProvider<_ChosenLaw, EmploymentType?>(
  _ChosenLaw.new,
);

class _ChosenLaw extends Notifier<EmploymentType?> {
  @override
  EmploymentType? build() => null;

  EmploymentType? get value => state;

  set value(EmploymentType? value) => state = value;
}

/// View model of the legislation guide: the sections for the labour law
/// or the civil servants law, the active person's law first.
class GuideViewModel extends Notifier<GuideState> {
  @override
  GuideState build() {
    final chosen = ref.watch(_chosenLawProvider);
    final fallback = ref.watch(_defaultLawProvider);
    return GuideState(
      law: chosen ?? fallback.value ?? EmploymentType.laborLaw,
      loading: chosen == null && fallback.isLoading,
    );
  }

  /// Opens [url] in the browser, returns whether it opened.
  Future<bool> openLink(String url) => ref.read(linkOpenerProvider).open(url);

  /// Shows the rules of [law].
  void selectLaw(EmploymentType law) {
    final chosen = ref.read(_chosenLawProvider.notifier);
    if (chosen.value != law) chosen.value = law;
  }
}
