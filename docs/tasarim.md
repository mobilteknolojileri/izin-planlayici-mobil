# Tasarım ilkeleri

Hedef kullanıcı telefonu kullanan ama uygulamalarla arası iyi olmayan biri. Ekranı ilk gördüğünde ne yapacağını anlamalı. Görünüm profesyonel, sade ve güven veren olmalı.

## Anlaşılırlık

- Her ekran tek bir soruya cevap verir ve tek bir ana butonu vardır.
- Ana bilgi büyük bir sayı ile gösterilir, yanında kısa bir cümle olur: "18 gün izin hakkın kaldı".
- Kanuni terimler sade Türkçe ile söylenir. Örneğin "kıdem" yerine "bu işyerinde çalıştığın süre". Gerekli terimlerin yanında "?" vardır, dokununca tek cümlelik açıklama çıkar.
- Her hesap sonucunun yanında "Nasıl hesaplandı?" bağlantısı vardır. Hangi kuralın uygulandığını adım adım ve madde numarasıyla gösterir.
- Hitap "sen" ile, cümleler kısa, ünlem ve emoji yok.
- Tarih formatı "20 Kasım 2026, Cuma".

## Görsellik

- Bilgi önce görselle verilir: halka grafik, takvim renkleri, hafta şeridi.
- Köprü önerisi bir hafta şeridiyle gösterilir: çalışma günü, izin günü, resmî tatil ve hafta sonu farklı kutucuklarda. Altında tek cümle: "2 gün izinle 5 gün tatil, 20-24 Nisan".
- Renk tek başına anlam taşımaz, her anlamın bir ikonu vardır. Metin taşımayan işaretlerde (halka, renk açıklaması, takvim işareti) desen ya da çizgi biçimi de vardır. Halkada kalan gün dolu bant, kullanılan gün çentikli bant, planlanan gün içi boş bant olarak çizilir. Üzerinde metin olan kutucuklarda desen kullanılmaz, çünkü desen metnin okunmasını zorlaştırır.
- Renk açıklaması takvimin altında her zaman görünür.
- Boş ekranlarda illüstrasyon, tek cümle ve tek buton olur.

## Akış

- Kurulum en fazla 4 adım, her adımda tek soru: çalışan tipi, işe giriş tarihi, doğum tarihi, cumartesi çalışıyor musun. Her soru neden sorulduğunu bir cümleyle söyler.
- İlk açılışta hiçbir izin istenmez. Bildirim izni sadece kullanıcı bir hatırlatmayı açtığında istenir.
- Alt menüde en fazla 5 sekme: Ana Sayfa, İzinlerim, Takvim, Köprü, Ayarlar.
- İzin eklemenin iki yolu vardır: buton ile form veya takvimde aralık seçmek. İkisi de düşülecek günü anında gösterir.
- Hatalı girişi baştan engelle: bitiş başlangıçtan önce seçilemez, gelecekteki işe giriş tarihi seçilemez.
- Silme ve düzenleme geri alınabilir.

## Profesyonellik

- Düzen iOS'a benzer: gri zemin üzerinde kenarlıksız beyaz kartlar, yumuşak köşeler (superellipse) ve büyük başlık. Altyapı Material bileşenleridir, görünüm temadan gelir.
- Alt menü yüzen bir Liquid Glass çubuğudur. Camın renk yoğunluğu, arkadan ne geçerse geçsin etiketleri okunur tutar.
- Tek font ailesi (Inter), tek ikon seti (Lucide) ve tutarlı 8 pt boşluk ölçeği kullanılır.
- Ana renk kraliyet mavisidir. Kart başlıkları türüne göre mavi, yeşil, turuncu veya mordur.
- Animasyonlar kısa ve amaca hizmet eder, dikkat dağıtmaz.
- Reklam, ödeme duvarı ve oyunlaştırma yok.

## Erişilebilirlik

- Dokunma alanları en az 48 dp.
- Metin kontrastı, büyük metin de dâhil en az 4.5:1. Grafik öğeler, desenler ve kontrol kenarları en az 3:1. Yarı saydam yüzeylerde kontrast, arkadan geçebilecek her renge karşı hesaplanır.
- Sistem yazı boyutu %200'e çıkınca taşma, kesilme ve kelime bölünmesi olmaz. Android'in doğrusal olmayan yazı ölçeği de buna dâhildir.
- Alt menü etiketleri en fazla 1.3 katına büyür, uzun basınca tam boy gösterilir, çünkü beş etiket %200'de telefon genişliğine sığmaz.
- Tüm görsel öğelerin TalkBack etiketi vardır, grafiklerin metin karşılığı okunur.
- Koyu tema tam desteklenir.
