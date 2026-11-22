# Test raporu

Task 17'nin çıktısıdır. Testler 22 Kasım 2026'da MuMu'da (Android 15) release APK `1.0.0+4` ile yapıldı. Bildirim ve widget testleri aynı görevin önceki oturumunda debug APK ile yapıldı.

## Sonuç

Kontrol listesinin bütün maddeleri geçti. Testte iki hata bulundu, ikisi de düzeltilip cihazda tekrar denendi. logcat'te uygulamaya ait hata yok.

## Hesap senaryoları

Rakip sütunları `rakipler/README.md`'deki analizden alındı, rakipler 20 Kasım 2026'da test edildi. Rakip A yıllık izin takip uygulaması, Rakip B resmî tatil uygulamasıdır.

| Senaryo | Beklenen | İzin Planla | Rakip A | Rakip B |
|---|---|---|---|---|
| 4 yıllık işçi, işe giriş 15.11.2022 | 56 gün | 56 gün | 56 gün | Hesap yok |
| 15 yıllık işçi, işe giriş 15.11.2011 | 276 gün, sonraki hak 26 gün | 276 gün, sonraki hak 26 gün | 270 gün, 15. yılı 20 gün sayıyor | Hesap yok |
| 50 yaş üstü işçi, doğum 01.01.1970, işe giriş 15.11.2022 | 80 gün | 80 gün | Doğum tarihi sorulmuyor | Hesap yok |
| 18 yaş altı işçi, doğum 01.01.2009, işe giriş 15.11.2024 | 40 gün | 40 gün | Doğum tarihi sorulmuyor | Hesap yok |
| Yılbaşını kapsayan izin, 28.12.2026-08.01.2027 | 10 gün | 10 gün, gün gün döküm doğru | Denenemedi, izin ekleme reklam kilidinde | Hesap yok |
| Arifeli izin, 08.03.2027-12.03.2027 | 1,5 gün | 1,5 gün | Bilinmiyor | Arife sabahını atlıyor |
| Sıradaki tatil | Yılbaşı 2027 | Yılbaşı, 40 gün kaldı (22 Kasım) | Denenmedi | "2026 tatilleri bitti", 0 gün |

Yılbaşı aralığında 2 Ocak cumartesi de izinden düşer, çünkü `docs/mevzuat.md` 1.10'a göre çalışılmayan cumartesi varsayılan olarak izinden sayılır. Ayar kapalıyken cumartesi düşmez, bu durum cihazda ayrıca denenmedi.

## Kontrol listesi

| Madde | Sonuç | Not |
|---|---|---|
| Açık ve koyu tema | Geçti | |
| Büyük yazı (Android %200) | Geçti | Ana sayfa, İzinlerim, Ayarlar ve Köprü'de taşma yok. |
| Ekran döndürme | Geçti | Ana sayfa, takvim ve köprü yatayda kayıyor, veri kaybolmuyor. |
| Kapatıp açınca veri duruyor | Geçti | APK güncellemesinden ve emülatörün yeniden başlamasından sonra da duruyor. |
| Bildirim izni ver ve reddet | Geçti | Önceki oturum, debug APK. |
| Widget | Geçti | Önceki oturum, debug APK. |
| PDF, Excel, CSV | Geçti | PDF ve Excel paylaşım menüsüyle, CSV "Cihaza kaydet" ile alındı. CSV UTF-8 BOM'lu ve noktalı virgülle ayrılmış. |
| Yedek | Geçti | `izin-planla-yedek-<tarih>.json` oluşuyor, paylaşım menüsü açılıyor. |
| Geri yükleme | Geçti | Geçerli yedek onaydan sonra geri yüklendi. Bozuk yedekte doğru uyarı çıkıyor (hata 2). |
| Uçak modu | Geçti | Ana sayfa, takvim, köprü ve izin formu çalışıyor. |
| logcat | Geçti | Uygulamaya ait hata ve exception yok. Sadece emülatörün grafik sürücüsü uyarıları var. |

## Bulunan hatalar

1. Köprü ekranı ve takvim geçmiş tarihleri öneriyordu. 22 Kasım'da "Kurban Bayramı, 26-31 Mayıs 2026" önerisi çıkıyor, takvimde geçmiş günler "Önerilen izin" olarak görünüyordu. `BridgePlanner`'a `after` parametresi eklendi, ekranlar bugünü veriyor. Testler: `test/domain/bridge/default_bridge_planner_test.dart`, `test/ui/bridge/widgets/bridge_screen_test.dart`, `test/ui/calendar/widgets/calendar_screen_test.dart`.
2. Bozuk veya başka bir dosya geri yüklenmek istenince "İşlem tamamlanamadı. Tekrar dene." çıkıyordu. Tekrar denemek işe yaramadığı için mesaj yanıltıcıydı. Dosya okuma hataları artık "geçerli bir İzin Planla yedeği değil" ve "daha yeni bir sürümüyle alınmış" mesajlarına bağlı. Test: `test/ui/settings/widgets/settings_screen_test.dart`.

## Notlar

- İzin formunda geri tuşu girilen tarihleri sormadan siliyor. `docs/tasarim.md`'de bununla ilgili kural olmadığı için hata sayılmadı.
- Emülatörde paylaşım menüsü doğrudan Quick Share'i açıyor, çünkü başka paylaşım uygulaması kurulu değil.
- Emülatöre özgü sorunlar (DNS, saat, paylaşılan klasör) `tools/README.md` içinde.
