# 13 Dışa aktarma ve yedek

Bağımlılık: 05. Paralel çalışır. Yazma alanı: `lib/data/services/export/`, `lib/l10n/parts/export.arb`, `test/data/services/export/`.

Durum: tamamlandı. CSV, PDF, Excel ve sürümlü yedek `lib/data/services/export/` içinde. Paylaşma, cihaza kaydetme ve geri yükleme task 17'de MuMu'da denendi, sonuçlar `docs/test-raporu.md` içinde.

## Yapılacaklar

- İzin geçmişi CSV: UTF-8 BOM ile (Excel Türkçe karakterleri doğru açsın), ayırıcı `;`.
- İzin geçmişi PDF: başlık, profil özeti, hak ediş tablosu, izin tablosu, yasal uyarı. Türkçe karakter destekleyen font gömülü.
- Excel (xlsx): `archive` paketiyle kendi küçük yazıcımız (çalışma sayfası, başlık satırı, tarih ve sayı hücreleri). Excel ve LibreOffice'te açıldığı doğrulanır.
- Her biçim için "Paylaş" (`share_plus`) ve "Cihaza kaydet" (sistem dosya seçicisi) seçenekleri.
- Yedek: task 10'un `BackupCodec`'iyle tek JSON dosyası, `share_plus` ile kaydet veya paylaş.
- Geri yükleme: `file_picker` ile dosya seç, doğrula, onay iste, yükle.

## Testler

- CSV içeriği ve Türkçe karakterler.
- PDF üretimi hata vermiyor, sayfa sayısı beklenen.

## Kabul

MuMu'da CSV, PDF, Excel ve yedek dosyası oluşturulup paylaşılabiliyor, yedek geri yüklenebiliyor.
