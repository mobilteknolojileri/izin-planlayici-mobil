import 'package:izin_planla/domain/entitlement/calendar_arithmetic.dart';
import 'package:izin_planla/domain/models/models.dart';

/// Absence days that push accrual dates later (4857 art. 54/2).
///
/// `docs/mevzuat.md` section 1.2: every entered absence moves the accrual
/// dates after it by its number of days. Overlapping periods count each day
/// once, and days before [AbsenceCalendar.new]'s `from` are ignored because
/// no service had started yet.
final class AbsenceCalendar {
  /// Creates a calendar from [periods], ignoring days before [from].
  factory(List<DateRange> periods, {required DateTime from}) {
    final start = from.dateOnly;
    final clipped = <_Span>[
      for (final period in periods)
        if (!period.end.dateOnly.isBefore(start))
          (
            start: period.start.dateOnly.isBefore(start)
                ? start
                : period.start.dateOnly,
            end: period.end.dateOnly,
          ),
    ]..sort((a, b) => a.start.compareTo(b.start));

    final merged = <_Span>[];
    for (final span in clipped) {
      final last = merged.isEmpty ? null : merged.last;
      if (last != null && !span.start.isAfter(last.end.plusDays(1))) {
        if (span.end.isAfter(last.end)) {
          merged[merged.length - 1] = (start: last.start, end: span.end);
        }
      } else {
        merged.add(span);
      }
    }
    return AbsenceCalendar._(List.unmodifiable(merged));
  }

  const new _(this._spans);

  /// Sorted, non-overlapping and non-adjacent absence spans.
  final List<_Span> _spans;

  /// Whether no absence day is counted.
  bool get isEmpty => _spans.isEmpty;

  /// Number of distinct absence days strictly before [day].
  int daysBefore(DateTime day) {
    final limit = day.dateOnly;
    var total = 0;
    for (final span in _spans) {
      if (!span.start.isBefore(limit)) break;
      final lastCounted = span.end.isBefore(limit)
          ? span.end
          : limit.plusDays(-1);
      total += lastCounted.difference(span.start).inDays + 1;
    }
    return total;
  }

  /// The accrual date that [anniversary] moves to because of absences.
  ///
  /// Returns the first day `d` with `d == anniversary + daysBefore(d)`, so an
  /// absence that the shift itself reaches also counts. An absence starting
  /// on the result day does not move it, because the year was already
  /// complete.
  DateTime shift(DateTime anniversary) {
    final base = anniversary.dateOnly;
    var date = base;
    while (true) {
      final next = base.plusDays(daysBefore(date));
      if (next == date) return date;
      date = next;
    }
  }
}

/// An inclusive span of absence days.
typedef _Span = ({DateTime start, DateTime end});
