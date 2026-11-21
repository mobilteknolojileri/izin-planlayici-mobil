// Checks the Play store texts and the branding images against the Play and
// Android limits. Exits with 1 and lists every failure.
//
// Run from the repository root:
//
//   dart run store/tool/check_store.dart
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

final _failures = <String>[];

void main() {
  _checkListing();
  _checkWording();
  _checkImages();
  _checkSafeZones();
  if (_failures.isEmpty) {
    stdout.writeln('All store checks passed.');
    return;
  }
  stderr.writeln('${_failures.length} failure(s):');
  _failures.forEach(stderr.writeln);
  exitCode = 1;
}

void _check(bool ok, String message) {
  stdout.writeln('${ok ? 'ok  ' : 'FAIL'} $message');
  if (!ok) _failures.add(message);
}

// Texts.

void _checkListing() {
  final listing = File('store/listing-tr.md').readAsStringSync();
  final blocks = RegExp(
    r'^## (.+?)\n\n```text\n([\s\S]*?)\n```',
    multiLine: true,
  ).allMatches(listing);
  final texts = {for (final m in blocks) m.group(1)!: m.group(2)!};
  const limits = {
    'Uygulama adı (en fazla 30 karakter)': 30,
    'Kısa açıklama (en fazla 80 karakter)': 80,
    'Tam açıklama (en fazla 4000 karakter)': 4000,
  };
  limits.forEach((heading, limit) {
    final text = texts[heading];
    if (text == null) {
      _check(false, 'listing block "$heading" exists');
      return;
    }
    final length = text.runes.length;
    _check(length <= limit, '$heading: $length characters');
  });

  final full = _lowerTr(texts.values.join('\n'));
  const keywords = [
    'yıllık izin hesaplama',
    'izin takip',
    'köprü',
    'resmî tatiller 2027',
  ];
  for (final keyword in keywords) {
    _check(full.contains(keyword), 'keyword "$keyword" in listing');
  }
}

/// Lower case with the Turkish dotted and dotless i.
String _lowerTr(String text) =>
    text.replaceAll('İ', 'i').replaceAll('I', 'ı').toLowerCase();

void _checkWording() {
  final files = Directory('store')
      .listSync()
      .whereType<File>()
      .where((file) => file.path.endsWith('.md'));
  final rules = {
    'em dash': RegExp('—'),
    'semicolon': RegExp(';'),
    '"yalnızca" (use "sadece")': RegExp('yalnızca', caseSensitive: false),
    '"resmi" (use "resmî")': RegExp(r'\b[Rr]esmi(?![î])'),
    '"dini" (use "dinî")': RegExp(r'\b[Dd]ini\b'),
    '"dahil" (use "dâhil")': RegExp('dahil', caseSensitive: false),
    'personal user path': RegExp(r'[A-Za-z]:[\\/]+Users[\\/]|/c/Users/'),
    'e-mail address': RegExp(r'[\w.+-]+@[\w-]+\.[\w.]+'),
  };
  for (final file in files) {
    final name = file.uri.pathSegments.last;
    final text = file.readAsStringSync();
    rules.forEach((rule, pattern) {
      final hits = pattern.allMatches(text).length;
      _check(hits == 0, '$name: no $rule ($hits found)');
    });
  }
}

// Images.

void _checkImages() {
  // Path, width, height, colour type (6 RGBA, 2 RGB).
  final expected = <(String, int, int, int)>[
    ('store/images/icon-512.png', 512, 512, 6),
    ('store/images/feature-graphic.png', 1024, 500, 2),
    ('assets/branding/png/foreground.png', 1024, 1024, 6),
    ('assets/branding/png/background.png', 1024, 1024, 6),
    ('assets/branding/png/monochrome.png', 1024, 1024, 6),
    ('assets/branding/png/icon_legacy.png', 1024, 1024, 6),
    ('assets/branding/png/splash.png', 640, 640, 6),
    ('assets/branding/png/splash_android12.png', 960, 960, 6),
  ];
  const res = 'android/app/src/main/res';
  const densities = {
    'mdpi': 1.0,
    'hdpi': 1.5,
    'xhdpi': 2.0,
    'xxhdpi': 3.0,
    'xxxhdpi': 4.0,
  };
  densities.forEach((density, scale) {
    int px(int dp) => (dp * scale).round();
    expected.addAll([
      ('$res/mipmap-$density/ic_launcher.png', px(48), px(48), -1),
      for (final layer in ['foreground', 'background', 'monochrome'])
        ('$res/drawable-$density/ic_launcher_$layer.png', px(108), px(108), -1),
      ('$res/drawable-$density/splash.png', px(160), px(160), -1),
      ('$res/drawable-$density/android12splash.png', px(240), px(240), -1),
      (
        '$res/drawable-night-$density/android12splash.png',
        px(240),
        px(240),
        -1,
      ),
    ]);
  });

  for (final (path, width, height, colourType) in expected) {
    final file = File(path);
    if (!file.existsSync()) {
      _check(false, '$path exists');
      continue;
    }
    final header = _readHeader(file.readAsBytesSync());
    final typeOk = colourType == -1 || header.colourType == colourType;
    _check(
      header.width == width && header.height == height && typeOk,
      '$path: ${header.width}x${header.height}, '
      '${header.bitDepth} bit, colour type ${header.colourType}',
    );
  }

  final icon = File('store/images/icon-512.png').lengthSync();
  _check(icon < 1024 * 1024, 'icon-512.png under 1 MB ($icon bytes)');
  final feature = File('store/images/feature-graphic.png').lengthSync();
  _check(feature < 15 * 1024 * 1024, 'feature graphic under 15 MB');
}

/// Checks that no painted pixel leaves the circle a launcher or the
/// Android 12 splash screen may keep.
void _checkSafeZones() {
  // 66 dp of the 108 dp layer.
  const layerSafe = 1024 * 33 / 108;
  _safeZone('assets/branding/png/foreground.png', layerSafe);
  _safeZone('assets/branding/png/monochrome.png', layerSafe);
  // 160 dp circle of the 240 dp splash icon.
  _safeZone('assets/branding/png/splash_android12.png', 960 * 80 / 240);
}

void _safeZone(String path, double radius) {
  final image = _decodeRgba(File(path).readAsBytesSync());
  final cx = image.width / 2;
  final cy = image.height / 2;
  var farthest = 0.0;
  for (var y = 0; y < image.height; y++) {
    for (var x = 0; x < image.width; x++) {
      if (image.pixels[(y * image.width + x) * 4 + 3] == 0) continue;
      final dx = x + 0.5 - cx;
      final dy = y + 0.5 - cy;
      farthest = max(farthest, sqrt(dx * dx + dy * dy));
    }
  }
  _check(
    farthest <= radius,
    '$path: farthest painted pixel ${farthest.toStringAsFixed(1)} px '
    'from the centre, limit ${radius.toStringAsFixed(1)}',
  );
}

// PNG reading.

typedef _Header = ({int width, int height, int bitDepth, int colourType});

_Header _readHeader(Uint8List png) {
  const signature = [137, 80, 78, 71, 13, 10, 26, 10];
  for (var i = 0; i < signature.length; i++) {
    if (png[i] != signature[i]) throw const FormatException('not a PNG');
  }
  final data = ByteData.sublistView(png);
  // The IHDR chunk always comes first: length, type, then its fields.
  return (
    width: data.getUint32(16),
    height: data.getUint32(20),
    bitDepth: png[24],
    colourType: png[25],
  );
}

/// Decodes an 8 bit, non-interlaced RGBA PNG.
({int width, int height, Uint8List pixels}) _decodeRgba(Uint8List png) {
  final header = _readHeader(png);
  if (header.bitDepth != 8 || header.colourType != 6) {
    throw FormatException('expected 8 bit RGBA', header.toString());
  }
  final data = ByteData.sublistView(png);
  final compressed = BytesBuilder(copy: false);
  var offset = 8;
  while (offset < png.length) {
    final length = data.getUint32(offset);
    final type = String.fromCharCodes(png, offset + 4, offset + 8);
    if (type == 'IDAT') {
      compressed.add(
        Uint8List.sublistView(png, offset + 8, offset + 8 + length),
      );
    }
    offset += 12 + length;
  }
  final raw = zlib.decode(compressed.takeBytes());
  const bpp = 4;
  final stride = header.width * bpp;
  final pixels = Uint8List(header.height * stride);
  for (var y = 0; y < header.height; y++) {
    final filter = raw[y * (stride + 1)];
    final row = y * (stride + 1) + 1;
    for (var i = 0; i < stride; i++) {
      final a = i >= bpp ? pixels[y * stride + i - bpp] : 0;
      final b = y > 0 ? pixels[(y - 1) * stride + i] : 0;
      final c = i >= bpp && y > 0 ? pixels[(y - 1) * stride + i - bpp] : 0;
      final predictor = switch (filter) {
        0 => 0,
        1 => a,
        2 => b,
        3 => (a + b) >> 1,
        4 => _paeth(a, b, c),
        _ => throw FormatException('unknown PNG filter $filter'),
      };
      pixels[y * stride + i] = (raw[row + i] + predictor) & 0xFF;
    }
  }
  return (width: header.width, height: header.height, pixels: pixels);
}

int _paeth(int a, int b, int c) {
  final p = a + b - c;
  final pa = (p - a).abs();
  final pb = (p - b).abs();
  final pc = (p - c).abs();
  if (pa <= pb && pa <= pc) return a;
  if (pb <= pc) return b;
  return c;
}
