import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/ui/core/widgets/undo_snack_bar.dart';
import 'package:material_ui/material_ui.dart';

import '../golden_harness.dart';

const _showKey = ValueKey<String>('show');

void main() {
  Widget host() => SizedBox(
    height: 200,
    child: ScaffoldMessenger(
      child: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            key: _showKey,
            onPressed: () => UndoSnackBar.show(
              context,
              message: 'İzin silindi.',
              onUndo: () {},
            ),
            child: const Text('Sil'),
          ),
        ),
      ),
    ),
  );

  coreGoldenTest(
    'UndoSnackBar',
    fileName: 'undo_snack_bar',
    builder: (_) => host(),
    whilePerforming: (tester) async {
      final buttons = find.byKey(_showKey);
      for (var i = 0; i < buttons.evaluate().length; i++) {
        await tester.tap(buttons.at(i));
      }
      await tester.pumpAndSettle();
      // Let the snack bars time out after the golden, so no timer is left.
      return () async {
        await tester.pump(UndoSnackBar.duration);
        await tester.pumpAndSettle();
      };
    },
  );

  testWidgets('undo calls back', (tester) async {
    var undone = 0;
    await tester.pumpWidget(
      testApp(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => UndoSnackBar.show(
              context,
              message: 'İzin silindi.',
              onUndo: () => undone++,
            ),
            child: const Text('Sil'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Sil'));
    await tester.pumpAndSettle();
    expect(find.text('İzin silindi.'), findsOneWidget);
    await tester.tap(find.text('Geri al'));
    await tester.pumpAndSettle();
    expect(undone, 1);
  });
}
