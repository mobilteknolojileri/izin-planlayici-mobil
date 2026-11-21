import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:izin_planla/config/dependencies.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/ui/leave_form/view_models/leave_draft.dart';
import 'package:izin_planla/ui/leave_form/view_models/leave_form_save_result.dart';
import 'package:izin_planla/ui/leave_form/view_models/leave_form_state.dart';
import 'package:izin_planla/utils/result.dart';

/// What the leave form opens with: an existing leave to edit, or the
/// first and last day of a new one, for example a range picked on the
/// calendar. Everything null opens an empty form.
typedef LeaveFormArgs = ({String? leaveId, DateTime? start, DateTime? end});

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

/// State and actions of the leave form, one per [LeaveFormArgs].
final NotifierProviderFamily<LeaveFormViewModel, LeaveFormState, LeaveFormArgs>
leaveFormViewModelProvider = NotifierProvider.autoDispose.family(
  LeaveFormViewModel.new,
);

/// The data the live preview needs.
typedef _Context = ({
  Profile profile,
  List<LeaveRecord> leaves,
  List<Holiday> holidays,
  DateTime today,
});

/// View model of the leave form: keeps the answers and shows, while the
/// user types, how many days the leave costs, day by day, with the
/// balance, split rule and travel leave warnings. All counting is done by
/// the domain calculators.
class LeaveFormViewModel extends Notifier<LeaveFormState> {
  /// Creates the view model for one [LeaveFormArgs]. [clock] gives the
  /// current time, tests pass a fixed one.
  new(this._args, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final LeaveFormArgs _args;
  final DateTime Function() _clock;

  LeaveDraft? _draft;
  LeaveRecord? _existing;
  String? _newId;
  _Context? _context;
  bool _showErrors = false;
  bool _saving = false;

  @override
  LeaveFormState build() {
    final settings = ref.watch(_settingsProvider);
    final profiles = ref.watch(_profilesProvider);
    final holidays = ref.watch(_holidaysProvider);
    if (settings.hasError || profiles.hasError || holidays.hasError) {
      return const LeaveFormError();
    }
    final settingsValue = settings.value;
    final profileList = profiles.value;
    final holidayList = holidays.value;
    if (settingsValue == null || profileList == null || holidayList == null) {
      return const LeaveFormLoading();
    }
    final profile =
        profileList
            .where((p) => p.id == settingsValue.activeProfileId)
            .firstOrNull ??
        profileList.firstOrNull;
    if (profile == null) return const LeaveFormNoProfile();
    final leaves = ref.watch(_leavesProvider(profile.id));
    if (leaves.hasError) return const LeaveFormError();
    final leaveList = leaves.value;
    if (leaveList == null) return const LeaveFormLoading();

    final now = _clock();
    _context = (
      profile: profile,
      leaves: leaveList,
      holidays: holidayList,
      today: DateTime.utc(now.year, now.month, now.day),
    );
    _existing ??= leaveList.where((l) => l.id == _args.leaveId).firstOrNull;
    _draft ??= switch (_existing) {
      final existing? => LeaveDraft.fromRecord(existing),
      null => LeaveDraft(start: _args.start, end: _args.end ?? _args.start),
    };
    return _compose();
  }

  /// Chooses the leave type.
  void setType(LeaveType type) => _edit(_draft?.copyWith(type: type));

  /// Chooses whole days, a half day or hours.
  void setUnit(LeaveUnit unit) => _edit(_draft?.copyWith(unit: unit));

  /// Chooses the first day.
  void setStart(DateTime date) => _edit(_draft?.copyWith(start: date));

  /// Chooses the last day.
  void setEnd(DateTime date) => _edit(_draft?.copyWith(end: date));

  /// Changes the hours, as typed.
  void setHours(String hours) => _edit(_draft?.copyWith(hours: hours));

  /// Changes the name of an "other" leave.
  void setCustomName(String name) => _edit(_draft?.copyWith(customName: name));

  /// Chooses the child's birth date for paternity leave.
  void setEventDate(DateTime date) => _edit(_draft?.copyWith(eventDate: date));

  /// Marks the leave as a civil servant's second excuse block.
  void setSecondExcuse({required bool value}) =>
      _edit(_draft?.copyWith(secondExcuse: value));

  /// Changes the note.
  void setNote(String note) => _edit(_draft?.copyWith(note: note));

  /// Saves the leave. Shows the errors and saves nothing when the form is
  /// not valid.
  Future<LeaveFormSaveResult> save() async {
    _showErrors = true;
    final current = _compose();
    state = current;
    final record = current is LeaveFormReady && current.isValid
        ? _record(current.draft)
        : null;
    if (record == null) return const LeaveFormInvalid();
    final repository = ref.read(leaveRepositoryProvider);
    final previous = _existing;
    _setSaving(saving: true);
    final result = await repository.save(record);
    if (ref.mounted) _setSaving(saving: false);
    if (result is! Ok<void>) return const LeaveFormFailed();
    return LeaveFormSaved(
      undo: previous == null ? null : () => repository.save(previous),
    );
  }

  /// Deletes the edited leave. Returns the undo action, or null when
  /// nothing was deleted.
  Future<Future<void> Function()?> delete() async {
    final record = _existing;
    if (record == null) return null;
    final repository = ref.read(leaveRepositoryProvider);
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

  void _edit(LeaveDraft? draft) {
    if (draft == null) return;
    _draft = draft;
    state = _compose();
  }

  void _setSaving({required bool saving}) {
    _saving = saving;
    state = _compose();
  }

  LeaveFormState _compose() {
    final context = _context;
    final draft = _draft;
    if (context == null || draft == null) return const LeaveFormLoading();
    final profile = context.profile;
    final civil = profile.employmentType == EmploymentType.civilServant;
    final deducts =
        draft.type == LeaveType.annual ||
        (draft.type == LeaveType.excuse && civil && draft.secondExcuse);
    final range = draft.range;
    final base = LeaveFormReady(
      draft: draft,
      isEditing: _existing != null,
      employmentType: profile.employmentType,
      dailyHours: profile.workSchedule.dailyWorkingHours,
      today: context.today,
      showErrors: _showErrors,
      saving: _saving,
      deducts: deducts,
      dayCount: deducts && range != null && draft.unit == LeaveUnit.days
          ? ref
                .read(leaveDayCounterProvider)
                .count(range, profile, context.holidays)
          : null,
      suggestedDays: draft.type == LeaveType.annual
          ? null
          : ref
                .read(statutoryLeaveAdvisorProvider)
                .suggestedDays(draft.type, profile, eventDate: draft.eventDate),
    );
    final record = base.isValid ? _record(draft) : null;
    if (record == null) return base;
    final periods = ref
        .read(entitlementCalculatorProvider)
        .periods(profile, until: context.today);
    final leaves = [
      for (final leave in context.leaves)
        if (leave.id != record.id) leave,
      record,
    ];
    double? remaining;
    if (deducts) {
      remaining = ref
          .read(balanceCalculatorProvider)
          .balance(
            profile: profile,
            periods: periods,
            leaves: leaves,
            holidays: context.holidays,
            today: context.today,
          )
          .remaining;
    }
    final found = {
      for (final warning
          in ref
              .read(splitRuleCheckerProvider)
              .check(
                profile: profile,
                periods: periods,
                leaves: leaves,
                holidays: context.holidays,
              ))
        warning.type,
    };
    return LeaveFormReady(
      draft: draft,
      isEditing: base.isEditing,
      employmentType: base.employmentType,
      dailyHours: base.dailyHours,
      today: base.today,
      showErrors: base.showErrors,
      saving: base.saving,
      deducts: deducts,
      dayCount: base.dayCount,
      suggestedDays: base.suggestedDays,
      remainingAfter: remaining,
      shortfall: remaining != null && remaining < 0 ? -remaining : null,
      warnings: [
        if (draft.type == LeaveType.annual &&
            found.contains(LeaveWarningType.splitRule))
          LeaveWarningType.splitRule,
        if (draft.type == LeaveType.travel &&
            found.contains(LeaveWarningType.travelLeaveLimit))
          LeaveWarningType.travelLeaveLimit,
      ],
    );
  }

  LeaveRecord? _record(LeaveDraft draft) {
    final context = _context;
    final range = draft.range;
    if (context == null || range == null) return null;
    final profile = context.profile;
    final civil = profile.employmentType == EmploymentType.civilServant;
    final note = draft.note.trim();
    final id =
        _existing?.id ??
        (_newId ??= 'leave-${_clock().microsecondsSinceEpoch}');
    return LeaveRecord(
      id: id,
      profileId: profile.id,
      type: draft.type,
      range: range,
      unit: draft.unit,
      hours: draft.unit == LeaveUnit.hours ? draft.hoursValue : null,
      customTypeName: draft.type == LeaveType.other
          ? draft.customName.trim()
          : null,
      eventDate: draft.type == LeaveType.paternity ? draft.eventDate : null,
      deductsFromAnnual:
          draft.type == LeaveType.excuse && civil && draft.secondExcuse,
      note: note.isEmpty ? null : note,
    );
  }
}
