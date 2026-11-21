import 'package:flutter/foundation.dart';
import 'package:izin_planla/domain/models/models.dart';

/// The answers of a profile form while the user is typing, shared by the
/// setup and the people form.
///
/// Number fields keep the raw text, so a half typed "4," stays on screen.
/// [toProfile] turns the answers into a [Profile] once [isComplete].
@immutable
class ProfileDraft {
  /// Creates a draft. Every answer is empty by default.
  const new({
    this.name = '',
    this.employmentType,
    this.startDate,
    this.birthDate,
    this.worksSaturday,
    this.priorYears = '',
    this.priorMonths = '',
    this.priorDays = '',
    this.usedBefore = '',
    this.contractDays = '',
    this.dailyHours = '',
    this.isUnderground = false,
    this.isTeacher = false,
  });

  /// The answers stored in [profile].
  factory fromProfile(Profile profile) {
    final prior = profile.priorService;
    return ProfileDraft(
      name: profile.name,
      employmentType: profile.employmentType,
      startDate: profile.employmentStartDate,
      birthDate: profile.birthDate,
      worksSaturday: profile.workSchedule.workDays.contains(DateTime.saturday),
      priorYears: _text(prior.years),
      priorMonths: _text(prior.months),
      priorDays: _text(prior.days),
      usedBefore: _text(profile.leaveUsedBeforeTracking),
      contractDays: _text(profile.contractExtraDays),
      dailyHours: _text(profile.workSchedule.dailyWorkingHours),
      isUnderground: profile.isUnderground,
      isTeacher: profile.isTeacher,
    );
  }

  /// Name of the person.
  final String name;

  /// The law the person works under, null until chosen.
  final EmploymentType? employmentType;

  /// Start date at the workplace (UTC midnight), null until chosen.
  final DateTime? startDate;

  /// Birth date (UTC midnight), null until chosen.
  final DateTime? birthDate;

  /// Whether the person works on Saturdays, null until answered.
  final bool? worksSaturday;

  /// Years of prior service, as typed.
  final String priorYears;

  /// Months of prior service, as typed.
  final String priorMonths;

  /// Days of prior service, as typed.
  final String priorDays;

  /// Annual leave days used before the app, as typed.
  final String usedBefore;

  /// Extra days from a contract, as typed.
  final String contractDays;

  /// Working hours per day, as typed. Empty means 8.
  final String dailyHours;

  /// Whether the person works underground (4857 only).
  final bool isUnderground;

  /// Whether the person is a teacher (657 only).
  final bool isTeacher;

  /// Whether the person works under Labour Law 4857.
  bool get isLabor => employmentType == EmploymentType.laborLaw;

  /// Whether every whole number field holds a valid number or nothing.
  bool get numbersValid =>
      isWholeNumber(priorYears) &&
      isWholeNumber(priorMonths) &&
      isWholeNumber(priorDays) &&
      isWholeNumber(contractDays) &&
      isNumber(usedBefore) &&
      isNumber(dailyHours) &&
      (_number(dailyHours) ?? 8) > 0;

  /// Whether the draft holds everything a [Profile] needs. The name is
  /// checked separately, because the setup fills it in itself.
  bool get isComplete =>
      employmentType != null &&
      startDate != null &&
      // Only the age rules of 4857 need the birth date.
      (employmentType == EmploymentType.civilServant || birthDate != null) &&
      numbersValid;

  /// Whether [text] is empty or a whole number such as `12`.
  static bool isWholeNumber(String text) =>
      text.trim().isEmpty || int.tryParse(text.trim()) != null;

  /// Whether [text] is empty or a number such as `4,5`.
  static bool isNumber(String text) =>
      text.trim().isEmpty || _number(text) != null;

  /// A copy with the given answers replaced.
  ProfileDraft copyWith({
    String? name,
    EmploymentType? employmentType,
    DateTime? startDate,
    DateTime? birthDate,
    bool? worksSaturday,
    String? priorYears,
    String? priorMonths,
    String? priorDays,
    String? usedBefore,
    String? contractDays,
    String? dailyHours,
    bool? isUnderground,
    bool? isTeacher,
  }) => ProfileDraft(
    name: name ?? this.name,
    employmentType: employmentType ?? this.employmentType,
    startDate: startDate ?? this.startDate,
    birthDate: birthDate ?? this.birthDate,
    worksSaturday: worksSaturday ?? this.worksSaturday,
    priorYears: priorYears ?? this.priorYears,
    priorMonths: priorMonths ?? this.priorMonths,
    priorDays: priorDays ?? this.priorDays,
    usedBefore: usedBefore ?? this.usedBefore,
    contractDays: contractDays ?? this.contractDays,
    dailyHours: dailyHours ?? this.dailyHours,
    isUnderground: isUnderground ?? this.isUnderground,
    isTeacher: isTeacher ?? this.isTeacher,
  );

  /// The profile with [id] built from the answers. Fields the form does not
  /// show, such as absences, come from [base] when editing.
  ///
  /// Call only when [isComplete].
  Profile toProfile({required String id, Profile? base}) {
    final type = employmentType ?? EmploymentType.laborLaw;
    final labor = type == EmploymentType.laborLaw;
    final schedule = base?.workSchedule ?? const WorkSchedule();
    final saturday = worksSaturday;
    // A new list either way: the schedule's own list cannot be sorted in
    // place, and civil servants never answer the Saturday question.
    final workDays = [
      for (final day in schedule.workDays)
        if (saturday == null || day != DateTime.saturday) day,
      if (saturday ?? false) DateTime.saturday,
    ]..sort();
    final updated = (
      name: name.trim(),
      start: startDate ?? DateTime.utc(2000),
      // Civil servants are not asked, their leave does not depend on age.
      birth: type == EmploymentType.laborLaw ? birthDate : null,
      schedule: schedule.copyWith(
        workDays: workDays,
        dailyWorkingHours: _number(dailyHours) ?? 8,
      ),
      prior: ServiceDuration(
        years: _whole(priorYears),
        months: _whole(priorMonths),
        days: _whole(priorDays),
      ),
    );
    final profile =
        base ??
        Profile(
          id: id,
          name: updated.name,
          employmentType: type,
          employmentStartDate: updated.start,
          birthDate: updated.birth,
        );
    return profile.copyWith(
      name: updated.name,
      employmentType: type,
      employmentStartDate: updated.start,
      birthDate: updated.birth,
      workSchedule: updated.schedule,
      priorService: updated.prior,
      isUnderground: labor && isUnderground,
      contractExtraDays: labor ? _whole(contractDays) : 0,
      leaveUsedBeforeTracking: _number(usedBefore) ?? 0,
      isTeacher: !labor && isTeacher,
    );
  }

  static double? _number(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;
    return double.tryParse(trimmed.replaceAll(',', '.'));
  }

  static int _whole(String text) => int.tryParse(text.trim()) ?? 0;

  /// [value] as typed by a Turkish user: `8`, `4,5`, nothing for zero.
  static String _text(num value) {
    if (value == 0) return '';
    if (value == value.roundToDouble()) return value.round().toString();
    return value.toString().replaceAll('.', ',');
  }
}
