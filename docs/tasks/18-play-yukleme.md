# 18 Play'e yükleme hazırlığı

Bağımlılık: 17.

## Yapılacaklar

1. Upload keystore oluştur. Keystore ve şifreleri repo dışında sakla, `key.properties` `.gitignore`'da.
2. `android/app/build.gradle.kts` release signing'i `key.properties`'ten okusun.
3. `pubspec.yaml`'da `version: 1.0.0+1` (versionName 1.0.0, versionCode 1), imzalı AAB üret.
4. Gizlilik politikasını GitHub Pages ile repo üzerinden yayınla, URL'yi Play Console'a gir.
5. Kök `README.md`'yi tamamla: ekran görüntüleri, Play linki, CI ve lisans rozetleri.
6. Play Console adımları için kullanıcıya tek numaralı liste hazırla:
   - Uygulama oluştur (ad, dil: Türkçe, ücretsiz)
   - Uygulama içeriği beyanları (gizlilik politikası, reklam yok, Data safety, içerik derecelendirme, hedef kitle, finansal özellikler: yok)
   - Store listesi (task 15 çıktısı, task 17 ekran görüntüleri)
   - Closed testing sürümü oluştur, AAB yükle, test kullanıcılarını ekle, incelemeye gönder
   - Hesap 13 Kasım 2023'ten sonra açılmış kişisel hesapsa production başvurusundan önce en az 12 test kullanıcısı 14 gün kesintisiz kapalı teste katılmış olmalı. Test kullanıcısı listesi bu yüzden erken hazırlanır.

## Kabul

İmzalı AAB hazır, Play Console'a girilecek tüm metin ve görseller `store/` altında.
