# 09 Köprü planlayıcı motoru

Bağımlılık: 03, 05. Paralel çalışır. Yazma alanı: `lib/domain/bridge/`, `test/domain/bridge/`.

## Amaç

Resmî tatillere göre en verimli izin günlerini bulmak.

## Davranış

- Girdi: yıl, `Profile` (çalışma düzeni ve arife ayarı içinde), tatil listesi, isteğe bağlı izin bütçesi, en fazla izin günü sınırı (varsayılan 5). Kesin imza `lib/domain/bridge/bridge_planner.dart`, implementasyon `default_bridge_planner.dart`.
- Çalışılmayan günler (hafta tatili, resmî tatil) ile izin günleri birleşince oluşan kesintisiz tatil blokları üretilir.
- Her öneri: izin alınacak günler, toplam tatil başlangıç-bitiş, toplam tatil günü, izin günü, verimlilik (tatil/izin).
- Sıralama: verimlilik, toplam uzunluk, tarih.
- Aynı tatili kapsayan benzer öneriler gruplanır, en iyisi öne çıkar.
- Yıllık optimum plan: verilen bütçeyle toplam tatil gününü en çoklayan, çakışmayan öneri kombinasyonu (dinamik programlama veya knapsack).
- Arife ve 28 Ekim: izin günü kullanıcının arife ayarına göre sayılır (varsayılan 0,5), `docs/mevzuat.md` bölüm 4.
- Gün sayımı için task 08'in `LeaveDayCounter`'ı kullanılır. 08 bitmeden arayüz üzerinden mock ile test edilir.

## Testler

- Perşembeye denk gelen tek günlük tatil: Cuma izni ile 4 gün.
- Bayram + hafta sonu birleşimi.
- Cumartesi ayarının sonuca etkisi.
- Bütçe 0 ve bütçe yetersiz durumları.
- Optimum planın brute force ile küçük örnekte aynı sonucu vermesi.

## Kabul

2027 verisinde öneriler elle kontrol edilen 3 örnekle eşleşiyor. Tüm testler geçiyor.
