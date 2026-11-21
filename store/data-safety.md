# Data safety cevapları

Play Console > Uygulama içeriği > Veri güvenliği formu için. Google'ın tanımında "toplama", verinin cihazdan çıkıp geliştiriciye veya üçüncü tarafa gitmesidir. İzin Planla hiçbir veriyi cihazdan göndermediği için cevaplar aşağıdaki gibidir.

## Veri toplama ve güvenlik

| Soru | Cevap | Not |
|---|---|---|
| Uygulama, istenen kullanıcı veri türlerinden herhangi birini topluyor veya paylaşıyor mu? | Hayır | Release sürümünde `INTERNET` izni yok, veriler sadece cihazdaki veritabanında. |
| Toplanan veriler aktarım sırasında şifreleniyor mu? | Sorulmaz | İlk soru "Hayır" olunca form bu bölümü atlar. |
| Kullanıcılar verilerinin silinmesini isteyebiliyor mu? | Sorulmaz | Uygulama içinde "Bütün verileri sil" yine de vardır. |

Mağazada görünecek özet: "Veri toplanmıyor" ve "Üçüncü taraflarla veri paylaşılmıyor".

## Neden "Hayır"

- Hesap, reklam, analitik ve çökme raporu SDK'sı yok. Release sürümünde `INTERNET` izni olmadığı için hiçbir paket ağa çıkamaz.
- İzin hesabı, hatırlatmalar ve ana ekran widget'ı cihazda çalışır.
- Dışa aktarma ve yedek dosyasını kullanıcı kendisi oluşturur ve paylaşım menüsüyle nereye gideceğini kendisi seçer. Google'ın kurallarında kullanıcının başlattığı bu aktarım "paylaşma" sayılmaz.

## Formdan önce kontrol

- Release manifest'inde `INTERNET` izni olmadığını birleştirilmiş manifest'ten doğrula.
- `android:allowBackup` kapalı değilse Android'in otomatik yedeği uygulama verisini kullanıcının Google hesabına kopyalayabilir. Gizlilik politikasındaki "sadece cihazında" ifadesi bu ayarın kapalı olmasına dayanır.
- Gizlilik politikası URL'si zorunludur: `store/privacy-policy.md` herkese açık bir adreste yayımlanır.
