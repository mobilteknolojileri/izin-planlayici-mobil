import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

/// Taps on the home screen widget while the app is already running.
///
/// A cold start from the widget opens the home route anyway. Platforms
/// without the plugin (tests) report an error on the stream, which is
/// logged and turned into an empty stream.
Stream<void> homeWidgetClicks() =>
    HomeWidget.widgetClicked.map<void>((_) {}).handleError((Object error) {
      debugPrint('Home widget taps unavailable: $error');
    });
