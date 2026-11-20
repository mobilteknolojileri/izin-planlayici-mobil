# 11 Ekranlar

Bağımlılık: 05, 06. Paralel çalışır, domain ve veri task'ları bitmeden provider mock'larıyla geliştirilir. Yazma alanı: `lib/ui/<özellik>/` (`lib/ui/core/` hariç), `lib/l10n/parts/<özellik>.arb`, `test/ui/<özellik>/`. Her ekran `widgets/<özellik>_screen.dart` ve `view_models/<özellik>_view_model.dart` yapısını izler.

Bu task iki subagent'a bölünür:
- 11a: `onboarding`, `home`, `leaves`, `leave_form`, `explain`, `people`
- 11b: `calendar`, `bridge`, `stats`, `guide`, `settings`, `about`

Tüm ekranlar `docs/tasarim.md` ilkelerine uyar ve sadece task 06 bileşenlerini kullanır. Metinler ARB'den gelir, Dart kodunda Türkçe metin yazılmaz. Yeni bir görsel bileşen gerekirse task 06 klasörüne yazılmaz, ihtiyaç çıktıya not edilir.

## Ekranlar

1. **Kurulum:** en fazla 4 adım, her adımda tek soru ve neden sorulduğu: çalışan tipi, işe giriş tarihi, doğum tarihi, cumartesi çalışıyor musun. İsteğe bağlı "gelişmiş" bölümü: önceki hizmet, önceden kullanılan izin, sözleşme veya sendika ek izni, yer altı işi, günlük çalışma saati. Hiçbir izin istenmez.
2. **Ana sayfa:** kalan izin büyük sayı ve halka grafik, sıradaki hak ediş geri sayımı, sıradaki resmî tatile kalan gün, en iyi köprü önerisi kartı (hafta şeridi ile), "İzin ekle" ana butonu. En fazla 4 kart.
3. **İzinlerim:** yıl ve tür filtresi, planlanan ve kullanılan ayrı bölümlerde, fazla mesai ve saatlik izin sekmesi.
4. **İzin formu:** tür, tarih aralığı veya yarım gün veya saat, not. Tarih seçilince düşülecek gün ve gün gün döküm canlı görünür. Bölme ve yetersiz bakiye uyarısı. Mazeret türünde kanuni gün önerisi.
5. **Nasıl hesaplandı:** dönem dönem hak edişler, uygulanan kural ve madde numarası, sade dille.
6. **Kişiler:** ekle, düzenle, sil, aktif kişiyi seç.
7. **Takvim:** aylık ve yıllık görünüm, renk açıklaması her zaman görünür, güne dokununca detay, aralık seçince izin formu, tüm kişiler görünümü.
8. **Köprü:** yıl seçimi, bakiye filtresi, öneri kartları (hafta şeridi + tek cümle), "Planla" butonu, yıllık optimum plan.
9. **İstatistik:** yıllara göre hak edilen ve kullanılan, türlere göre dağılım, bu yıl toplam tatil günü.
10. **Mevzuat rehberi:** kurallar sade dil ve görsellerle, kaynak linkleri, sayfa sonunda yasal uyarı (`docs/kapsam.md`, "Yasal uyarı").
11. **Ayarlar:** kişiler, çalışma düzeni, tema, bildirimler, yedekle ve geri yükle, dışa aktar, veriyi sıfırla.
12. **Hakkında:** sürüm, gizlilik politikası, mevzuat kaynakları, GPL-3.0 lisansı ve GitHub linki, paket lisansları (`showLicensePage`), yasal uyarı. Uyarı kurulumda ve hesap ekranlarında gösterilmez.

## Gezinme

Alt menü: Ana Sayfa, İzinlerim, Takvim, Köprü, Ayarlar. İstatistik ve mevzuat rehberi ana sayfadan ve ayarlardan açılır.

## Testler

Her ekran için widget testi: boş durum, dolu durum, form doğrulaması, büyük yazı boyutunda taşma olmaması.

## Kabul

Mock verilerle tüm ekranlar MuMu'da çalışıyor, `flutter analyze` temiz.
