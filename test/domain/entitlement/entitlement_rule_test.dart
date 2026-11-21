import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/domain/entitlement/entitlement_rule.dart';
import 'package:izin_planla/domain/models/models.dart';

void main() {
  test('codes are unique and map back to the rule', () {
    final codes = EntitlementRule.values.map((rule) => rule.code).toSet();

    expect(codes, hasLength(EntitlementRule.values.length));
    for (final rule in EntitlementRule.values) {
      expect(EntitlementRule.fromCode(rule.code), rule);
    }
  });

  test('an unknown code maps to null', () {
    expect(EntitlementRule.fromCode('unknown'), isNull);
  });

  test('4857 rules cite 4857 and 657 rules cite 657', () {
    for (final rule in EntitlementRule.values) {
      final law = rule.name.startsWith('labor') ? '4857 md. ' : '657 md. ';
      expect(rule.legalReference, startsWith(law), reason: rule.name);
    }
  });

  test('apply builds the applied rule with its params', () {
    expect(
      EntitlementRule.laborSeniorityUpToFive.apply({'days': '14'}),
      const AppliedRule(
        code: 'laborSeniorityUpToFive',
        legalReference: '4857 md. 53/4',
        params: {'days': '14'},
      ),
    );
    expect(EntitlementRule.laborNoExpiry.apply().params, isEmpty);
  });
}
