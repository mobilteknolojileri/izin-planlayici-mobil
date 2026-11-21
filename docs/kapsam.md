# Kapsam

Uygulama tek sürümde eksiksiz çıkar. Rakiplerin tüm faydalı özelliklerini karşılar, eksik ve hatalarını kapatır (bkz. `rakipler/README.md`). Görsel dil ve akış kuralları `docs/tasarim.md`, hesap kuralları ve varsayılanlar `docs/mevzuat.md` içindedir.

## 1. Kişiler ve çalışma düzeni

- Birden fazla kişi, ücretsiz ve sınırsız (kendisi, eşi, çalışanı). Kişiler arasında tek dokunuşla geçiş.
- Çalışan tipi: İş Kanunu (4857) veya Devlet Memuru (657).
- İşe giriş tarihi. Doğum tarihi sadece işçilerden istenir, çünkü yaş kuralı sadece İş Kanunu'nda vardır. Nedeni ekranda yazar.
- Aynı işverende önceki hizmet süresi (4857) veya toplam hizmet süresi (657). Taşeron (alt işveren) çalışanı için hizmetin nasıl birleştiği bu alanın açıklamasında anlatılır, kural `docs/mevzuat.md`'de doğrulanmadan otomatik birleştirme yapılmaz.
- Yer altı işinde çalışıyor mu (4857, ek gün).
- Sözleşme veya sendika ile kanunun üstünde verilen ek izin günü.
- Uygulamaya başlamadan önce kullanılmış izin (ortadan başlama).
- Haftalık çalışma günleri ve cumartesinin izinden sayılıp sayılmayacağı. Sadece 4857 için gösterilir, varsayılan "sayılır" (Yargıtay'ın güncel görüşü), diğer görüş kısaca açıklanır.
- Memur için: mesai gününe denk gelen idari izin günleri girişi (izinden sayılmaz).
- Öğretmen işareti: 657 md. 103/2'ye göre öğretmenlere yıllık izin verilmez, işaretlenirse hesap yerine açıklama gösterilir.
- Hak ediş tarihini kaydıran devamsızlık günleri (4857 md. 54/2). Girilmezse hesap kesintisiz çalışma varsayımıyla yapılır ve bu ekranda yazılır.
- Günlük çalışma saati (saatlik izni güne çevirmek için).

## 2. İzin hakkı hesabı

- Kıdeme ve yaşa göre yıllık izin hakkı (4857 md. 53, 657 md. 102), tüm sınırlar kanunla birebir (5 ve 15 yıl dâhil olma kuralları, 18 ve 50 yaş).
- Hak ediş tarihi: 4857'de her işe giriş yıl dönümü, 657'de takvim yılı.
- Bir sonraki hak ediş tarihi, o gün kazanılacak gün ve geri sayım.
- Geçmiş yılların hak edişleri ve devreden bakiye.
- "Nasıl hesaplandı?" ekranı: dönem dönem uygulanan kural ve madde numarası.

## 3. İzin kaydı ve bakiye

- İzin türleri: yıllık, hastalık ve rapor, ücretsiz, doğum (analık), babalık, evlenme, ölüm, sendika, mazeret, yol izni, diğer (kullanıcı adlandırır).
- Mazeret izinlerinin kanuni gün sayısı çalışan tipine göre önerilir (ör. evlenme işçide 3, memurda 7 gün, babalık 1.5.2026 ve sonraki doğumlarda 10 gün). Babalık için doğum tarihi sorulur.
- Sadece yıllık izin bakiyeden düşer. İstisna: 657 md. 104/C'deki ikinci 10 günlük mazeret izni yıllık izinden düşer.
- İki yoldan ekleme: form veya takvimde aralık seçme.
- Tarih aralığı seçilince düşülecek gün anında hesaplanır, gün gün döküm gösterilir:
  - 4857: hafta tatili ve resmî tatil sayılmaz, cumartesi ayara göre.
  - 657: aralıktaki cumartesi ve pazar sayılır, sadece hafta içine denk gelen resmî tatil ve idari izin sayılmaz.
  - Arife ve 28 Ekim: varsayılan 0,5 gün. Mevzuat net olmadığı için 0, 0,5 veya 1 ayarlanabilir, belirsizlik ekranda açıklanır.
- Yarım gün ve saatlik izin. Mevzuatta düzenlenmediği için "işyeri uygulaması" notuyla kaydedilir, saatlik izin günlük çalışma saatine göre bakiyeden düşer.
- Fazla mesai saati kaydı ve toplamı.
- İleri tarihli izin "planlanan" olarak ayrı tutulur, tarihi gelince kullanılmışa geçer.
- Bölme kuralı uyarısı: bir parçası en az 10 gün olmalı.
- Bakiye yetersizse uyarı, eksiye düşmeye izin verilir ama açıkça gösterilir.
- Düzenle, sil (geri al ile), not ekle.

## 4. Takvim

- Aylık ve yıllık görünüm.
- Resmî tatiller, arifeler, alınan, planlanan izinler ve köprü önerileri farklı renk, ikon ve desenle.
- Tüm kişileri aynı takvimde gösterme seçeneği (ekip görünümü).
- Güne dokununca detay, aralık seçince izin ekleme.

## 5. Köprü planlayıcı

- Seçilen yıl için resmî tatillere göre en verimli izin günleri: "2 gün izinle 5 gün tatil".
- Arife yarım günleri doğru hesaplanır.
- Hafta şeridi görseliyle gösterim.
- Verimliliğe, toplam uzunluğa ve tarihe göre sıralama.
- Kalan bakiyeye göre filtre: "elimdeki N günle en iyi plan".
- Tek dokunuşla öneriyi planlanan izin olarak ekleme.
- Yıllık optimum plan: bakiyenin tamamını en çok tatil günü verecek şekilde dağıtma.

## 6. Resmî tatil verisi

- 2026, 2027, 2028 resmî tatilleri, dinî bayramlar ve arifeler, uygulamaya gömülü, offline.
- Sıradaki resmî tatile geri sayım, yıl geçişinde kesintisiz.

## 7. İstatistik

- Yıllara göre kullanılan ve hak edilen izin grafiği, yıl karşılaştırması.
- Aylık dağılım grafiği (hangi aylarda izin kullanılmış).
- Kişi filtresi (tüm kişiler veya tek kişi).
- İzin türlerine göre dağılım.
- Bu yıl kaç gün tatil yapıldı (izin + resmî tatil + hafta sonu birlikte).

## 8. Bildirimler

- Yaklaşan resmî tatil ve köprü fırsatı (kaç gün önce olacağı seçilir).
- Hak ediş günü.
- Planlanan izin başlamadan önce ve izin dönüşünden önce.
- Yıl sonu yaklaşırken kullanılmamış izin: memurda önceki yılın kalan izni 1 Ocak'ta düştüğü için uyarı, işçide izin düşmediği için sadece bilgi.
- Exact alarm izni kullanılmaz, inexact zamanlama yeterli.

## 9. Ana ekran widget'ı

- Kalan izin günü ve sıradaki resmî tatile kalan gün.

## 10. Dışa aktarma ve yedek

- İzin geçmişi, hak edişler ve hizmet süresi PDF, Excel (xlsx) ve CSV olarak dışa aktarılır. Her biri için "Paylaş" ve "Cihaza kaydet" ayrı seçenek.
- Tüm veriyi tek yedek dosyasına alma ve geri yükleme. Yedek, paylaşım menüsüyle Google Drive'a veya başka bir yere kaydedilebilir.

## 11. Mevzuat rehberi

- Yıllık izinle ilgili kurallar sade Türkçe ve görsellerle, kaynak madde linkiyle.
- Yasal uyarı (metni kök `README.md` içindeki "Yasal uyarı" bölümü).

## 12. Ayarlar ve bilgi

- Tema: sistem, açık, koyu.
- Bildirim tercihleri.
- Kişiler ve çalışma düzeni.
- Yedekle, geri yükle, dışa aktar, veriyi sıfırla.
- Hakkında: sürüm, mevzuat kaynakları, gizlilik politikası, açık kaynak lisansı (GPL-3.0) ve kaynak kod linki, kullanılan paketlerin lisansları, yasal uyarı.

## Gizlilik ve izinler

- İnternet, konum, reklam kimliği, hesap yok. Veri sadece cihazda.
- Kullanıcıdan istenen tek izin bildirim izni, o da isteğe bağlı. Manifest'te bunun dışında sadece kurulumda otomatik verilen, kullanıcıya sorulmayan normal izinler bulunur: yeniden başlatmada bildirimleri tekrar planlamak için `RECEIVE_BOOT_COMPLETED`, bildirim titreşimi için `VIBRATE`, widget güncellemesi (`home_widget` → WorkManager) için `WAKE_LOCK`, `FOREGROUND_SERVICE` ve `ACCESS_NETWORK_STATE`. `INTERNET` release'de yoktur.

## Yasal uyarı

- Metin kök `README.md` içindeki "Yasal uyarı" bölümüdür. Uygulamada Hakkında ekranında ve mevzuat rehberinde, web'de gizlilik politikası sayfasında yer alır.
- Kurulumda, hesap ekranlarında ve bildirimlerde gösterilmez, çünkü kullanıcıyı yormamalı.

## Kapsam dışı

- Hava durumu, oyunlaştırma, ABD modu, sunucu ve senkronizasyon (gerekçe `rakipler/README.md`).
