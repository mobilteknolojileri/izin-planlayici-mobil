// Renders every branding PNG from the SVG sources in assets/branding/src.
//
// Run from the repository root, then run build_android.sh next to this file
// to turn the PNGs into launcher icons and splash screens:
//
//   flutter test assets/branding/tool/render_branding_test.dart
//
// It lives outside test/ so CI does not run it. It is a test only because
// `flutter test` is the one place with a real dart:ui renderer and no device.
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

const _sources = 'assets/branding/src';
const _toolInputs = 'assets/branding/png';
const _storeImages = 'store/images';

/// Side of an adaptive icon layer canvas, 108 dp.
const _layer = 1024.0;

/// Side of the part of the layer a launcher mask shows, 72 of 108 dp.
const double _visible = _layer * 72 / 108;

/// Android 12 splash icon canvas, 240 dp at xxxhdpi. The system shows the
/// middle 160 dp circle.
const _splashCanvas = 960.0;

/// Royal blue, `AppPalette.blue37`, the solid splash circle.
const _brand = ui.Color(0xFF2447D6);

const _white = ui.Color(0xFFFFFFFF);

void main() {
  testWidgets('renders the branding images', (tester) async {
    await tester.runAsync(() async {
      await _loadInter();
      final glyph = await _svg('glyph.svg');
      final background = await _svg('background.svg');
      final feature = await _svg('feature_graphic.svg');

      Directory(_toolInputs).createSync(recursive: true);
      Directory(_storeImages).createSync(recursive: true);

      // Adaptive icon layers for flutter_launcher_icons.
      await _save('$_toolInputs/foreground.png', 1024, 1024, (canvas) {
        canvas.drawPicture(glyph);
      });
      await _save('$_toolInputs/background.png', 1024, 1024, (canvas) {
        canvas.drawPicture(background);
      });
      await _save('$_toolInputs/monochrome.png', 1024, 1024, (canvas) {
        final tint = ui.Paint()
          ..colorFilter = const ui.ColorFilter.mode(_white, ui.BlendMode.srcIn);
        canvas
          ..saveLayer(const ui.Rect.fromLTWH(0, 0, _layer, _layer), tint)
          ..drawPicture(glyph)
          ..restore();
      });

      // Legacy icon for Android 7 (API 24 and 25), a rounded square.
      await _save('$_toolInputs/icon_legacy.png', 1024, 1024, (canvas) {
        const tile = ui.Rect.fromLTWH(64, 64, 896, 896);
        canvas.clipRRect(
          ui.RRect.fromRectAndRadius(tile, const ui.Radius.circular(200)),
        );
        _drawScaled(canvas, background, side: 1024, scale: 896 / _visible);
        _drawScaled(canvas, glyph, side: 1024, scale: 896 / _visible);
      });

      // Splash icon for Android 12 and later, shown on the brand circle.
      await _save('$_toolInputs/splash_android12.png', 960, 960, (canvas) {
        _drawScaled(canvas, glyph, side: 960, scale: _splashCanvas / _layer);
      });

      // Splash image before Android 12: the same circle, drawn in.
      await _save('$_toolInputs/splash.png', 640, 640, (canvas) {
        canvas
          ..drawCircle(
            const ui.Offset(320, 320),
            320,
            ui.Paint()..color = _brand,
          )
          ..clipRect(const ui.Rect.fromLTWH(0, 0, 640, 640));
        _drawScaled(canvas, glyph, side: 640, scale: _splashCanvas / _layer);
      });

      // Google Play: 512 icon with alpha, feature graphic without alpha.
      await _save('$_storeImages/icon-512.png', 512, 512, (canvas) {
        _drawScaled(canvas, background, side: 512, scale: 512 / _visible);
        _drawScaled(canvas, glyph, side: 512, scale: 512 / _visible);
      });
      await _save(
        '$_storeImages/feature-graphic.png',
        1024,
        500,
        (canvas) => canvas.drawPicture(feature),
        alpha: false,
      );
    });
  });
}

Future<void> _loadInter() async {
  final bytes = File('assets/fonts/Inter.ttf').readAsBytesSync();
  final loader = FontLoader('Inter')
    ..addFont(Future.value(ByteData.sublistView(bytes)));
  await loader.load();
}

Future<ui.Picture> _svg(String name) async {
  final svg = File('$_sources/$name').readAsStringSync();
  final info = await vg.loadPicture(SvgStringLoader(svg), null);
  return info.picture;
}

/// Draws a [_layer] sized [picture] scaled by [scale] around the centre of a
/// [side] sized canvas.
void _drawScaled(
  ui.Canvas canvas,
  ui.Picture picture, {
  required double side,
  required double scale,
}) {
  canvas
    ..save()
    ..translate(side / 2, side / 2)
    ..scale(scale)
    ..translate(-_layer / 2, -_layer / 2)
    ..drawPicture(picture)
    ..restore();
}

Future<void> _save(
  String path,
  int width,
  int height,
  void Function(ui.Canvas canvas) paint, {
  bool alpha = true,
}) async {
  final recorder = ui.PictureRecorder();
  paint(
    ui.Canvas(
      recorder,
      ui.Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
    ),
  );
  final image = await recorder.endRecording().toImage(width, height);
  final pixels = await image.toByteData(
    format: ui.ImageByteFormat.rawStraightRgba,
  );
  File(path).writeAsBytesSync(
    _encodePng(pixels!.buffer.asUint8List(), width, height, alpha: alpha),
  );
}

/// Encodes RGBA pixels as an 8 bit PNG, RGBA or RGB without alpha.
///
/// dart:ui only writes RGBA PNGs, and Play wants the feature graphic
/// without an alpha channel.
Uint8List _encodePng(
  Uint8List rgba,
  int width,
  int height, {
  required bool alpha,
}) {
  final channels = alpha ? 4 : 3;
  final stride = width * channels;
  final rows = Uint8List(height * (stride + 1));
  var out = 0;
  for (var y = 0; y < height; y++) {
    // Filter type 1 (Sub): each byte minus the same byte of the left pixel.
    rows[out++] = 1;
    for (var x = 0; x < width; x++) {
      final source = (y * width + x) * 4;
      for (var c = 0; c < channels; c++) {
        final left = x == 0 ? 0 : rgba[source - 4 + c];
        rows[out++] = (rgba[source + c] - left) & 0xFF;
      }
    }
  }
  final header = ByteData(13)
    ..setUint32(0, width)
    ..setUint32(4, height)
    ..setUint8(8, 8)
    ..setUint8(9, alpha ? 6 : 2);
  final png = BytesBuilder()..add(const [137, 80, 78, 71, 13, 10, 26, 10]);
  _chunk(png, 'IHDR', header.buffer.asUint8List());
  _chunk(png, 'IDAT', ZLibEncoder(level: 9).convert(rows));
  _chunk(png, 'IEND', const []);
  return png.takeBytes();
}

void _chunk(BytesBuilder png, String type, List<int> data) {
  final typeAndData = [...type.codeUnits, ...data];
  png
    ..add((ByteData(4)..setUint32(0, data.length)).buffer.asUint8List())
    ..add(typeAndData)
    ..add(
      (ByteData(4)..setUint32(0, _crc32(typeAndData))).buffer.asUint8List(),
    );
}

final _crcTable = List<int>.generate(256, (n) {
  var c = n;
  for (var k = 0; k < 8; k++) {
    c = (c & 1) == 1 ? 0xEDB88320 ^ (c >> 1) : c >> 1;
  }
  return c;
});

int _crc32(List<int> bytes) {
  var c = 0xFFFFFFFF;
  for (final byte in bytes) {
    c = _crcTable[(c ^ byte) & 0xFF] ^ (c >> 8);
  }
  return c ^ 0xFFFFFFFF;
}
