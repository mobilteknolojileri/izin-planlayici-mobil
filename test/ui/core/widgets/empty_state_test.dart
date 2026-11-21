import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/ui/core/widgets/empty_state.dart';
import 'package:izin_planla/ui/core/widgets/illustration.dart';

import '../golden_harness.dart';

void main() {
  coreGoldenTest(
    'EmptyState',
    fileName: 'empty_state',
    height: 520,
    builder: (_) => EmptyState(
      illustration: Illustration.leavesEmpty,
      message: 'Henüz izin eklemedin.',
      actionLabel: 'İzin ekle',
      onAction: () {},
    ),
  );

  testWidgets('has one sentence and one button', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      testApp(
        EmptyState(
          illustration: Illustration.leavesEmpty,
          message: 'Henüz izin eklemedin.',
          actionLabel: 'İzin ekle',
          onAction: () => taps++,
        ),
      ),
    );
    expect(find.text('Henüz izin eklemedin.'), findsOneWidget);
    await tester.tap(find.text('İzin ekle'));
    expect(taps, 1);
  });
}
