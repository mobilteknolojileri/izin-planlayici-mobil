import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/ui/core/widgets/illustration.dart';
import 'package:izin_planla/ui/core/widgets/step_scaffold.dart';
import 'package:material_ui/material_ui.dart';

import '../golden_harness.dart';

void main() {
  Widget step({VoidCallback? onNext, VoidCallback? onBack}) => StepScaffold(
    step: 2,
    stepCount: 4,
    question: 'İşe ne zaman başladın?',
    reason: 'İzin hakkın bu tarihe göre hesaplanır.',
    nextLabel: 'Devam',
    onNext: onNext,
    onBack: onBack,
    illustration: Illustration.onboardingStartDate,
    child: const SizedBox(height: 56),
  );

  coreGoldenTest(
    'StepScaffold',
    fileName: 'step_scaffold',
    height: 760,
    builder: (_) => step(onNext: () {}, onBack: () {}),
  );

  testWidgets('shows progress, back and next', (tester) async {
    var next = 0;
    var back = 0;
    await tester.pumpWidget(
      testApp(step(onNext: () => next++, onBack: () => back++)),
    );
    expect(find.text('Adım 2/4'), findsOneWidget);
    expect(find.bySemanticsLabel('Adım 2, toplam 4 adım'), findsOneWidget);
    await tester.tap(find.text('Devam'));
    await tester.tap(find.byType(BackButton));
    expect((next, back), (1, 1));
  });
}
