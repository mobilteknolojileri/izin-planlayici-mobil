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
- Renk tek başına anlam taşımaz, her anlamın bir ikonu ve deseni de vardır.
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

- Tek font ailesi, tutarlı 8 pt boşluk ölçeği, Material 3.
- Kendi renk paleti, rakiplerden ayrışan sakin tonlar.
- Animasyonlar kısa ve amaca hizmet eder, dikkat dağıtmaz.
- Reklam, ödeme duvarı ve oyunlaştırma yok.

## Erişilebilirlik

- Dokunma alanları en az 48 dp.
- Metin kontrastı en az 4.5:1.
- Sistem yazı boyutu %200'e çıkınca taşma ve kesilme olmaz.
- Tüm görsel öğelerin TalkBack etiketi vardır, grafiklerin metin karşılığı okunur.
- Koyu tema tam desteklenir.
