import 'package:izin_planla/ui/core/widgets/app_illustration.dart';
import 'package:izin_planla/ui/core/widgets/illustration.dart';
import 'package:material_ui/material_ui.dart';

import '../golden_harness.dart';

void main() {
  coreGoldenTest(
    'AppIllustration',
    fileName: 'app_illustration',
    builder: (_) => Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final illustration in Illustration.values)
          AppIllustration(illustration, height: 100),
      ],
    ),
  );
}
