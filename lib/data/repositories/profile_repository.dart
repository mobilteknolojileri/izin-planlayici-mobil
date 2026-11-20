import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/utils/result.dart';

/// Stores profiles. Implemented with drift by task 10.
abstract interface class ProfileRepository {
  /// Emits all profiles now and after every change.
  Stream<List<Profile>> watchAll();

  /// The profile with [id], or null.
  Future<Profile?> findById(String id);

  /// Adds or replaces [profile].
  Future<Result<void>> save(Profile profile);

  /// Deletes the profile with [id] and its leave and overtime records.
  Future<Result<void>> delete(String id);
}
