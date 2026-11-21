import 'package:izin_planla/domain/models/models.dart';

/// Orders [a] before [b] when it is the better suggestion, for `List.sort`.
///
/// More days off per leave day first, then the longer break, then the
/// earlier start. A suggestion that costs no leave ranks above every paid
/// one. Ratios are compared by cross multiplication, so 6 days for 1 and
/// 9 days for 1.5 tie exactly and the longer break wins.
int compareBridgeSuggestions(BridgeSuggestion a, BridgeSuggestion b) {
  final aFree = a.leaveDaysUsed <= 0;
  final bFree = b.leaveDaysUsed <= 0;
  if (aFree != bFree) return aFree ? -1 : 1;
  if (!aFree) {
    final byEfficiency = (b.totalDaysOff * a.leaveDaysUsed).compareTo(
      a.totalDaysOff * b.leaveDaysUsed,
    );
    if (byEfficiency != 0) return byEfficiency;
  }
  final byLength = b.totalDaysOff.compareTo(a.totalDaysOff);
  if (byLength != 0) return byLength;
  final byStart = a.vacation.start.compareTo(b.vacation.start);
  if (byStart != 0) return byStart;
  final byCost = a.leaveDaysUsed.compareTo(b.leaveDaysUsed);
  if (byCost != 0) return byCost;
  return a.vacation.end.compareTo(b.vacation.end);
}
