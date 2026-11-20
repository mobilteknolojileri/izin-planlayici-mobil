# 03 Mevzuat ve resmî tatil verisi

Bağımlılık: yok (02 ile paralel çalışabilir).

Durum: tamamlandı. Kapsamı değiştiren bulgular `docs/kapsam.md` dosyasına işlendi.

## Amaç

Uygulamadaki her hesap kuralını resmî kaynağa dayandırmak ve 2026-2028 resmî tatil verisini doğru üretmek.

## Doğrulanacak kurallar

Kaynak: mevzuat.gov.tr metinleri. Her kural için madde numarası ve link yazılır.

- 4857 md. 53: kıdeme göre 14/20/26 gün, 18 yaş ve altı ile 50 yaş ve üstü için en az 20 gün, yer altı işlerinde ek gün, en az bir yıl çalışma şartı (deneme süresi dâhil).
- 4857 md. 54: izne hak kazanmada hesaba katılan süreler, aynı işverenin işyerlerinde geçen sürelerin birleşmesi.
- 4857 md. 56: izin süresine rastlayan ulusal bayram, hafta tatili ve genel tatillerin sayılmaması, bölme kuralı, yol izni.
- Yıllık Ücretli İzin Yönetmeliği: bölme ve uygulama ayrıntıları.
- 4857 Ek md. 2: mazeret izinleri (evlenme, babalık, ölüm vb.) ve gün sayıları.
- 657 md. 102 ve 103: memur yıllık izin süreleri, takvim yılı esası, devir kuralı.
- 2429 sayılı Ulusal Bayram ve Genel Tatiller Kanunu: tatil günleri ve yarım günler (arifeler, 28 Ekim).
- Cumartesinin izinden sayılması konusundaki Yargıtay görüş ayrılığı: uygulamada ayar olarak sunulacağı için iki görüş kısaca özetlenir.

## Resmî tatil verisi

- 2026, 2027, 2028 için sabit tatiller ve dinî bayramlar.
- Dinî bayram tarihleri Diyanet İşleri Başkanlığı takviminden alınır, kaynak linki yazılır.
- Her kayıt: tarih, ad, tür (ulusal, dinî, arife), yarım gün mü.

## Çıktı

- `docs/mevzuat.md`: her kural, madde numarası, link, uygulamadaki karşılığı.
- `assets/holidays/tr_2026_2028.json`: şema aşağıda.

```json
{
  "source": ["https://..."],
  "generatedAt": "YYYY-MM-DD",
  "holidays": [
    {"date": "2027-01-01", "name": "Yılbaşı", "type": "national", "halfDay": false}
  ]
}
```

`type`: `national`, `religious`, `eve`. Arifeler ve 28 Ekim `halfDay: true`.

## Kabul

- Her kuralın resmî kaynak linki var.
- JSON'daki her dinî bayram tarihi Diyanet kaynağıyla eşleşiyor.
- Doğrulanamayan bir şey varsa `docs/mevzuat.md` içinde "doğrulanamadı" olarak işaretli.
