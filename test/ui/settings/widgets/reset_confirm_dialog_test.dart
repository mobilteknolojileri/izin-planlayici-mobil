import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/ui/settings/widgets/reset_confirm_dialog.dart';

void main() {
  test('the confirm word matches in any case, Turkish İ included', () {
    for (final typed in ['sil', 'Sil', 'SİL', 'SIL', ' sil ']) {
      expect(ResetConfirmDialog.matches(typed, 'sil'), isTrue, reason: typed);
    }
  });

  test('other text does not match', () {
    for (final typed in ['', 'si', 'silme', 'evet', 'sıl']) {
      expect(ResetConfirmDialog.matches(typed, 'sil'), isFalse, reason: typed);
    }
  });
}
