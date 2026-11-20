# 14 Ana ekran widget'ı

Bağımlılık: 05. Paralel çalışır. Yazma alanı: `lib/data/services/home_widget/`, `lib/l10n/parts/home_widget.arb`, `test/data/services/home_widget/`, task 05'in oluşturduğu widget taslakları (Kotlin provider, `res/xml/` ve `res/layout/` dosyaları), `res/drawable/` altında `widget_` önekli yeni dosyalar. Manifest'teki receiver satırı task 05'te hazırdır.

## Yapılacaklar

- `home_widget` ile Android widget: kalan izin günü ve sıradaki resmî tatile kalan gün.
- Widget'a dokununca uygulama ana sayfası açılır.
- Veri değişince ve gün dönünce widget güncellenir.
- Açık ve koyu tema uyumu.

## Notlar

- `home_widget` WorkManager'ı getirir, WorkManager da `WAKE_LOCK`, `FOREGROUND_SERVICE` ve `ACCESS_NETWORK_STATE` normal izinlerini ekler. Widget bunlar olmadan güncellenmezse kalırlar, gerekmiyorsa task 16'da manifest'ten `tools:node="remove"` ile çıkarılır.

## Kabul

MuMu'da widget eklenebiliyor, izin ekleyince değer güncelleniyor.
