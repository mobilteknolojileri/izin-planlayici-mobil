import 'package:izin_planla/data/repositories/profile_repository.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/utils/result.dart';

/// [ProfileRepository] over a fixed list of profiles.
class StubProfileRepository implements ProfileRepository {
  /// Creates a repository holding [profiles].
  new(List<Profile> profiles) : _profiles = [...profiles];

  final List<Profile> _profiles;

  @override
  Stream<List<Profile>> watchAll() => Stream.value([..._profiles]);

  @override
  Future<Profile?> findById(String id) async =>
      _profiles.where((profile) => profile.id == id).firstOrNull;

  @override
  Future<Result<void>> save(Profile profile) async {
    _profiles
      ..removeWhere((p) => p.id == profile.id)
      ..add(profile);
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> delete(String id) async {
    _profiles.removeWhere((p) => p.id == id);
    return const Result.ok(null);
  }
}
