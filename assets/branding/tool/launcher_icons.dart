// Runs flutter_launcher_icons with a scratch directory as the project root.
//
// The tool rewrites the android:icon line of AndroidManifest.xml on every
// run. build_android.sh hands it a scratch copy of the files it reads and
// copies back only the generated res files.
//
//   dart run assets/branding/tool/launcher_icons.dart <scratch directory>
import 'dart:io';

import 'package:flutter_launcher_icons/main.dart' as launcher_icons;

Future<void> main(List<String> args) async {
  Directory.current = args.single;
  await launcher_icons.createIconsFromArguments([
    '--file',
    'assets/branding/launcher_icons.yaml',
  ]);
}
