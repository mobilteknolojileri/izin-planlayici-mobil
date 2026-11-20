import 'package:izin_planla/data/fakes/in_memory_collection.dart';
import 'package:izin_planla/data/repositories/overtime_repository.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/utils/result.dart';

/// In-memory [OvertimeRepository], empty at start.
class FakeOvertimeRepository implements OvertimeRepository {
  final _records = InMemoryCollection<OvertimeRecord>((record) => record.id);

  @override
  Stream<List<OvertimeRecord>> watchForProfile(String profileId) => _records
      .watch()
      .map((all) => [...all.where((r) => r.profileId == profileId)]);

  @override
  Future<Result<void>> save(OvertimeRecord record) async {
    _records.put(record);
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> delete(String id) async {
    _records.remove(id);
    return const Result.ok(null);
  }
}
