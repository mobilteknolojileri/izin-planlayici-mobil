import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/domain/entitlement/civil_servant_entitlement_calculator.dart';
import 'package:izin_planla/domain/entitlement/default_entitlement_calculator.dart';
import 'package:izin_planla/domain/entitlement/labor_law_entitlement_calculator.dart';
import 'package:izin_planla/domain/models/models.dart';

Profile _profile(EmploymentType type, {bool isTeacher = false}) => Profile(
  id: 'p1',
  name: 'Person',
  employmentType: type,
  employmentStartDate: DateTime.utc(2020, 3, 10),
  birthDate: DateTime.utc(1990, 6, 15),
  isTeacher: isTeacher,
);

void main() {
  const calculator = DefaultEntitlementCalculator();
  final until = DateTime.utc(2026, 11, 21);

  test('uses the 4857 rules for a worker', () {
    final worker = _profile(EmploymentType.laborLaw);

    expect(
      calculator.periods(worker, until: until),
      const LaborLawEntitlementCalculator().periods(worker, until: until),
    );
    expect(
      calculator.nextAccrual(worker, until),
      const LaborLawEntitlementCalculator().nextAccrual(worker, until),
    );
  });

  test('uses the 657 rules for a civil servant', () {
    final civilServant = _profile(EmploymentType.civilServant);

    expect(
      calculator.periods(civilServant, until: until),
      const CivilServantEntitlementCalculator().periods(
        civilServant,
        until: until,
      ),
    );
    expect(
      calculator.nextAccrual(civilServant, until),
      const CivilServantEntitlementCalculator().nextAccrual(
        civilServant,
        until,
      ),
    );
  });

  test('the same start date gives different rights under each law', () {
    final firstYear = DateTime.utc(2021, 3, 10);
    final worker = calculator
        .periods(_profile(EmploymentType.laborLaw), until: firstYear)
        .single;
    final civilServant = calculator
        .periods(_profile(EmploymentType.civilServant), until: firstYear)
        .single;

    expect(worker.days, 14);
    expect(worker.calendarYear, isNull);
    expect(civilServant.days, 20);
    expect(civilServant.calendarYear, 2021);
  });

  test('every period carries its rules', () {
    for (final type in EmploymentType.values) {
      for (final period in calculator.periods(_profile(type), until: until)) {
        expect(period.rules, isNotEmpty);
        expect(
          period.rules.every((rule) => rule.legalReference.isNotEmpty),
          isTrue,
        );
      }
    }
  });

  test('a teacher civil servant earns nothing', () {
    final teacher = _profile(EmploymentType.civilServant, isTeacher: true);

    expect(calculator.periods(teacher, until: until), isEmpty);
    expect(calculator.nextAccrual(teacher, until), isNull);
  });
}
