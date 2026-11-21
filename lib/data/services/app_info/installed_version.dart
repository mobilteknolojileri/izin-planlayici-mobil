import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Reads the installed app version, such as `1.0.0+2`, from the platform.
///
/// Returns [fallback] when the platform cannot tell, for example in tests,
/// because the version is only shown and stored as backup provenance.
Future<String> readInstalledVersion({String fallback = '0.0.0'}) async {
  try {
    final info = await PackageInfo.fromPlatform();
    if (info.version.isEmpty) return fallback;
    return info.buildNumber.isEmpty
        ? info.version
        : '${info.version}+${info.buildNumber}';
  } on PlatformException catch (error) {
    debugPrint('App version could not be read: $error');
    return fallback;
  } on MissingPluginException catch (error) {
    debugPrint('App version could not be read: $error');
    return fallback;
  }
}
