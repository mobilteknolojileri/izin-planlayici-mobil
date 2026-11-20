# 12 Bildirimler

Bağımlılık: 05. Paralel çalışır. Yazma alanı: `lib/data/services/notifications/`, `lib/l10n/parts/notifications.arb`, `test/data/services/notifications/`. Manifest ve Gradle ayarları task 05'te hazırdır, eksik varsa çıktıya not edilir.

## Yapılacaklar

- `NotificationService` implementasyonu: `flutter_local_notifications` + `timezone` (`Europe/Istanbul`).
- Android 13+ `POST_NOTIFICATIONS` izni, kullanıcı bildirimi açınca istenir.
- Exact alarm kullanılmaz (`SCHEDULE_EXACT_ALARM` yok), inexact zamanlama.
- Cihaz yeniden başlayınca bildirimlerin yeniden planlanması.
- Bildirim türleri: resmî tatil ve köprü fırsatı, hak ediş günü, planlanan izin başlangıcı ve dönüşü, yıl sonu kullanılmamış izin (memurda "1 Ocak'ta düşecek" uyarısı, işçide sadece bilgi).
- Kullanıcının seçtiği "kaç gün önce" değerine göre planlama.
- Veri değişince tüm bildirimleri yeniden hesaplayan tek bir `reschedule()` fonksiyonu.

## Testler

Planlama mantığı (hangi tarihte hangi bildirim) servis dışından test edilebilir saf fonksiyon olarak yazılır ve test edilir.

## Kabul

MuMu'da test bildirimi geliyor, izin reddedilince uygulama çökmeden devam ediyor.
