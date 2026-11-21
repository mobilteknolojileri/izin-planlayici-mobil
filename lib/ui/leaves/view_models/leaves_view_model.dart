import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:izin_planla/config/dependencies.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/ui/leaves/view_models/leave_list_item.dart';
import 'package:izin_planla/ui/leaves/view_models/leaves_section.dart';
import 'package:izin_planla/ui/leaves/view_models/leaves_state.dart';
import 'package:izin_planla/utils/result.dart';

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

final StreamProviderFamily<List<OvertimeRecord>, String> _overtimeProvider =
    StreamProvider.autoDispose.family(
      (ref, profileId) =>
          ref.watch(overtimeRepositoryProvider).watchForProfile(profileId),
    );

/// State and actions of the leaves tab.
final NotifierProvider<LeavesViewModel, LeavesState> leavesViewModelProvider =
    NotifierProvider.autoDispose(LeavesViewModel.new);

/// View model of the leaves tab: planned and used leave of one year,
/// filtered by type, and the hourly leave and overtime of that year.
class LeavesViewModel extends Notifier<LeavesState> {
  /// Creates the view model. [clock] gives the current time, tests pass a
  /// fixed one.
  new({DateTime Function()? clock}) : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;

  LeavesSection _section = LeavesSection.leaves;
  int? _year;
  LeaveType? _type;
  String? _profileId;

  @override
  LeavesState build() {
    final settings = ref.watch(_settingsProvider);
    final profiles = ref.watch(_profilesProvider);
    final holidays = ref.watch(_holidaysProvider);
    if (settings.hasError || profiles.hasError || holidays.hasError) {
      return const LeavesError();
    }
    final settingsValue = settings.value;
    final profileList = profiles.value;
    final holidayList = holidays.value;
    if (settingsValue == null || profileList == null || holidayList == null) {
      return const LeavesLoading();
    }
    final profile =
        profileList
            .where((p) => p.id == settingsValue.activeProfileId)
            .firstOrNull ??
        profileList.firstOrNull;
    if (profile == null) return const LeavesNoProfile();
    _profileId = profile.id;
    final leaves = ref.watch(_leavesProvider(profile.id));
    final overtime = ref.watch(_overtimeProvider(profile.id));
    if (leaves.hasError || overtime.hasError) return const LeavesError();
    final leaveList = leaves.value;
    final overtimeList = overtime.value;
    if (leaveList == null || overtimeList == null) {
      return const LeavesLoading();
    }
    return _ready(profile, leaveList, overtimeList, holidayList);
  }

  /// Shows the leaves or the hours part.
  void selectSection(LeavesSection section) {
    _section = section;
    ref.invalidateSelf();
  }

  /// Shows the records of [year].
  void selectYear(int year) {
    _year = year;
    ref.invalidateSelf();
  }

  /// Shows only leave of [type], or every type when null.
  void selectType(LeaveType? type) {
    _type = type;
    ref.invalidateSelf();
  }

  /// Whether [hours] is a positive number such as `2` or `1,5`.
  bool isValidHours(String hours) => (_hours(hours) ?? 0) > 0;

  /// Saves an overtime record, replacing [existing] when given. Returns
  /// whether it was saved.
  Future<bool> saveOvertime({
    required DateTime date,
    required String hours,
    required String note,
    OvertimeRecord? existing,
  }) async {
    final profileId = _profileId;
    final value = _hours(hours);
    if (profileId == null || value == null || value <= 0) return false;
    final trimmed = note.trim();
    final record = OvertimeRecord(
      id: existing?.id ?? 'overtime-${_clock().microsecondsSinceEpoch}',
      profileId: profileId,
      date: date,
      hours: value,
      note: trimmed.isEmpty ? null : trimmed,
    );
    final result = await ref.read(overtimeRepositoryProvider).save(record);
    return result is Ok<void>;
  }

  /// Deletes [record]. Returns the undo action, or null when the delete
  /// failed.
  Future<Future<void> Function()?> deleteOvertime(OvertimeRecord record) async {
    final repository = ref.read(overtimeRepositoryProvider);
    final result = await repository.delete(record.id);
    if (result is! Ok<void>) return null;
    return () => repository.save(record);
  }

  /// Loads the data again after an error.
  void retry() {
    ref
      ..invalidate(_settingsProvider)
      ..invalidate(_profilesProvider)
      ..invalidate(_holidaysProvider);
  }

  LeavesReady _ready(
    Profile profile,
    List<LeaveRecord> leaves,
    List<OvertimeRecord> overtime,
    List<Holiday> holidays,
  ) {
    final now = _clock();
    final today = DateTime.utc(now.year, now.month, now.day);
    final years = {
      today.year,
      for (final leave in leaves) leave.range.start.year,
      for (final record in overtime) record.date.year,
    }.toList()..sort((a, b) => b.compareTo(a));
    final year = _year ?? today.year;
    final counter = ref.watch(leaveDayCounterProvider);
    final ofYear = leaves.where((l) => l.range.start.year == year);
    final types = {
      for (final leave in ofYear)
        if (leave.unit != LeaveUnit.hours) leave.type,
    }.toList()..sort((a, b) => a.index.compareTo(b.index));
    final type = types.contains(_type) ? _type : null;

    LeaveListItem item(LeaveRecord leave) {
      final reduces = leave.type == LeaveType.annual || leave.deductsFromAnnual;
      return LeaveListItem(
        record: leave,
        planned: leave.range.start.isAfter(today),
        deducted: reduces && leave.unit == LeaveUnit.days
            ? counter.count(leave.range, profile, holidays).total
            : null,
      );
    }

    final days = [
      for (final leave in ofYear)
        if (leave.unit != LeaveUnit.hours &&
            (type == null || leave.type == type))
          item(leave),
    ];
    final hourly = [
      for (final leave in ofYear)
        if (leave.unit == LeaveUnit.hours) item(leave),
    ]..sort((a, b) => b.record.range.start.compareTo(a.record.range.start));
    final overtimeOfYear = [
      for (final record in overtime)
        if (record.date.year == year) record,
    ]..sort((a, b) => b.date.compareTo(a.date));
    return LeavesReady(
      today: today,
      section: _section,
      year: year,
      years: years,
      type: type,
      types: types,
      hasAnyLeave: leaves.isNotEmpty,
      planned: [
        for (final entry in days)
          if (entry.planned) entry,
      ]..sort((a, b) => a.record.range.start.compareTo(b.record.range.start)),
      used: [
        for (final entry in days)
          if (!entry.planned) entry,
      ]..sort((a, b) => b.record.range.start.compareTo(a.record.range.start)),
      hourly: hourly,
      overtime: overtimeOfYear,
      hourlyTotal: hourly.fold(
        0,
        (sum, entry) => sum + (entry.record.hours ?? 0),
      ),
      overtimeTotal: overtimeOfYear.fold(
        0,
        (sum, record) => sum + record.hours,
      ),
    );
  }

  static double? _hours(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;
    return double.tryParse(trimmed.replaceAll(',', '.'));
  }
}
