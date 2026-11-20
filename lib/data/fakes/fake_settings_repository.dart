import 'dart:async';

import 'package:izin_planla/data/fakes/sample_data.dart';
import 'package:izin_planla/data/repositories/settings_repository.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/utils/result.dart';

/// In-memory [SettingsRepository] with [SampleData.profile] active.
class FakeSettingsRepository implements SettingsRepository {
  AppSettings _settings = const AppSettings(
    activeProfileId: SampleData.profileId,
  );
  final StreamController<AppSettings> _changes =
      StreamController<AppSettings>.broadcast();

  @override
  Stream<AppSettings> watch() async* {
    yield _settings;
    yield* _changes.stream;
  }

  @override
  Future<Result<void>> save(AppSettings settings) async {
    _settings = settings;
    _changes.add(settings);
    return const Result.ok(null);
  }
}
