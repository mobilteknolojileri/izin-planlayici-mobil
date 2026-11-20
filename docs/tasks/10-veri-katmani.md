# 10 Veri katmanı

Bağımlılık: 05. Paralel çalışır. Yazma alanı: `lib/data/database/`, `lib/data/repositories/`, `test/data/database/`, `test/data/repositories/`. Paralel aşamada `build_runner`'ı sadece bu task çalıştırır.

## Amaç

Profil, izin kaydı, fazla mesai ve ayarları cihazda SQLite'ta (`drift`) saklamak, resmî tatilleri asset'ten okumak.

## Yapılacaklar

- `drift` veritabanı (`drift_flutter` ile açılır): profil, izin kaydı, fazla mesai ve ayar tabloları. Tablolar domain modellerine repository içinde çevrilir, `drift` tipleri `lib/data/` dışına çıkmaz.
- `ProfileRepository`, `LeaveRepository`, `OvertimeRepository`, `SettingsRepository` implementasyonları. Liste ekranları için `Stream` döndüren izleme metotları.
- Her yazma işlemi tek transaction.
- Şema sürümü 1'den başlar. Migration'lar `drift_dev` ile şema dosyası (`drift_schemas/`) üretilerek yazılır ve şema testleriyle doğrulanır.
- Çoklu profil: aktif profil ayarı.
- `HolidayRepository`: `assets/holidays/tr_2026_2028.json` dosyasını yükler, yıla ve aralığa göre sorgular.
- `BackupCodec`: tüm veriyi sürüm bilgili tek JSON olarak dışa ve içe aktarma (task 13 kullanır). İçe aktarmada şema doğrulaması, daha yeni uygulama sürümünün dosyası reddedilir. Geri yükleme tek transaction'da yapılır, hata olursa mevcut veri korunur.
- "Veriyi sıfırla" fonksiyonu.

## Testler

- Bellek içi veritabanıyla kaydet, oku, güncelle, sil.
- Migration testi (şema dosyalarından).
- Dışa aktar ve geri yükle sonrası verinin aynı olması.
- Geçersiz veya yarım yedek dosyasının reddedilmesi, mevcut verinin bozulmaması.

## Kabul

Tüm testler geçiyor, uygulama yeniden başlayınca veri korunuyor.
