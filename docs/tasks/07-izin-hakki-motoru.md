# 07 İzin hakkı motoru

Bağımlılık: 03, 05. Paralel çalışır. Yazma alanı: `lib/domain/entitlement/`, `test/domain/entitlement/`.

## Amaç

Profilden yıllık izin hak edişlerini hesaplayan saf Dart motoru.

## Kurallar

`docs/mevzuat.md` tek kaynaktır. Orada olmayan kural eklenmez.

- 4857: işe giriş yıl dönümünde hak ediş, kıdem dilimleri, yaş alt sınırı, yer altı ek günü, önceki hizmetin eklenmesi, sözleşmesel ek gün.
- 657: takvim yılı esası, hizmet süresi dilimleri, bir önceki yıldan devir kuralı.
- Yaş kuralı hak ediş tarihindeki yaşa göre uygulanır (mevzuat.md'deki yoruma göre).

## Arayüz

Kesin imza `lib/domain/entitlement/entitlement_calculator.dart`, implementasyon `default_entitlement_calculator.dart`.

`EntitlementCalculator.periods(Profile, {DateTime until})` → hak ediş dönemleri listesi. Her dönem: başlangıç, bitiş, gün sayısı, uygulanan kurallar ve madde numaraları ("neden bu kadar" ekranı bunu gösterir).

`EntitlementCalculator.nextAccrual(Profile, DateTime today)` → bir sonraki hak ediş tarihi ve gün sayısı.

## Testler

- Kıdem dilim sınırları: tam 1, 5, 15 yıl ve bir gün öncesi.
- 18 yaş ve 50 yaş sınırları, artık yıl doğum günü (29 Şubat).
- Bir yılı doldurmamış çalışan: hak ediş yok.
- 657 için 10 yıl sınırı ve devir.
- Önceki hizmet eklenmiş profil.
- Devamsızlık dönemi girilmiş profil (4857 md. 54/2, `docs/mevzuat.md` 1.2).

## Kabul

Tüm testler geçiyor, her dönem kural açıklamasını taşıyor.
