import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/ui/core/widgets/large_title_page.dart';
import 'package:material_ui/material_ui.dart';

import '../golden_harness.dart';

void main() {
  testWidgets('the title is a heading and the content follows it', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      testApp(
        const LargeTitlePage(
          overline: '20 Kasım 2026, Cuma',
          title: 'İzin durumun',
          children: [Text('İçerik')],
        ),
      ),
    );
    expect(
      tester.getSemantics(find.text('İzin durumun')),
      isSemantics(label: 'İzin durumun', isHeader: true),
    );
    expect(
      tester.getRect(find.text('İçerik')).top,
      greaterThan(tester.getRect(find.text('İzin durumun')).bottom),
    );
    semantics.dispose();
  });

  testWidgets('the list ends above the bottom padding', (tester) async {
    await tester.pumpWidget(
      testApp(
        MediaQuery(
          data: const MediaQueryData(
            size: Size(360, 640),
            padding: EdgeInsets.only(bottom: 100),
          ),
          child: LargeTitlePage(
            title: 'Başlık',
            children: [
              for (var i = 0; i < 30; i++)
                SizedBox(height: 40, child: Text('$i')),
            ],
          ),
        ),
      ),
    );
    final position = tester
        .state<ScrollableState>(find.byType(Scrollable))
        .position;
    do {
      position.jumpTo(position.maxScrollExtent);
      await tester.pumpAndSettle();
    } while (position.pixels < position.maxScrollExtent);
    final view = tester.view.physicalSize / tester.view.devicePixelRatio;
    expect(
      tester.getRect(find.text('29')).bottom,
      lessThanOrEqualTo(view.height - 100),
    );
  });
}
