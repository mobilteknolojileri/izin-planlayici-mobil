# 18 Play'e yükleme hazırlığı

Bağımlılık: 17.

Durum: kapalı testte versionCode 4 incelemede. Dahili testte 1.0.0 (versionCode 2) yayında. Kapalı test 1.0.0 (versionCode 3) 23 Kasım 2026'da yayına girdi. 1.0.0 (versionCode 4) ve yenilenen `08-hakkinda.png` ekran görüntüsü 24 Kasım 2026'da incelemeye gönderildi. Test kullanıcıları `testers-community@googlegroups.com` ve TheClosedTest uygulamasının `developers-community-official@googlegroups.com` Google gruplarından gelir, ikinci grup 24 Kasım 2026'da yayına girdi. Mağaza girişi, uygulama içeriği beyanları ve GitHub Pages'taki gizlilik politikası tamam. Play Console'daki satıcı statüsü beyanı henüz yapılmadı. Üretim başvurusu, en az 12 test kullanıcısı 14 gün kesintisiz testte kaldıktan sonra yapılır. Kök `README.md` tamam, Play linki uygulama herkese açılınca eklenir.

## Yapılacaklar

1. Upload keystore `~/.keystores/izin-planla/` altında, şifreleri aynı klasördeki `key.properties` dosyasında. `android/key.properties` bu dosyanın kopyasıdır ve `.gitignore`'dadır. Klasörü şifre yöneticisine veya şifreli bir yedeğe kopyala, çünkü anahtar kaybolursa Play Console'dan upload key sıfırlama talebi açmak gerekir.
2. `android/app/build.gradle.kts` release signing'i `key.properties`'ten okusun.
3. `pubspec.yaml`'daki build numarası her Play yüklemesinde bir artar, çünkü Play aynı versionCode'u ikinci kez kabul etmez. Dahili test 2, kapalı test 3 ve 4 ile yüklendi. Sıradaki yüklemeden önce build numarası 5'e çıkarılır.
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
