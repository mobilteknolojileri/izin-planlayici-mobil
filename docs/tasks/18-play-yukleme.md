# 18 Play'e yükleme hazırlığı

Bağımlılık: 17.

Durum: başladı. Upload keystore, release imzası ve `1.0.0+2` sürümü hazır. Hesabın kapanmaması için 0.1.0 dahili test sürümü (versionCode 1) üretildi. Gizlilik politikasının yayını, README ve Play Console adımları kaldı.

## Yapılacaklar

1. Upload keystore `~/.keystores/izin-planla/` altında, şifreleri aynı klasördeki `key.properties` dosyasında. `android/key.properties` bu dosyanın kopyasıdır ve `.gitignore`'dadır. Klasörü şifre yöneticisine veya şifreli bir yedeğe kopyala, çünkü anahtar kaybolursa Play Console'dan upload key sıfırlama talebi açmak gerekir.
2. `android/app/build.gradle.kts` release signing'i `key.properties`'ten okusun.
3. `pubspec.yaml`'da `version: 1.0.0+2` (versionName 1.0.0, versionCode 2), imzalı AAB üret. versionCode 1 dahili test sürümünde kullanıldı, Play aynı numarayı ikinci kez kabul etmez.
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
