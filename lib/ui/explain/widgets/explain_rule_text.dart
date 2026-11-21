import 'package:izin_planla/domain/entitlement/entitlement_rule.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/core/app_format.dart';

/// The plain sentence of an [AppliedRule] on the explain screen.
abstract final class ExplainRuleText {
  /// The sentence of [rule], built from its params. Dates in params
  /// (`yyyy-MM-dd`) are written as "14 Nisan 2027, Çarşamba". An unknown
  /// code falls back to its legal reference.
  static String of(AppLocalizations l10n, AppliedRule rule, String locale) {
    String param(String name) => rule.params[name] ?? '';
    String date(String name) {
      final parsed = DateTime.tryParse(param(name));
      if (parsed == null) return param(name);
      return AppFormat.longDate(
        DateTime.utc(parsed.year, parsed.month, parsed.day),
        locale,
      );
    }

    return switch (EntitlementRule.fromCode(rule.code)) {
      null => l10n.explainRuleApplied(rule.legalReference),
      EntitlementRule.laborAnniversary => l10n.explainRuleLaborAnniversary(
        param('serviceYears'),
      ),
      EntitlementRule.laborPriorService => l10n.explainRuleLaborPriorService(
        param('years'),
        param('months'),
        param('days'),
        date('serviceStart'),
      ),
      EntitlementRule.laborAbsenceShift => l10n.explainRuleLaborAbsenceShift(
        param('shiftDays'),
      ),
      EntitlementRule.laborContinuousService =>
        l10n.explainRuleLaborContinuousService,
      EntitlementRule.laborSeniorityUpToFive =>
        l10n.explainRuleLaborSeniorityUpToFive(
          param('serviceYears'),
          param('days'),
        ),
      EntitlementRule.laborSeniorityFiveToFifteen =>
        l10n.explainRuleLaborSeniorityFiveToFifteen(
          param('serviceYears'),
          param('days'),
        ),
      EntitlementRule.laborSeniorityFifteenOrMore =>
        l10n.explainRuleLaborSeniorityFifteenOrMore(
          param('serviceYears'),
          param('days'),
        ),
      EntitlementRule.laborAgeEighteenOrYounger =>
        l10n.explainRuleLaborAgeEighteenOrYounger(param('age'), param('days')),
      EntitlementRule.laborAgeFiftyOrOlder =>
        l10n.explainRuleLaborAgeFiftyOrOlder(param('age'), param('days')),
      EntitlementRule.laborUnderground => l10n.explainRuleLaborUnderground(
        param('extraDays'),
      ),
      EntitlementRule.laborContractExtra => l10n.explainRuleLaborContractExtra(
        param('extraDays'),
      ),
      EntitlementRule.laborNoExpiry => l10n.explainRuleLaborNoExpiry,
      EntitlementRule.civilFirstRight => l10n.explainRuleCivilFirstRight(
        date('firstRightDate'),
        param('calendarYear'),
      ),
      EntitlementRule.civilFirstRightOnDutyStart =>
        l10n.explainRuleCivilFirstRightOnDutyStart(
          date('firstRightDate'),
          param('calendarYear'),
        ),
      EntitlementRule.civilCalendarYear => l10n.explainRuleCivilCalendarYear(
        param('calendarYear'),
      ),
      EntitlementRule.civilPriorService => l10n.explainRuleCivilPriorService(
        param('years'),
        param('months'),
        param('days'),
        date('serviceStart'),
      ),
      EntitlementRule.civilUpToTenYears => l10n.explainRuleCivilUpToTenYears(
        param('serviceYears'),
        param('days'),
      ),
      EntitlementRule.civilOverTenYears => l10n.explainRuleCivilOverTenYears(
        param('serviceYears'),
        param('days'),
      ),
      EntitlementRule.civilTenYearTransition =>
        l10n.explainRuleCivilTenYearTransition(
          date('transitionDate'),
          param('calendarYear'),
          param('days'),
        ),
      EntitlementRule.civilCarryOver => l10n.explainRuleCivilCarryOver(
        param('calendarYear'),
        date('expiresOn'),
      ),
    };
  }
}
