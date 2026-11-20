import 'package:izin_planla/data/fakes/in_memory_collection.dart';
import 'package:izin_planla/data/fakes/sample_data.dart';
import 'package:izin_planla/data/repositories/profile_repository.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/utils/result.dart';

/// In-memory [ProfileRepository] seeded with [SampleData.profile].
class FakeProfileRepository implements ProfileRepository {
  final _profiles = InMemoryCollection<Profile>((profile) => profile.id, [
    SampleData.profile,
  ]);

  @override
  Stream<List<Profile>> watchAll() => _profiles.watch();

  @override
  Future<Profile?> findById(String id) async =>
      _profiles.items.where((profile) => profile.id == id).firstOrNull;

  @override
  Future<Result<void>> save(Profile profile) async {
    _profiles.put(profile);
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> delete(String id) async {
    _profiles.remove(id);
    return const Result.ok(null);
  }
}
