# 01 Rakip APK'larını indir

Bağımlılık: yok. MuMu'da Play Store'a Google hesabıyla giriş yapılmış olmalı (kullanıcı yapar).

Durum: tamamlandı.

## Amaç

Rakip uygulamaları resmî kaynaktan MuMu'ya kurmak ve APK dosyalarını incelemek için bilgisayara çekmek.

## Rakipler

- `com.nurettinkocak.yillikizintakip` Yıllık İzin Takip (Koçak Software) → `rakipler/kocak-yillik-izin-takip/`
- `com.resmitatiller.app2026` Resmi Tatiller 2026 (Beyaz Yaka) → `rakipler/resmi-tatiller-2026/`

## Yapılacaklar

1. MuMu instance 1'i (`yeni-mumu`) başlat: `MuMuManager.exe control -v 1 launch`.
2. `adb connect 127.0.0.1:<adb_port>` (port: `MuMuManager.exe info -v 1`). Yardımcı komutlar `tools/mumu.sh` içinde.
3. Her rakip için `am start -a android.intent.action.VIEW -d market://details?id=<id>` ile Play sayfasını aç ve kur.
4. `pm path <id>` ile APK yollarını bul (split APK olabilir), hepsini `rakipler/<klasör>/apk/` altına çek.
5. Her APK için `aapt2 dump badging` çıktısını `rakipler/<klasör>/apk/info.txt` dosyasına yaz.

## Kabul

- İki uygulama da MuMu'da açılıyor.
- İki klasörde de APK ve `info.txt` var.
