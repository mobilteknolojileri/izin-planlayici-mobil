import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/database/converters/int_list_converter.dart';

void main() {
  const converter = IntListConverter();

  test('round-trips a list and keeps its order', () {
    const days = [6, 1, 2];

    expect(converter.toSql(days), '[6,1,2]');
    expect(converter.fromSql(converter.toSql(days)), days);
  });

  test('round-trips an empty list', () {
    expect(converter.fromSql(converter.toSql(const [])), isEmpty);
  });
}
