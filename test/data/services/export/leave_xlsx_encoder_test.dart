import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/services/export/leave_xlsx_encoder.dart';
import 'package:izin_planla/data/services/export/xlsx_writer.dart';
import 'package:izin_planla/domain/models/models.dart';

import 'support/hostile_fixture.dart';
import 'support/report_factory.dart';
import 'support/xlsx_parts.dart';

void main() {
  final encoder = LeaveXlsxEncoder(reportText);

  Profile civilServant() => Profile(
    id: 'memur',
    name: 'Zeynep Işık',
    employmentType: EmploymentType.civilServant,
    employmentStartDate: DateTime.utc(2015, 9),
    birthDate: DateTime.utc(1988, 4, 23),
    isTeacher: true,
  );

  test('has summary, entitlement and leave sheets in Turkish', () async {
    final report = await buildReport(profile: HostileFixture.profile());
    final parts = readParts(encoder.encode(report));
    final names = parts['xl/workbook.xml']!
        .descendants('sheet')
        .map((sheet) => sheet.attributes['name']);
    expect(names, ['Özet', 'Hak edişler', 'İzinler']);
  });

  test('summary keeps dates and day counts as typed cells', () async {
    final report = await buildReport(
      profile: HostileFixture.profile(),
      next: NextAccrual(date: DateTime.utc(2027, 3, 31), days: 22),
    );
    final parts = readParts(encoder.encode(report));
    final rows = sheetValues(parts, 1);
    final byLabel = {
      for (final row in rows)
        if (row.length == 2) row[0]: row[1],
    };

    expect(rows.first, ['Bilgi', 'Değer']);
    expect(byLabel['Ad'], HostileFixture.profile().name);
    expect(byLabel['Tabi olduğu kanun'], 'İş Kanunu (4857)');
    expect(
      byLabel['İşe giriş tarihi'],
      '${XlsxWriter.serialDate(DateTime.utc(2019, 3, 31))}',
    );
    expect(byLabel['Önceki hizmet süresi'], '1 yıl 1 ay 3 gün');
    expect(byLabel['Toplam hizmet süresi'], '8 yıl 8 ay 27 gün');
    expect(byLabel['Hak edişi kaydıran devamsızlık'], '10 gün');
    expect(byLabel['Sözleşmeyle gelen ek gün'], '2');
    expect(byLabel['Yer altı işi'], 'Evet');
    expect(byLabel['Uygulamadan önce kullanılan izin'], '3.5');
    expect(byLabel['Kullanılan'], '3.5');
    expect(byLabel['Kalan'], '-3.5');
    expect(byLabel['Sonraki hak ediş'], '31.03.2027, 22 gün');
    expect(byLabel.containsKey('Öğretmen'), isFalse);
    expect(byLabel.containsKey('Yıl sonunda düşecek'), isFalse);
    expect(rows.last, ['Oluşturulma tarihi: 21.11.2026']);

    final dateCell = parts['xl/worksheets/sheet1.xml']!
        .descendants('c')
        .firstWhere((c) => c.attributes['r'] == 'B4');
    expect(dateCell.attributes['s'], '2');
  });

  test('civil servant entitlements show year and expiry columns', () async {
    final report = await buildReport(
      profile: civilServant(),
      periods: civilServantPeriods(),
    );
    final parts = readParts(encoder.encode(report));
    final summary = {
      for (final row in sheetValues(parts, 1))
        if (row.length == 2) row[0]: row[1],
    };
    final rows = sheetValues(parts, 2);

    expect(summary['Göreve başlama tarihi'], isNotNull);
    expect(summary['Tabi olduğu kanun'], 'Devlet Memurları Kanunu (657)');
    expect(summary['Öğretmen'], 'Evet');
    expect(summary['Yıl sonunda düşecek'], '5');
    expect(rows, [
      [
        'Hak ediş tarihi',
        'Yıl',
        'Gün',
        'Kullanılmazsa düşeceği tarih',
        'Dayanak',
      ],
      [
        '${XlsxWriter.serialDate(DateTime.utc(2025))}',
        '2025',
        '20',
        '${XlsxWriter.serialDate(DateTime.utc(2027))}',
        '',
      ],
      [
        '${XlsxWriter.serialDate(DateTime.utc(2026))}',
        '2026',
        '20',
        '${XlsxWriter.serialDate(DateTime.utc(2028))}',
        '657 md. 102, 657 md. 103',
      ],
    ]);
  });

  test('worker entitlements leave out the civil servant columns', () async {
    final report = await buildReport(
      profile: HostileFixture.profile(),
      periods: [
        EntitlementPeriod(accrualDate: DateTime.utc(2026, 3, 31), days: 16),
      ],
    );
    final rows = sheetValues(readParts(encoder.encode(report)), 2);
    expect(rows.first, ['Hak ediş tarihi', 'Gün', 'Dayanak']);
    expect(rows[1].sublist(0, 2), [
      '${XlsxWriter.serialDate(DateTime.utc(2026, 3, 31))}',
      '16',
    ]);
  });

  test('leave sheet has a bold frozen header and typed cells', () async {
    final report = await buildReport(
      profile: HostileFixture.profile(),
      leaves: HostileFixture.leaves(),
    );
    final parts = readParts(encoder.encode(report));
    final rows = sheetValues(parts, 3);
    final sheet = parts['xl/worksheets/sheet3.xml']!;

    expect(rows, hasLength(HostileFixture.texts.length + 1));
    expect(rows.first, [
      'Tür',
      'Başlangıç',
      'Bitiş',
      'Süre',
      'Yıllık izinden düşen gün',
      'Durum',
      'Not',
    ]);
    final header = sheet.descendants('row').first.children;
    expect(header.every((c) => c.attributes['s'] == '1'), isTrue);
    expect(sheet.descendants('pane').single.attributes['state'], 'frozen');

    final first = sheet.descendants('row').elementAt(1).children;
    expect(first[1].attributes['s'], '2');
    expect(first[2].attributes['s'], '2');
    expect(first[4].attributes['t'], isNull);
    expect(rows[1][4], '5');
  });
}
