# 15 Görseller ve store metni

Bağımlılık: 02, 06 (renk paleti). Paralel çalışır. Yazma alanı: `assets/branding/`, `store/`, `android/app/src/main/res/mipmap-*`, `flutter_native_splash`'in ürettiği açılış ekranı dosyaları.

## Yapılacaklar

- Uygulama ikonu: 512x512 PNG ve adaptive icon (ön plan + arka plan). Rakiplerden farklı, sade. `flutter_launcher_icons` ile üretilir.
- Açılış ekranı: `flutter_native_splash` ile, Android 12+ splash API'sine uygun.
- Feature graphic: 1024x500.
- Store metni (Türkçe): kısa açıklama (en fazla 80 karakter), tam açıklama (en fazla 4000 karakter). Anahtar kelimeler: yıllık izin hesaplama, izin takip, köprü, resmî tatiller 2027.
- Gizlilik politikası metni: veri toplanmadığı, cihazda saklandığı, üçüncü tarafla paylaşılmadığı. Sonunda kök `README.md`'deki yasal uyarı.
- Data safety cevapları: veri toplanmıyor, paylaşılmıyor.
- İçerik derecelendirme anketi için cevap notları.

## Çıktı

- `store/listing-tr.md`, `store/privacy-policy.md`, `store/data-safety.md`
- `assets/branding/` altında kaynak dosyalar

## Kabul

Görsel boyutları Play şartlarına uyuyor, metinler karakter sınırları içinde.
