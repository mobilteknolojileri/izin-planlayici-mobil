# İzin Planla

Türkiye'de çalışanlar için yıllık izin hakkı hesaplama, izin takibi ve köprü tatil planlama uygulaması.

- Store adı: İzin Planla: Yıllık İzin Takip
- Package id: `com.izinplanla.app` (Play'e yüklendikten sonra değiştirilemez)
- Platform: Flutter, önce Android
- Veri: tamamen cihazda, internet ve hesap gerekmez

## Klasörler

- `docs/` proje dokümanları
  - `kapsam.md` eksiksiz özellik listesi
  - `tasarim.md` görsel dil, akış ve erişilebilirlik ilkeleri
  - `mimari.md` klasör yapısı, paketler ve paralel çalışma kuralları
  - `mevzuat.md` izin kuralları ve resmî kaynakları (task 03)
  - `araclar.md` plugin, skill, MCP ve paket seçimleri (task 04)
  - `tasks/` her görev için ayrı brief, subagent'lara tek dosya olarak verilir
- `rakipler/` her rakip için analiz, ekran görüntüleri ve APK. Sadece yerelde durur, git'e girmez
- `tools/` proje script'leri: `mumu.sh` (MuMu ve adb), `merge_arb.dart` (metinler), `checks/` (commit ve kalite kontrolleri)
- `.tooling/` sadece bu projenin kullandığı araçlar (NDK), git'e girmez
- Flutter projesi kök klasörde (`lib/`, `test/`, `testing/`, `android/`, `drift_schemas/`), task 05 ile oluşur. Yapı `docs/mimari.md` içinde
- `.githooks/` ve `.github/workflows/` commit kuralları ve CI

## Görev sırası

1. Analiz: 01 → 02, 03 bunlarla paralel.
2. Hazırlık (sıralı): 04 → 05 → 06.
3. Geliştirme (paralel subagent): 07, 08, 09, 10, 11, 12, 13, 14, 15.
4. Bitiriş (sıralı): 16 → 17 → 18.

Bağımlılıklar her task dosyasının başında yazar.

## Kurallar

- Repo açık kaynaktır (GPL-3.0, GitHub'da public). Dosya içeriğine kişisel bilgi (kullanıcı yolu, e-posta) yazılmaz ve rakip materyali commit'lenmez, çünkü git geçmişi geri alınamaz. Commit yazarı olarak global git e-postası kullanılır.

- Rakiplerin kodu, metni, ikonu ve görselleri kopyalanmaz, sadece özellik ve hata analizi yapılır.
- Her yasal kural `docs/mevzuat.md` içindeki bir kaynağa bağlanır, kaynaksız kural koda girmez.
- Uygulama hiçbir kişisel veriyi cihaz dışına göndermez, Data safety beyanı buna göre yapılır.
- Her ekran `docs/tasarim.md` ilkelerine ve task 06 bileşenlerine uyar.
