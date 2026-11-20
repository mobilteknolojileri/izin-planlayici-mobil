# 16 Entegrasyon ve testler

Bağımlılık: 07-15 tamamlanmış olmalı.

## Yapılacaklar

1. Fake provider'ları (`lib/data/fakes/`) gerçek implementasyonlarla değiştir. Fake'ler geliştirme için kalır, release build'e girmez.
2. Paralel task'ların bildirdiği model ve arayüz ihtiyaçlarını uygula.
3. Ana senaryolar için integration test:
   - İlk kurulum → hak ediş görünür.
   - İzin ekle → bakiye düşer, takvimde görünür, widget güncellenir.
   - Köprü önerisini planla → planlanan izin olarak eklenir.
   - Yedekle → sıfırla → geri yükle → veri aynı.
4. `flutter analyze` sıfır uyarı, `flutter test` tamamı geçiyor, CI yeşil.
5. Release build: `flutter build appbundle --release` ve test için `flutter build apk --release`.

## Kabul

Tüm testler geçiyor, release APK MuMu'ya kuruluyor.
