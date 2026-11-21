# Ekran görüntüsü başlıkları

Ekran görüntüleri entegrasyondan sonra bitmiş uygulamadan alınır. Her görüntünün üstüne bir başlık ve altına kısa bir cümle yazılır. Görüntüdeki veriler örnek kişiye aittir, gerçek kişi adı kullanılmaz.

Play şartı: telefon için en az 2, en fazla 8 görüntü, PNG veya JPEG, kısa kenar en az 320 px, uzun kenar kısa kenarın en fazla 2 katı. Öne çıkarılmaya uygun olmak için en az 1080x1920 önerilir.

| Sıra | Çekilecek ekran | Başlık | Alt cümle |
|---|---|---|---|
| 1 | Ana Sayfa, bakiye halkası ve büyük sayı | Kalan izin günün tek bakışta | Kıdemine ve yaşına göre hesaplanır |
| 2 | "Nasıl hesaplandı?" ekranı | Her sonucun kaynağı belli | Kural ve kanun maddesi adım adım |
| 3 | İzin ekleme, gün gün döküm açık | Düşülecek gün anında çıkar | Hafta sonu, resmî tatil ve arife ayrı |
| 4 | Köprü sekmesi, hafta şeritli öneri listesi | Az izinle uzun tatil | 2027 resmî tatillerine göre köprü önerileri |
| 5 | Takvim, aylık görünüm ve renk açıklaması | İzinler ve tatiller aynı takvimde | Renk, ikon ve desenle ayrılır |
| 6 | İstatistik ekranı | Yıllara göre izin kullanımın | Aylık dağılım ve izin türleri |
| 7 | Ana ekran widget'ı ve hatırlatma bildirimi | Hatırlatma ve widget | Hak ediş günü ve yaklaşan tatiller |
| 8 | Ayarlar veya Hakkında, gizlilik bölümü | Verilerin telefonunda kalır | Reklam yok, hesap ve internet gerekmez |

## Notlar

- Başlıklar Inter yazı tipiyle ve beyaz yazılır. Zemin `store/images/feature-graphic.png` ile aynı mavi degradedir (#2B4FD8 ile #13277E arası).
- Köprü görüntüsünde 2027 yılı seçilir, çünkü mağaza aramasında "resmî tatiller 2027" ifadesi hedeflenir.
- Koyu tema için ayrı görüntü gerekmez. İstenirse 5. görüntü koyu temada alınır.
