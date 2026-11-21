# 18 Play'e yükleme hazırlığı

Bağımlılık: 17.

Durum: kapalı test incelemede. Dahili testte 1.0.0 (versionCode 2) yayında, kapalı test 1.0.0 (versionCode 3) 22 Kasım 2026'da incelemeye gönderildi. Test kullanıcıları `testers-community@googlegroups.com` grubu. Mağaza girişi, uygulama içeriği beyanları ve GitHub Pages'taki gizlilik politikası tamam. Üretim başvurusu 12 test kullanıcısı ve 14 gün sonra yapılır.

## Yapılacaklar

1. Upload keystore `~/.keystores/izin-planla/` altında, şifreleri aynı klasördeki `key.properties` dosyasında. `android/key.properties` bu dosyanın kopyasıdır ve `.gitignore`'dadır. Klasörü şifre yöneticisine veya şifreli bir yedeğe kopyala, çünkü anahtar kaybolursa Play Console'dan upload key sıfırlama talebi açmak gerekir.
2. `android/app/build.gradle.kts` release signing'i `key.properties`'ten okusun.
3. `pubspec.yaml`'daki build numarası her Play yüklemesinde bir artar, çünkü Play aynı versionCode'u ikinci kez kabul etmez. Dahili test 2, kapalı test 3 ile yüklendi, sıradaki yükleme 4.
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
