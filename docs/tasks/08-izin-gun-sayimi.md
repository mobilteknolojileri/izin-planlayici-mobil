# 08 İzin gün sayımı ve bakiye

Bağımlılık: 03, 05. Paralel çalışır. Yazma alanı: `lib/domain/day_count/`, `test/domain/day_count/`.

## Amaç

Bir izin aralığından kaç günün bakiyeden düşeceğini ve güncel bakiyeyi hesaplamak.

## Kurallar

- 4857: hafta tatili ve resmî tatiller sayılmaz (md. 56), cumartesi `WorkSchedule` ayarına göre (varsayılan sayılır), `docs/mevzuat.md` 1.9.
- 657: aralıktaki cumartesi ve pazar sayılır, sadece hafta içine denk gelen resmî tatil ve idari izin günleri sayılmaz, `docs/mevzuat.md` 2.5.
- Arifeler ve 28 Ekim: ayara göre 0, 0,5 veya 1 gün (varsayılan 0,5), `docs/mevzuat.md` bölüm 4.
- Yarım günlük izin kaydı.
- Saatlik izin: profildeki günlük çalışma saatine göre gün karşılığı bakiyeden düşer.
- Uygulamaya başlamadan önce kullanılmış izin bakiyeden düşer.
- Mazeret izin türleri için kanuni gün önerisi (`docs/mevzuat.md`).
- İstatistik ekranı için yıllık özet: hak edilen, kullanılan, türlere göre dağılım, toplam tatil günü (izin + resmî tatil + hafta sonu).
- Sadece yıllık izin türü bakiyeden düşer. Mazeret, rapor ve ücretsiz izin bakiyeyi etkilemez ama listelenir.
- Bölme uyarısı: bir hak ediş döneminde en az 10 günlük bir parça yoksa uyarı üretir (4857 md. 56).

## Arayüz

Kesin imzalar `lib/domain/day_count/` altındaki arayüz dosyalarındadır. Implementasyon `default_*.dart` dosyalarına yazılır.

- `LeaveDayCounter.count(DateRange, Profile, List<Holiday>)` → `DayCount`: düşülecek gün ve gün gün döküm (`DayReason`). Çalışan tipi, cumartesi ve arife ayarı (`WorkSchedule`) ve idari izin günleri `Profile` içindedir.
- `BalanceCalculator.balance(profile, periods, leaves, holidays, today)` → `LeaveBalance`: hak edilen, kullanılan, planlanan, kalan.
- `SplitRuleChecker.check(profile, periods, leaves, holidays)` → `LeaveWarning` listesi (bölme ve yol izni sınırı).
- `StatutoryLeaveAdvisor.suggestedDays(LeaveType, Profile, eventDate)` → mazeret türü için kanuni gün.
- `YearSummaryCalculator.summary(year, profile, periods, leaves, holidays)` → `YearSummary` (istatistik ekranı).

## Testler

- Bayramı ve hafta sonunu kapsayan aralık.
- Arife içeren aralık.
- Cumartesi ayarı açık ve kapalı (4857).
- Aynı aralığın 4857 ve 657 için farklı sonuç vermesi.
- Arife ayarının üç değeri.
- Yıl sonundan yeni yıla geçen aralık.
- İleri tarihli (planlanan) izin bakiyede ayrı görünüyor.

## Kabul

Tüm testler geçiyor, döküm her günün nedenini veriyor.
