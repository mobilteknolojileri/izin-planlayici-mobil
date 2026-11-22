# 17 MuMu ile uçtan uca test

Bağımlılık: 16.

Durum: tamamlandı. Kontrol listesinin hepsi release APK `1.0.0+4` ile geçti, sonuçlar ve düzeltilen iki hata `docs/test-raporu.md` içinde.

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
