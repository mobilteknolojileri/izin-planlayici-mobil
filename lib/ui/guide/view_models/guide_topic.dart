import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/ui/guide/view_models/guide_source.dart';

/// Sections of the guide, in reading order. Every rule comes from
/// `docs/mevzuat.md`.
enum GuideTopic {
  /// When the right to annual leave starts (mevzuat 1.1, 1.6, 2.1, 2.2).
  rightStart,

  /// How many days (mevzuat 1.3-1.5, 1.7, 2.1, 2.2).
  duration,

  /// Which days do not count (mevzuat 1.9, 1.10, 2.5).
  dayCount,

  /// Eves and 28 October (mevzuat 4).
  halfDay,

  /// Splitting the leave (mevzuat 1.11, 2.7).
  split,

  /// What happens to unused leave (mevzuat 1.8, 2.4).
  unused,

  /// Travel days (mevzuat 1.12, 2.6).
  travel,

  /// Excuse leave (mevzuat 1.13, 2.8).
  excuse,

  /// Official holidays (mevzuat 3.1, 3.2).
  holidays;

  /// The source whose link the section offers for [law].
  GuideSource source(EmploymentType law) => switch (this) {
    halfDay || holidays => GuideSource.holidays,
    dayCount when law == EmploymentType.civilServant => GuideSource.personnel,
    _ => law == EmploymentType.laborLaw ? GuideSource.labor : GuideSource.civil,
  };
}
