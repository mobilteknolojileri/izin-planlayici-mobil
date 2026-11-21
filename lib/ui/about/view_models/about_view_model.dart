import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_planla/config/dependencies.dart';
import 'package:izin_planla/ui/about/view_models/about_state.dart';

/// App version shown on the about screen, such as `1.0.0`: the installed
/// version without the build number.
final aboutVersionProvider = Provider<String>(
  (ref) => ref.watch(appVersionProvider).split('+').first,
);

/// State and actions of the about screen.
final aboutViewModelProvider = NotifierProvider<AboutViewModel, AboutState>(
  AboutViewModel.new,
);

/// View model of the about screen: version, sources and links.
class AboutViewModel extends Notifier<AboutState> {
  @override
  AboutState build() => AboutState(version: ref.watch(aboutVersionProvider));

  /// Opens [url] in the browser, returns whether it opened.
  Future<bool> openLink(String url) => ref.read(linkOpenerProvider).open(url);
}
