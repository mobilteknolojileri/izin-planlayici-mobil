# 02 Rakip analizi (MuMu)

Bağımlılık: 01.

Durum: tamamlandı. Sonuçlar `rakipler/` altında.

## Amaç

Rakipleri gerçek kullanıcı gibi kullanıp özelliklerini, hesap kurallarını ve hatalarını çıkarmak. Bizim uygulamanın hepsini daha iyi yapmasını sağlamak.

## Yapılacaklar

1. Her uygulamayı MuMu'da baştan sona kullan. Her ekranın görüntüsünü `rakipler/<klasör>/ekranlar/NN-ekran-adi.png` olarak kaydet.
2. Özellik envanteri çıkar: ekranlar, girdiler, ayarlar, bildirimler, widget, dışa aktarma, reklam, ücretli kısım.
3. Hesap doğruluğunu test et:
   - 4 yıllık çalışan: beklenen 14 gün/yıl.
   - 50 yaş üstü veya 18 yaş altı çalışan: beklenen en az 20 gün.
   - 15 yıllık çalışan: 15. yıl 26 gün.
   - Resmî tatil ve hafta sonunu kapsayan izin aralığı.
   - Arife içeren izin aralığı veya köprü önerisi.
4. Köprü önerilerini kontrol et: hangi yılları kapsıyor, doğru mu, bakiyeye göre filtre var mı.
5. Play yorumlarını oku, şikayet ve istekleri listele.
6. UX notları: kurulum kaç adım, ana ekranda ne var, kafa karıştıran yerler.

## Çıktı

- `rakipler/<klasör>/analiz.md`: bağlam, ekran listesi, özellikler, test sonuçları, avantajlar, dezavantajlar, yorumlar, dersler.
- `rakipler/README.md`: karşılaştırma tablosu, fırsatlar, bilinçli olarak alınmayan özellikler.
- `docs/kapsam.md` bu sonuçlara göre güncellenir.

## Kural

Rakip uygulamalarda reklama tıklanmaz ve reklam izlenmez. Metin, ikon, renk paleti ve görseller kopyalanmaz.
