import 'package:izin_planla/data/fakes/in_memory_collection.dart';
import 'package:izin_planla/data/fakes/sample_data.dart';
import 'package:izin_planla/data/repositories/leave_repository.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/utils/result.dart';

/// In-memory [LeaveRepository] seeded with [SampleData.leaves].
class FakeLeaveRepository implements LeaveRepository {
  final _records = InMemoryCollection<LeaveRecord>(
    (record) => record.id,
    SampleData.leaves,
  );

  @override
  Stream<List<LeaveRecord>> watchForProfile(String profileId) => _records
      .watch()
      .map((all) => [...all.where((r) => r.profileId == profileId)]);

  @override
  Future<Result<void>> save(LeaveRecord record) async {
    _records.put(record);
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> delete(String id) async {
    _records.remove(id);
    return const Result.ok(null);
  }
}
