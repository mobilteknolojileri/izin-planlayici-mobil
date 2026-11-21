import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:izin_planla/data/services/links/link_opener.dart';
import 'package:url_launcher/url_launcher.dart';

/// [LinkOpener] backed by `url_launcher`.
///
/// Links open in the browser app, never in an in-app web view, so the app
/// itself needs no internet permission.
class UrlLauncherLinkOpener implements LinkOpener {
  /// Creates the opener.
  const new();

  @override
  Future<bool> open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on PlatformException catch (error) {
      debugPrint('Link could not be opened: $error');
      return false;
    } on MissingPluginException catch (error) {
      debugPrint('Link could not be opened: $error');
      return false;
    }
  }
}
