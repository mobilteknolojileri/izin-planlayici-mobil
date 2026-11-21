import 'dart:convert';

import 'package:izin_planla/domain/models/models.dart';

/// Input built to break exporters: Turkish letters, quotes, delimiters,
/// line breaks, formula starts, control characters, emoji, right to left
/// text, empty and very long values.
abstract final class HostileFixture {
  /// Report date used by the tests, a Saturday.
  static final date = DateTime.utc(2026, 11, 21);

  /// Id of [profile].
  static const profileId = 'kişi-ğüşiöç-1';

  /// A value longer than Excel's 32767 character cell limit.
  static final String long = 'Çok uzun not ğüşiöç ' * 2000;

  /// Strings that need escaping somewhere.
  static final texts = <String>[
    'Ayşe Gül Çığ-Öztürk İĞÜŞÖÇ ığüşöç',
    "=cmd|'/C calc'!A0",
    '+1+1',
    '-2+3',
    '@SUM(A1:A2)',
    '\tSekmeyle başlayan',
    '\rCR ile başlayan',
    'a;b,c"d\ne\r\nf',
    '"Tırnaklı" metin',
    '',
    '   ',
    '🌴 Tatil 👨‍👩‍👧',
    'שלום ‏ مرحبا',
    'Kontrol \u0000\u0007\u001F karakterleri',
    '_x0041_ ve <b>&amp;</b>',
    long,
  ];

  /// A worker with every optional profile field set.
  static Profile profile() => Profile(
    id: profileId,
    name: 'Ayşe "Gül" Çığ-Öztürk; =HYPERLINK("x")\nİkinci satır',
    employmentType: EmploymentType.laborLaw,
    employmentStartDate: DateTime.utc(2019, 3, 31),
    birthDate: DateTime.utc(1990, 6, 15),
    priorService: const ServiceDuration(years: 1, months: 1, days: 3),
    isUnderground: true,
    contractExtraDays: 2,
    leaveUsedBeforeTracking: 3.5,
    absencePeriods: [
      DateRange(start: DateTime.utc(2021, 2), end: DateTime.utc(2021, 2, 10)),
    ],
  );

  /// One record per entry of [texts], used and planned, every unit.
  static List<LeaveRecord> leaves() => [
    for (var i = 0; i < texts.length; i++)
      LeaveRecord(
        id: 'izin-$i',
        profileId: profileId,
        type: LeaveType.values[i % LeaveType.values.length],
        range: DateRange(
          start: DateTime.utc(2026, 1 + i % 12, 5 + i),
          end: DateTime.utc(2026, 1 + i % 12, 9 + i),
        ),
        unit: LeaveUnit.values[i % LeaveUnit.values.length],
        hours: i % 3 == 2 ? 2.5 : null,
        customTypeName: i % LeaveType.values.length == LeaveType.other.index
            ? texts[i]
            : null,
        note: texts[i],
      ),
  ];

  /// A backup document with the same hostile values plus number edge cases.
  static String backupDocument() => jsonEncode({
    'schemaVersion': 1,
    'profiles': [profile().toJson()],
    'leaves': [for (final leave in leaves()) leave.toJson()],
    'texts': texts,
    'numbers': [0, -1, 1.5, -0.0, 9007199254740991, 1e300, 0.1],
    'nullValue': null,
    'emptyText': '',
    'emptyList': <Object>[],
    'emptyMap': <String, Object>{},
    'nested': {
      'deep': [
        [
          [
            {'ğ': 'ş'},
          ],
        ],
      ],
    },
  });
}
