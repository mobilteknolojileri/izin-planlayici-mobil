import 'dart:async';
import 'dart:io';

import 'package:alchemist/alchemist.dart';
import 'package:intl/date_symbol_data_local.dart';

/// Runs before every test file: Turkish date data and the golden setup.
///
/// CI goldens (`goldens/ci/`) draw text as blocks, CI compares them. They are
/// made on Windows, and Linux CI anti-aliases curves a few pixels differently,
/// so CI accepts up to 0.1% differing pixels. A developer machine compares
/// them exactly. Readable Windows goldens (`goldens/windows/`) use the real
/// Inter font and run only on a developer machine.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  await initializeDateFormatting('tr');
  final ci = Platform.environment.containsKey('CI');
  await AlchemistConfig.runWithConfig<Future<void>>(
    config: AlchemistConfig(
      ciGoldensConfig: CiGoldensConfig(diffThreshold: ci ? 0.001 : null),
      platformGoldensConfig: PlatformGoldensConfig(
        enabled: !ci,
        platforms: {HostPlatform.windows},
      ),
    ),
    run: () async {
      await testMain();
    },
  );
}
