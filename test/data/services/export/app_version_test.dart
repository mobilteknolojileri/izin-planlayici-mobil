import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/services/export/app_version.dart';

void main() {
  test('parses pubspec versions with and without a build number', () {
    expect(AppVersion.tryParse('1.2.3+4'), const AppVersion(1, 2, 3, 4));
    expect(AppVersion.tryParse('1.2.3'), const AppVersion(1, 2, 3));
    expect(AppVersion.tryParse('1.2.3')!.build, 0);
    expect(AppVersion.tryParse('10.0.0+120').toString(), '10.0.0+120');
  });

  test('rejects other shapes', () {
    for (final text in [
      '',
      '1',
      '1.2',
      '1.2.3+',
      '1.2.3-beta',
      'v1.2.3',
      ' 1.2.3',
      '1.2.3+4+5',
      '9999999999.0.0',
    ]) {
      expect(AppVersion.tryParse(text), isNull, reason: text);
    }
  });

  test('orders by major, minor, patch, then build', () {
    const base = AppVersion(1, 2, 3, 4);
    expect(const AppVersion(2, 0, 0).isNewerThan(base), isTrue);
    expect(const AppVersion(1, 3, 0).isNewerThan(base), isTrue);
    expect(const AppVersion(1, 2, 4).isNewerThan(base), isTrue);
    expect(const AppVersion(1, 2, 3, 5).isNewerThan(base), isTrue);
    expect(base.isNewerThan(base), isFalse);
    expect(const AppVersion(1, 2, 3, 3).isNewerThan(base), isFalse);
    expect(const AppVersion(0, 9, 9, 99).isNewerThan(base), isFalse);
    expect(
      const AppVersion(1, 2, 3).hashCode,
      const AppVersion(1, 2, 3).hashCode,
    );
  });
}
