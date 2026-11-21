# Google Play mağaza metni (tr-TR)

Kod bloklarındaki metin Play Console'a olduğu gibi yapıştırılır. Karakter sayıları `store/tool/check_store.dart` ile ölçülür, sınırlar Play'in sınırlarıdır.

## Uygulama adı (en fazla 30 karakter)

```text
İzin Planla: Yıllık İzin Takip
```

Ad 30 karakterdir, "yıllık izin" ve "izin takip" aramalarını tutar. `docs/README.md` dosyasında da aynı ad yazar.

## Kısa açıklama (en fazla 80 karakter)

```text
Yıllık izin hakkını hesapla, izinlerini takip et, köprü tatillerini planla.
```

## Tam açıklama (en fazla 4000 karakter)

```text
İzin Planla, Türkiye'deki çalışanlar için yıllık izin hesaplama, izin takip ve köprü tatili planlama uygulamasıdır. İş Kanunu (4857) ve Devlet Memurları Kanunu (657) kurallarıyla çalışır. Reklam yoktur, hesap ve internet bağlantısı gerekmez.

Yıllık izin hakkın
• İşe giriş tarihine ve yaşına göre yıllık izin hakkını hesaplar. Kıdem sınırları ve İş Kanunu'ndaki 18 ve 50 yaş kuralı dâhildir.
• Bir sonraki hak ediş tarihini, o gün kazanacağın gün sayısını ve kalan süreyi gösterir.
• Geçmiş yılların hak edişlerini ve devreden bakiyeni tutar.
• Her sonucun yanında "Nasıl hesaplandı?" bağlantısı vardır. Hangi kuralın hangi kanun maddesine göre uygulandığını adım adım görürsün.

İzin takip
• Yıllık izin, rapor, ücretsiz izin, doğum, babalık, evlenme, ölüm, sendika, mazeret ve yol izni kaydedilir. Listede olmayan türü kendin adlandırırsın.
• Tarih aralığını seçtiğin anda düşülecek gün, gün gün dökümle çıkar. Hafta tatili, resmî tatil, arife ve cumartesi ayarı hesaba katılır.
• Memurlar için mesai gününe denk gelen idari izin günleri izinden sayılmaz.
• Yarım gün ve saatlik izin kaydedersin, fazla mesai saatlerini tutarsın.
• İleri tarihli izinler "planlanan" olarak ayrı durur. Bakiyen yetmezse uyarı görürsün.
• İzni formla veya takvimde aralık seçerek eklersin. Silme ve düzenleme geri alınabilir.

Köprü planlayıcı
• Seçtiğin yılın resmî tatillerine göre izin günü önerir: "2 gün izinle 5 gün tatil" gibi. Arife yarım günlerini de sayar.
• Önerileri hafta şeridiyle gösterir, verimliliğe, toplam uzunluğa veya tarihe göre sıralar.
• Elindeki izin günüyle en çok tatil günü kazandıran planı çıkarır, bakiyenin tamamını yıla dağıtır.
• Beğendiğin öneriyi tek dokunuşla planlanan izin olarak eklersin.

Resmî tatiller 2027 ve 2028
• Uygulamanın içinde 2026, 2027 ve 2028 resmî tatilleri, dinî bayramlar ve arifeler gelir, internet gerekmez.
• Sıradaki resmî tatile kalan günü uygulamada ve ana ekran widget'ında görürsün.

Takvim ve istatistik
• Aylık ve yıllık takvimde resmî tatiller, arifeler, kullandığın ve planladığın izinler farklı renk, ikon ve desenle görünür.
• Yıllara ve aylara göre izin grafiklerini, izin türlerine göre dağılımı ve bu yıl kaç gün tatil yaptığını izlersin.

Birden fazla kişi
• Kendin, eşin veya çalışanın için ayrı kişi eklersin. Kişi sayısı sınırsız ve ücretsizdir.
• İstersen bütün kişileri aynı takvimde görürsün.

Hatırlatma, widget ve dışa aktarma
• Yaklaşan resmî tatil, köprü fırsatı, hak ediş günü ve planlanan izinler için hatırlatma kurarsın. Bildirim izni sadece bir hatırlatmayı açtığında sorulur.
• Ana ekran widget'ı kalan izin gününü ve sıradaki resmî tatili gösterir.
• İzin geçmişini PDF, Excel ve CSV olarak dışa aktarırsın.
• Bütün verini tek yedek dosyasına alıp geri yüklersin. Yedeği paylaşım menüsüyle Google Drive'a veya istediğin yere kaydedebilirsin.

Mevzuat rehberi
• Yıllık izin kuralları sade Türkçeyle ve kaynak kanun maddeleriyle anlatılır.

Gizlilik
Uygulama internet izni istemez. Hesap, reklam ve analitik yoktur. Veriler sadece cihazında saklanır, hiçbir sunucuya gönderilmez.

Açık kaynak
İzin Planla, GPL-3.0 lisanslı açık kaynak bir uygulamadır.

Kaynaklar
Hesapların dayandığı resmî metinler:
• 4857 sayılı İş Kanunu: https://www.mevzuat.gov.tr/mevzuat?MevzuatNo=4857&MevzuatTur=1&MevzuatTertip=5
• Yıllık Ücretli İzin Yönetmeliği: https://www.mevzuat.gov.tr/mevzuat?MevzuatNo=5451&MevzuatTur=7&MevzuatTertip=5
• 657 sayılı Devlet Memurları Kanunu: https://www.mevzuat.gov.tr/mevzuat?MevzuatNo=657&MevzuatTur=1&MevzuatTertip=5
• 2429 sayılı Ulusal Bayram ve Genel Tatiller Hakkında Kanun: https://www.mevzuat.gov.tr/mevzuat?MevzuatNo=2429&MevzuatTur=1&MevzuatTertip=5

İzin Planla bir devlet uygulaması değildir, hiçbir kamu kurumuyla bağlantısı yoktur. Bilgilendirme amaçlıdır, hukuki tavsiye değildir. Kesin bilgi için işverenine, insan kaynaklarına veya bir hukukçuya danış.
```

## Anahtar kelimeler

Play'de ayrı anahtar kelime alanı yoktur, arama tam açıklamayı okur. Aşağıdaki ifadeler metinde geçer:

- yıllık izin hesaplama
- izin takip
- köprü
- resmî tatiller 2027

## Kategori ve gizlilik politikası

- Kategori: İş (Business) veya Verimlilik (Productivity).
- Gizlilik politikası: `store/privacy-policy.md` metni herkese açık bir adreste yayımlanır ve o adres Play Console'a girilir.
