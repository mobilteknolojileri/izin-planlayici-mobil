# 17 MuMu ile uçtan uca test

Bağımlılık: 16.

Durum: başladı. Debug APK'da kurulum, hak ediş, izin ekleme, kalıcı kayıt, beş sekme, bildirim izni verme ve reddetme, link açma ve widget denendi. Rakip senaryoları, ekran görüntüleri, büyük yazı, ekran döndürme, uçak modu, CSV, PDF, yedek ve geri yükleme kaldı.

## Yapılacaklar

1. Release APK'yı MuMu'ya kur (`adb install -r`).
2. Task 02'deki hesap senaryolarını bizim uygulamada tekrarla. Sonuçları rakiplerle yan yana yaz.
3. Her ekranın görüntüsünü `store/ekran-goruntuleri/` altına kaydet. Bunlar store ekran görüntülerinin de kaynağıdır.
4. Kontrol listesi:
   - Açık ve koyu tema
   - Büyük yazı boyutu
   - Ekran döndürme
   - Uygulamayı kapatıp açınca veri duruyor
   - Bildirim izni ver ve reddet
   - Widget
   - CSV, PDF, yedek, geri yükleme
   - Uçak modunda her şey çalışıyor
5. `adb logcat` içinde hata ve exception taraması.

## Çıktı

`docs/test-raporu.md`: geçen ve kalan maddeler, bulunan hatalar. Hatalar düzeltilip test tekrarlanır.

## Kabul

Kontrol listesinin tamamı geçiyor, logcat'te uygulamaya ait hata yok.
