import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/services/export/leave_csv_encoder.dart';
import 'package:izin_planla/domain/models/models.dart';

import 'support/csv_reader.dart';
import 'support/hostile_fixture.dart';
import 'support/report_factory.dart';

void main() {
  final encoder = LeaveCsvEncoder(reportText);

  List<List<String>> parse(List<int> bytes) {
    expect(bytes.sublist(0, 3), [0xEF, 0xBB, 0xBF]);
    return readCsv(utf8.decode(bytes.sublist(3)));
  }

  test('writes Turkish headers and one row per leave', () async {
    final report = await buildReport(
      profile: HostileFixture.profile(),
      leaves: [
        LeaveRecord(
          id: '1',
          profileId: HostileFixture.profileId,
          type: LeaveType.annual,
          range: DateRange(
            start: DateTime.utc(2026, 3, 6),
            end: DateTime.utc(2026, 3, 10),
          ),
          note: 'Şubat tatili, ağabeyimle',
        ),
        LeaveRecord(
          id: '2',
          profileId: HostileFixture.profileId,
          type: LeaveType.annual,
          range: DateRange(
            start: DateTime.utc(2026, 12, 31),
            end: DateTime.utc(2026, 12, 31),
          ),
          unit: LeaveUnit.halfDay,
        ),
        LeaveRecord(
          id: '3',
          profileId: HostileFixture.profileId,
          type: LeaveType.other,
          customTypeName: 'Gönüllü itfaiye',
          range: DateRange(
            start: DateTime.utc(2026, 4),
            end: DateTime.utc(2026, 4),
          ),
          unit: LeaveUnit.hours,
          hours: 2.5,
        ),
      ],
    );

    final rows = parse(encoder.encode(report));

    expect(rows, [
      [
        'Tür',
        'Başlangıç',
        'Bitiş',
        'Süre',
        'Yıllık izinden düşen gün',
        'Durum',
        'Not',
      ],
      [
        'Yıllık izin',
        '06.03.2026',
        '10.03.2026',
        '5 takvim günü',
        '3',
        'Kullanıldı',
        'Şubat tatili, ağabeyimle',
      ],
      [
        'Gönüllü itfaiye',
        '01.04.2026',
        '01.04.2026',
        '2,5 saat',
        '0',
        'Kullanıldı',
        '',
      ],
      [
        'Yıllık izin',
        '31.12.2026',
        '31.12.2026',
        'Yarım gün',
        '0,5',
        'Planlandı',
        '',
      ],
    ]);
  });

  test('every leave type has a Turkish name', () async {
    final report = await buildReport(
      profile: HostileFixture.profile(),
      leaves: [
        for (final type in LeaveType.values)
          LeaveRecord(
            id: type.name,
            profileId: HostileFixture.profileId,
            type: type,
            range: DateRange(
              start: DateTime.utc(2026),
              end: DateTime.utc(2026),
            ),
          ),
      ],
    );
    final names = parse(encoder.encode(report)).skip(1).map((row) => row[0]);
    expect(names.toSet(), hasLength(LeaveType.values.length));
    expect(names, containsAll(['Yıllık izin', 'Hastalık ve rapor', 'Diğer']));
  });

  test(
    'hostile notes survive a strict parser and formulas are inert',
    () async {
      final report = await buildReport(
        profile: HostileFixture.profile(),
        leaves: HostileFixture.leaves(),
      );
      final rows = parse(encoder.encode(report));

      expect(rows, hasLength(HostileFixture.texts.length + 1));
      expect(rows.every((row) => row.length == 7), isTrue);
      final notes = rows.skip(1).map((row) => row[6]).toList();
      for (final text in HostileFixture.texts) {
        final escaped = text.isNotEmpty && '=+-@\t\r'.contains(text[0])
            ? "'$text"
            : text;
        expect(notes, contains(escaped));
      }
      for (final row in rows) {
        for (final cell in row) {
          expect('=+-@'.contains(cell.isEmpty ? ' ' : cell[0]), isFalse);
        }
      }
    },
  );
}
