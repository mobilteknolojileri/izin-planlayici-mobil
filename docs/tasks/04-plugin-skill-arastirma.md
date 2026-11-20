# 04 Plugin, skill ve araç araştırması ve kurulumu

Bağımlılık: 02 ve 03 bitmiş olmalı. Geliştirme (05) başlamadan önce yapılır.

Durum: tamamlandı. Sonuç `docs/araclar.md`.

## Amaç

Flutter geliştirmeyi, bu projenin ihtiyaçlarını ve paralel subagent çalışmasını hızlandıracak plugin, skill, MCP server ve Flutter paketlerini bulmak ve kurmak. Her açıdan aranır, "gereksiz" diye erken elenmez. Sonradan elenen her aday gerekçesiyle listede kalır.

## Araştırılacak açılar

1. **Claude Code plugin ve skill'leri:** Flutter ve Dart geliştirme, mobil UI ve tasarım, erişilebilirlik denetimi, test yazımı, kod incelemesi, Android build ve imzalama, Play Store listesi ve ASO, uygulama ikonu ve görsel üretimi, Türkçe metin (mevcut `turkce-yazim` skill'i dâhil).
2. **MCP server'lar:** resmî Dart ve Flutter MCP server, adb ve emülatör (MuMu) kontrolü yapan mobil MCP, paket dokümantasyonu getiren MCP, mevcut Playwright MCP'nin bu projede kullanımı.
3. **Flutter paketleri:** `docs/mimari.md` listesinin yeniden değerlendirilmesi ve eksikler:
   - Lint: `flutter_lints` veya `very_good_analysis`
   - Test: `mocktail`, golden test (`alchemist` vb.), `integration_test` veya `patrol`
   - Görsel: `flutter_svg`, grafik için `fl_chart`, animasyon için hafif bir seçenek
   - Font: Türkçe karakter destekli font, internet istememesi için asset olarak gömülü
   - Kod üretimi: `freezed` ve `json_serializable` gerekli mi kararı
   - Araç: `flutter_launcher_icons`, `flutter_native_splash`
   - Durum, yönlendirme: `flutter_riverpod`, `go_router`
4. **Kalite ve güvenlik araçları:** bağımlılık lisans kontrolü, `dart pub outdated`, APK boyut analizi.

## Değerlendirme ölçütleri

- Resmî veya aktif bakımlı (son 6 ay içinde sürüm), pub.dev puanı, lisans uyumlu.
- Uygulamaya `INTERNET` veya gereksiz Android izni eklemiyor.
- Kurulmadan önce kaynak kodu ve istediği izinler okunur. Bilinmeyen kaynaktan script çalıştırılmaz.

## Yapılacaklar

1. Her açı için adayları listele: ad, kaynak linki, ne işe yarar, bu projede nerede kullanılır, risk.
2. Seçilenleri kur. Claude Code plugin ve MCP kurulumları proje kapsamında (`.claude/` veya `.mcp.json`) yapılır, kullanıcı geneline yazılmaz.
3. Her kurulumun çalıştığını küçük bir deneme ile doğrula.
4. `docs/mimari.md` paket listesini sonuca göre güncelle.

## Çıktı

- `docs/araclar.md`: seçilen ve elenen tüm adaylar, gerekçe, kurulum komutu, doğrulama sonucu.
- Güncel `docs/mimari.md`.
- Proje kapsamında kurulu plugin, skill ve MCP yapılandırması.

## Kabul

- Her açıdan en az bir aday değerlendirilmiş.
- Kurulanların hepsi deneme ile çalışıyor.
- Kurulum, kullanıcının genel Claude ayarlarını değiştirmiyor.
