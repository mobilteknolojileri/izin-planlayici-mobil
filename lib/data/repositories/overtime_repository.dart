import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/utils/result.dart';

/// Stores overtime records. Implemented with drift by task 10.
abstract interface class OvertimeRepository {
  /// Emits the overtime records of [profileId] now and after every change.
  Stream<List<OvertimeRecord>> watchForProfile(String profileId);

  /// Adds or replaces [record].
  Future<Result<void>> save(OvertimeRecord record);

  /// Deletes the record with [id].
  Future<Result<void>> delete(String id);
}
