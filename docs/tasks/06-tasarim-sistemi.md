# 06 Tasarım sistemi ve görsel dil

Bağımlılık: 05. Paralel aşamadan önce tek başına yapılır, çünkü tüm ekranlar bu bileşenleri kullanır. Yazma alanı: `lib/ui/core/`, `lib/l10n/parts/core.arb`, `assets/illustrations/`, `assets/fonts/`, `test/ui/core/`.

## Amaç

`docs/tasarim.md` ilkelerini koda dökmek: tema, renk, yazı, ikon, illüstrasyon ve tekrar kullanılan bileşenler. Ekran task'ları sadece bu bileşenlerle çalışır, kendi stilini icat etmez.

## Yapılacaklar

1. **Tema:** açık ve koyu `ThemeData` (Material 3), renk token'ları, 8 pt boşluk ölçeği, köşe yarıçapları, gölgeler.
2. **Renk anlamları:** kalan izin, kullanılan, planlanan, resmî tatil, arife (yarım gün), hafta sonu, köprü önerisi. Her anlam renk + ikon + desen ile ayrılır (renk körlüğü). Kontrast en az 4.5:1.
3. **Yazı:** Türkçe karakter destekli tek font ailesi, asset olarak gömülü. Büyük sayı, başlık, gövde, açıklama stilleri. Sistem yazı boyutu %200'e çıkınca taşma yok.
4. **İkon ve illüstrasyon:** tek ikon seti. Boş durumlar ve kurulum adımları için illüstrasyonlar. Lisansı ticari kullanıma açık kaynaktan veya kendi üretimimiz, lisans `assets/illustrations/LICENSE.md` dosyasına yazılır.
5. **Bileşenler:**
   - `BigNumberCard`: tek büyük sayı + kısa etiket + ikon (ör. "18 gün izin hakkın kaldı")
   - `BalanceRing`: kalan, kullanılan, planlanan halka grafiği
   - `WeekStrip`: köprü önerisinde günleri kutucuk olarak gösteren şerit (çalışma, izin, tatil, hafta sonu)
   - `DayBreakdownList`: izin aralığında her günün neden sayıldığını veya sayılmadığını gösteren liste
   - `LegendRow`: renk açıklaması, her takvimin altında sabit
   - `InfoTip`: terimin yanında "?" ile açılan tek cümlelik açıklama
   - `EmptyState`: illüstrasyon + tek cümle + tek buton
   - `PrimaryButton`, `SecondaryButton`: en az 48 dp dokunma alanı
   - `StepScaffold`: kurulum adımları için ilerleme göstergeli iskelet
   - `UndoSnackBar`: silme ve düzenlemede geri al
6. **Galeri ekranı:** sadece debug build'de açılan, tüm bileşenleri açık ve koyu temada gösteren sayfa.
7. **Golden testler:** her bileşen için açık, koyu ve büyük yazı boyutu.

## Kabul

- Galeri ekranında tüm bileşenler iki temada da düzgün.
- Golden testler geçiyor.
- `flutter analyze` sıfır uyarı.
