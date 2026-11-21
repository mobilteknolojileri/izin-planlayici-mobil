import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/services/export/backup_envelope.dart';
import 'package:izin_planla/data/services/export/backup_envelope_codec.dart';
import 'package:izin_planla/data/services/export/export_failure.dart';
import 'package:izin_planla/data/services/export/export_failure_reason.dart';
import 'package:izin_planla/utils/result.dart';

import 'support/bytes.dart';
import 'support/hostile_fixture.dart';

void main() {
  final codec = BackupEnvelopeCodec(appVersion: '1.2.0+7', schemaVersion: 3);
  final exportedAt = DateTime.utc(2026, 11, 21, 9, 30, 15);
  final document = HostileFixture.backupDocument();

  Uint8List wrap([String? payload]) =>
      codec.wrap(payload ?? document, exportedAt: exportedAt);

  Map<String, dynamic> envelopeMap() =>
      jsonDecode(utf8.decode(wrap())) as Map<String, dynamic>;

  Uint8List encodeMap(Map<String, dynamic> map) => utf8.encode(jsonEncode(map));

  BackupEnvelope readOk(Uint8List bytes) => switch (codec.read(bytes)) {
    Ok(:final value) => value,
    Err(:final error) => fail('expected a valid backup, got $error'),
  };

  ExportFailureReason? reasonOf(Uint8List bytes) => switch (codec.read(bytes)) {
    Ok() => null,
    Err(:final error) => (error as ExportFailure).reason,
  };

  Uint8List changed(void Function(Map<String, dynamic> map) change) {
    final map = envelopeMap();
    change(map);
    return encodeMap(map);
  }

  group('sha256Hex', () {
    test('matches the FIPS 180-2 test vectors', () {
      expect(
        BackupEnvelopeCodec.sha256Hex(''),
        'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
      );
      expect(
        BackupEnvelopeCodec.sha256Hex('abc'),
        'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad',
      );
      expect(
        BackupEnvelopeCodec.sha256Hex(
          'abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq',
        ),
        '248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1',
      );
    });
  });

  group('wrap', () {
    test('writes the header first and the payload last', () {
      expect(envelopeMap().keys, [
        'format',
        'formatVersion',
        'schemaVersion',
        'appVersion',
        'exportedAtUtc',
        'payloadSha256',
        'payload',
      ]);
    });

    test('stores versions, UTC time and checksum of the payload', () {
      final map = envelopeMap();
      expect(map['format'], BackupEnvelopeCodec.formatMarker);
      expect(map['formatVersion'], BackupEnvelopeCodec.formatVersion);
      expect(map['schemaVersion'], 3);
      expect(map['appVersion'], '1.2.0+7');
      expect(map['exportedAtUtc'], '2026-11-21T09:30:15.000Z');
      expect(
        map['payloadSha256'],
        BackupEnvelopeCodec.sha256Hex(jsonEncode(jsonDecode(document))),
      );
      expect(map['payload'], jsonDecode(document));
    });

    test('converts a local time to UTC', () {
      final local = DateTime(2026, 6, 1, 12);
      final map = jsonDecode(
        utf8.decode(codec.wrap('{}', exportedAt: local)),
      ) as Map<String, dynamic>;
      expect(map['exportedAtUtc'], local.toUtc().toIso8601String());
      expect((map['exportedAtUtc'] as String).endsWith('Z'), isTrue);
    });

    test('a payload that is not JSON is an error', () {
      expect(() => wrap('{"a":'), throwsFormatException);
    });

    test('an app version that cannot be parsed is a programming error', () {
      expect(
        () => BackupEnvelopeCodec(appVersion: 'dev', schemaVersion: 1),
        throwsArgumentError,
      );
    });
  });

  group('read', () {
    test('returns the payload and the header', () {
      final envelope = readOk(wrap());
      expect(envelope.payloadJson, jsonEncode(jsonDecode(document)));
      expect(jsonDecode(envelope.payloadJson), jsonDecode(document));
      expect(envelope.formatVersion, 1);
      expect(envelope.schemaVersion, 3);
      expect(envelope.appVersion, '1.2.0+7');
      expect(envelope.exportedAtUtc, exportedAt);
    });

    test('wrap, read and wrap again gives the same bytes', () {
      final first = wrap();
      final second = wrap(readOk(first).payloadJson);
      expect(second, first);
    });

    test('keeps every hostile string and number', () {
      final payload =
          jsonDecode(readOk(wrap()).payloadJson) as Map<String, dynamic>;
      expect(payload['texts'], HostileFixture.texts);
      expect(payload['numbers'], [
        0,
        -1,
        1.5,
        -0.0,
        9007199254740991,
        1e300,
        0.1,
      ]);
      expect(payload.containsKey('nullValue'), isTrue);
      expect(payload['nullValue'], isNull);
      expect(payload['emptyText'], '');
    });

    test('accepts a reformatted file and a byte order mark', () {
      final pretty = const JsonEncoder.withIndent('    ')
          .convert(envelopeMap());
      expect(
        readOk(utf8.encode(pretty)).payloadJson,
        readOk(wrap()).payloadJson,
      );
      final withBom = Uint8List.fromList([0xEF, 0xBB, 0xBF, ...wrap()]);
      expect(readOk(withBom).payloadJson, readOk(wrap()).payloadJson);
    });

    test('accepts a newer app with the same format and schema', () {
      for (final version in ['1.2.1', '1.2.0+8', '2.0.0+1']) {
        final bytes = changed((map) => map['appVersion'] = version);
        final envelope = readOk(bytes);
        expect(envelope.appVersion, version);
        expect(envelope.payloadJson, jsonEncode(jsonDecode(document)));
      }
    });

    test('accepts files from an older app and schema', () {
      final older = changed((map) {
        map['schemaVersion'] = 1;
        map['appVersion'] = '1.0.0';
      });
      expect(readOk(older).schemaVersion, 1);
    });
  });

  group('read refuses', () {
    test('a file larger than any backup', () {
      expect(
        reasonOf(Uint8List(BackupEnvelopeCodec.maxBytes + 1)),
        ExportFailureReason.tooLarge,
      );
    });

    test('files that are not a backup', () {
      final inputs = <Uint8List>[
        Uint8List.fromList([0xFF, 0xFE, 0x00, 0x41]),
        utf8.encode(''),
        utf8.encode('Tür;Başlangıç\r\nYıllık izin;01.01.2026\r\n'),
        Uint8List.fromList([0x50, 0x4B, 0x03, 0x04, 0x14, 0x00]),
        utf8.encode('%PDF-1.5\n'),
        utf8.encode('[1, 2, 3]'),
        utf8.encode('"text"'),
        utf8.encode('{"profiles": []}'),
        utf8.encode('{"format": "other-app", "formatVersion": 1}'),
      ];
      for (final input in inputs) {
        expect(reasonOf(input), ExportFailureReason.notBackup);
      }
    });

    test('a truncated file', () {
      final bytes = wrap();
      for (final length in [1, bytes.length ~/ 2, bytes.length - 1]) {
        expect(
          reasonOf(Uint8List.sublistView(bytes, 0, length)),
          ExportFailureReason.notBackup,
          reason: 'length $length',
        );
      }
    });

    test('a newer format or schema', () {
      final newer = [
        changed((map) => map['formatVersion'] = 2),
        changed((map) => map['schemaVersion'] = 4),
        changed((map) {
          map['formatVersion'] = 2;
          map['schemaVersion'] = 4;
        }),
      ];
      for (final bytes in newer) {
        expect(reasonOf(bytes), ExportFailureReason.newerVersion);
      }
    });

    test('a newer file before checking its checksum', () {
      final bytes = changed((map) {
        map['schemaVersion'] = 9;
        map['payloadSha256'] = '0' * 64;
      });
      expect(reasonOf(bytes), ExportFailureReason.newerVersion);
    });

    test('a malformed header', () {
      final invalid = {
        'formatVersion text': changed((map) => map['formatVersion'] = '1'),
        'formatVersion 0': changed((map) => map['formatVersion'] = 0),
        'formatVersion missing': changed((map) => map.remove('formatVersion')),
        'schemaVersion double': changed((map) => map['schemaVersion'] = 1.5),
        'schemaVersion missing': changed((map) => map.remove('schemaVersion')),
        'appVersion text': changed((map) => map['appVersion'] = 'yeni'),
        'appVersion number': changed((map) => map['appVersion'] = 1),
        'exportedAtUtc local': changed(
          (map) => map['exportedAtUtc'] = '2026-11-21T09:30:15',
        ),
        'exportedAtUtc text': changed((map) => map['exportedAtUtc'] = 'dün'),
        'exportedAtUtc missing': changed((map) => map.remove('exportedAtUtc')),
        'checksum upper case': changed(
          (map) => map['payloadSha256'] = (map['payloadSha256'] as String)
              .toUpperCase(),
        ),
        'checksum short': changed((map) => map['payloadSha256'] = 'abc'),
        'checksum missing': changed((map) => map.remove('payloadSha256')),
        'payload null': changed((map) => map['payload'] = null),
        'payload missing': changed((map) => map.remove('payload')),
      };
      for (final MapEntry(key: name, value: bytes) in invalid.entries) {
        expect(
          reasonOf(bytes),
          ExportFailureReason.invalidBackup,
          reason: name,
        );
      }
    });

    test('a changed payload or checksum', () {
      final changedPayload = changed(
        (map) => (map['payload'] as Map<String, dynamic>)['emptyText'] = ' ',
      );
      final changedChecksum = changed((map) {
        final sum = map['payloadSha256'] as String;
        map['payloadSha256'] =
            '${sum[0] == 'a' ? 'b' : 'a'}${sum.substring(1)}';
      });
      expect(reasonOf(changedPayload), ExportFailureReason.checksumMismatch);
      expect(reasonOf(changedChecksum), ExportFailureReason.checksumMismatch);
    });

    test('a single flipped byte anywhere in the payload', () {
      final flipped = withChangedByte(wrap(), '"texts"', 'T');
      expect(reasonOf(flipped), ExportFailureReason.checksumMismatch);
    });
  });
}
