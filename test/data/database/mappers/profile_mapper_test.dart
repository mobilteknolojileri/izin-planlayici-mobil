import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/database/mappers/profile_mapper.dart';

import '../../repositories/fixtures.dart';

void main() {
  test('maps every profile field to the row and back', () {
    final profile = fullProfile();

    expect(ProfileMapper.toModel(ProfileMapper.toRow(profile)), profile);
  });

  test('keeps the model defaults', () {
    final profile = simpleProfile('p1');

    expect(ProfileMapper.toModel(ProfileMapper.toRow(profile)), profile);
  });
}
