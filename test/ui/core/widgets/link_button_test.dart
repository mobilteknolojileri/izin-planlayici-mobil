import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/ui/core/widgets/link_button.dart';
import 'package:material_ui/material_ui.dart';

import '../golden_harness.dart';

void main() {
  const url = 'https://www.mevzuat.gov.tr/';

  Future<List<String>> pump(WidgetTester tester, {required bool opens}) async {
    final opened = <String>[];
    await tester.pumpWidget(
      testApp(
        Scaffold(
          body: LinkButton(
            name: 'Mevzuat',
            url: url,
            open: (link) async {
              opened.add(link);
              return opens;
            },
          ),
        ),
      ),
    );
    return opened;
  }

  List<String> recordClipboard(WidgetTester tester) {
    final copied = <String>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied.add((call.arguments as Map)['text'] as String);
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    return copied;
  }

  testWidgets('opens the link and copies nothing', (tester) async {
    final copied = recordClipboard(tester);
    final opened = await pump(tester, opens: true);
    await tester.tap(find.byTooltip('Mevzuat bağlantısını aç'));
    await tester.pumpAndSettle();
    expect(opened, [url]);
    expect(copied, isEmpty);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('copies the link when no browser opens it', (tester) async {
    final copied = recordClipboard(tester);
    await pump(tester, opens: false);
    await tester.tap(find.byTooltip('Mevzuat bağlantısını aç'));
    await tester.pumpAndSettle();
    expect(copied, [url]);
    expect(
      find.text('Tarayıcı açılamadı. Bağlantı kopyalandı.'),
      findsOneWidget,
    );
  });

  testWidgets('is a labelled button of at least 48 dp', (tester) async {
    await pump(tester, opens: true);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  });
}
