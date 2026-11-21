# 06 Tasarım sistemi ve görsel dil

Bağımlılık: 05. Paralel aşamadan önce tek başına yapılır, çünkü tüm ekranlar bu bileşenleri kullanır. Yazma alanı: `lib/ui/core/`, `lib/l10n/parts/core.arb`, `assets/illustrations/`, `assets/fonts/`, `test/ui/core/`, cam kurulumu için `lib/main.dart`.

Durum: tamamlandı, iOS düzenine geçirildi. Kraliyet mavisi tema, Lucide ikonları, Liquid Glass alt menü. Tüm renk çiftleri AA testinden geçiyor, golden'lar üç yazı boyutunda, analyze temiz, 221 test geçiyor, MuMu'da iki temada ve %200 yazıda denendi.

## Amaç

`docs/tasarim.md` ilkelerini koda dökmek: tema, renk, yazı, ikon, illüstrasyon ve tekrar kullanılan bileşenler. Ekran task'ları sadece bu bileşenlerle çalışır, kendi stilini icat etmez.

## Yapılacaklar

1. **Tema:** açık ve koyu `ThemeData`, iOS düzeni: gri zemin, kenarlıksız beyaz kartlar, superellipse köşeler (`AppShapes`), kraliyet mavisi, 8 pt boşluk ölçeği.
2. **Renk anlamları:** kalan izin, kullanılan, planlanan, resmî tatil, arife (yarım gün), hafta sonu, köprü önerisi. Her anlam renk ve ikon ile ayrılır, metin taşımayan işaretlerde desen de vardır (renk körlüğü). Metin en az 4.5:1, grafik en az 3:1.
3. **Yazı:** Türkçe karakter destekli tek font ailesi, asset olarak gömülü. Büyük sayı, başlık, gövde, açıklama stilleri. Sistem yazı boyutu %200'e çıkınca, Android'in doğrusal olmayan ölçeğinde de, taşma ve kelime bölünmesi yok.
4. **İkon ve illüstrasyon:** tek ikon seti (Lucide). Boş durumlar ve kurulum adımları için illüstrasyonlar. Lisansı ticari kullanıma açık kaynaktan veya kendi üretimimiz, lisans `assets/illustrations/LICENSE.md` dosyasına yazılır.
5. **Bileşenler:**
   - `BigNumberCard`: mavi ana kart: başlık, tek büyük sayı, kısa cümle, isteğe bağlı halka ve "Nasıl hesaplandı?" satırı (ör. "Kalan izin, 18 gün")
   - `BalanceRing`, `BalanceLegend`: kalan (dolu), kullanılan (çentikli), planlanan (içi boş) halka grafiği ve aynı işaretli açıklaması
   - `StatCard`: renkli başlık altında tek sayı (ör. "Sıradaki tatil, 42 gün kaldı")
   - `InsetCard`, `CardHeader`: beyaz kart ve renkli ikonlu başlık, isteğe bağlı dokunulabilir
   - `WeekStrip`: köprü önerisinde günleri kutucuk olarak gösteren şerit (çalışma, izin, tatil, hafta sonu)
   - `DayBreakdownList`: izin aralığında her günün neden sayıldığını veya sayılmadığını gösteren liste
   - `LegendRow`: renk açıklaması, her takvimin altında sabit
   - `InfoTip`: terimin yanında "?" ile açılan tek cümlelik açıklama
   - `EmptyState`: illüstrasyon + tek cümle + tek buton
   - `PrimaryButton`, `SecondaryButton`: kapsül, en az 56 dp yükseklik. Ana buton hafif renk geçişli ve gölgeli
   - `LargeTitlePage`: sekme ekranlarının iskeleti: büyük başlık, durum çubuğu altında yumuşak geçiş, cam alt menünün üstünde biten liste
   - `StepScaffold`: kurulum adımları için ilerleme göstergeli iskelet
   - `UndoSnackBar`: silme ve düzenlemede geri al
   - `AppTabBar`: yüzen Liquid Glass alt menü, etiketler en fazla 1.3 kat büyür, uzun basınca tam boy gösterilir
6. **Galeri ekranı:** sadece debug build'de açılan, tüm bileşenleri açık ve koyu temada gösteren sayfa. Bileşenlerle kurulmuş örnek ana sayfa da buradan açılır, task 11 ana sayfayı aynı şekilde kurar.
7. **Golden testler:** her bileşen için açık ve koyu tema, %100, doğrusal %200 ve Android %200 yazı boyutu.

## Kabul

- Galeri ekranında tüm bileşenler iki temada da düzgün.
- Golden testler geçiyor.
- Tüm renk çiftleri AA kontrast testinden geçiyor.
- `flutter analyze` sıfır uyarı.
