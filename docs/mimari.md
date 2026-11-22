# Mimari

Yapı Flutter'ın resmî mimari rehberini izler (https://docs.flutter.dev/app-architecture): UI katmanı özelliğe göre, veri katmanı türe göre ayrılır. En yaygın yapı olduğu için insan ve LLM dosyanın yerini tahmin edebilir.

## Teknoloji

- Flutter (stable), Dart 3, Material bileşenleri üzerinde iOS düzeni (`docs/tasarim.md`). Material import'u `package:material_ui/material_ui.dart`, çünkü `package:flutter/material.dart` deprecated.
- State ve bağımlılık: `flutter_riverpod`. Her ekranın tek view model'i vardır.
- Veri: cihazda SQLite (`drift`), repository arayüzü arkasında. Resmî tatiller `assets/holidays/` içindeki JSON'dan okunur.
- Modeller: `freezed` + `json_serializable`, immutable.
- Metinler: `flutter_localizations` + gen-l10n, sadece `tr`.
- Tarih: `intl`. Takvim: `table_calendar`. Router: `go_router`.
- Bildirim: `flutter_local_notifications`, `timezone`. Widget: `home_widget`.
- Dışa aktarma: `pdf`, `printing`, `share_plus`, `file_picker`, Excel için `archive` ile kendi xlsx yazıcımız.
- Grafik: `fl_chart`. Görsel: `flutter_svg`. İkon: `lucide_icons_flutter`. Alt menü camı: `liquid_glass_widgets`. Animasyon: `flutter_animate`, `animations`.
- Kalite: `very_good_analysis`, `mocktail`, `alchemist`.

Kesin liste ve sürümler `docs/araclar.md` içinde. Paket listesi task 05'te `pubspec.yaml`'a bir kez eklenir. Paralel task'lar `pubspec.yaml`'ı değiştirmez, yeni paket gerekirse task sahibi koordinatöre bildirir.

## Klasör yapısı

```
lib/
  main.dart
  app.dart                      # MaterialApp, tema, locale
  routing/                      # task 05, go_router ve route adları
  config/                       # task 05, dependencies.dart: tüm provider'lar
  utils/                        # result.dart: Result<T> (Ok, Err)
  l10n/
    parts/<özellik>.arb         # metin kaynağı, her özellik kendi dosyası
    app_tr.arb                  # tools/merge_arb.dart üretir, elle düzenlenmez
  ui/
    CLAUDE.md
    core/                       # task 06
      theme/                    # tema, renk ve boşluk token'ları
      widgets/                  # ortak bileşenler
    <özellik>/                  # task 11, her ekran kendi klasöründe
      view_models/<özellik>_view_model.dart
      widgets/<özellik>_screen.dart
  domain/                       # saf Dart, Flutter import'u yok
    CLAUDE.md
    models/                     # task 05, freezed modeller
    entitlement/                # task 07
    day_count/                  # task 08
    bridge/                     # task 09
  data/
    CLAUDE.md
    database/                   # task 10, drift tabloları ve migration
    repositories/               # task 10
    services/
      notifications/            # task 12
      export/                   # task 13
      home_widget/              # task 14
      links/                    # task 16, linki tarayıcıda açar
      app_info/                 # task 16, kurulu sürümü okur
    fakes/                      # task 05, ekranlar için geliştirme verisi
test/                           # lib/ ile birebir aynı yapı
testing/
  fakes/                        # yalnızca testlerin kullandığı mock'lar
tools/                          # proje script'leri (mumu.sh, merge_arb.dart, checks/)
.githooks/                      # commit kuralları
.github/workflows/ci.yml        # CI
```

Özellik klasörleri: `onboarding`, `home`, `leaves`, `leave_form`, `explain`, `people`, `calendar`, `bridge`, `stats`, `guide`, `settings`, `about`.

## LLM uyum kuralları

- `lib/ui/`, `lib/domain/`, `lib/data/` içinde kısa bir `CLAUDE.md` bulunur: klasörün kuralları ve hangi task'ın yazdığı. Claude Code o klasörde çalışırken bunu okur.
- Dosya adı içindeki public sınıfın snake_case karşılığıdır, dosya başına tek public sınıf. İstisna: sealed hiyerarşi (Dart gereği tek dosya) ve `lib/data/fakes/fake_calculators.dart`.
- Constructor'lar Dart 3.14 sözdizimiyle yazılır (`const new(...)`, `factory fromJson(...)`), `dart fix --apply` dönüştürür.
- `test/` yapısı `lib/` ile birebir aynıdır: `lib/a/b.dart` için test `test/a/b_test.dart`.
- Üretilen dosyalar (`*.g.dart`, `*.freezed.dart`, `lib/l10n/app_tr.arb`, gen-l10n çıktısı) kök `.ignore` dosyasıyla aramadan dışlanır ve elle düzenlenmez.
- Kod içinde Türkçe kavramın İngilizce karşılığı tutarlıdır: izin `leave`, yıllık izin hakkı `entitlement`, hak ediş `accrual`, köprü `bridge`, arife `eve`, resmî tatil `holiday`, kişi `profile`.

## Katman kuralları

- Bağımlılık yönü sadece aşağı doğrudur: `ui` → `domain` ve `data` arayüzleri. `domain` hiçbir katmanı import etmez.
- View sadece kendi view model'ini izler, iş kuralı içermez.
- Repository verinin tek kaynağı ve tek yazma yoludur, immutable domain modeli döner.
- Provider'lar arayüz tipinde tanımlanır. Gerçek implementasyon ve fake, `ProviderScope` override'ı ile değişir.

## Kod üretimi

- Kod üretimini sadece task 05 (`lib/domain/models/`) ve task 10 (`lib/data/database/`) çalıştırır, çünkü iki ajanın aynı anda `build_runner` çalıştırması çıktıları bozar.
- `build.yaml` her builder'ı `generate_for` ile kendi klasörüne sınırlar.
- Üretilen dosyalar commit'lenir. CI yeniden üretip fark olmadığını kontrol eder.

## Metinler

- Kullanıcıya görünen her metin ARB'dedir, Dart kodunda Türkçe metin yazılmaz.
- Her özellik kendi `lib/l10n/parts/<özellik>.arb` dosyasına yazar, anahtar özellik adıyla başlar (`homeTitle`). Böylece paralel ajanlar aynı dosyaya yazmaz.
- `dart run tools/merge_arb.dart` parçaları `app_tr.arb`'de birleştirir ve `flutter gen-l10n` çalıştırır. Aynı anda iki kez çalışsa da sonuç aynıdır.

## Paralel çalışma kuralları

- Her task sadece kendi klasörüne yazar. Ortak dosyalar (`lib/domain/models/`, `lib/ui/core/`, `lib/routing/`, `lib/app.dart`, `pubspec.yaml`, `build.yaml`, `android/app/build.gradle.kts`, `AndroidManifest.xml`) task 05 ve 06'da oluşturulur ve paralel aşamada değiştirilmez.
- Model veya arayüz değişikliği gerekiyorsa task sahibi değiştirmez, ihtiyacı task çıktısına yazar.
- Domain katmanı saf Dart'tır ve `flutter test` ile tek başına test edilir.
- Her task kendi testlerini `test/` altındaki karşılık gelen klasöre yazar.
- Her task bitince `flutter analyze` ve kendi testleri temiz geçmelidir.
- Kod, identifier, yorum ve commit mesajı English, kullanıcıya görünen metinler Türkçe.

## Kalite kapıları

- `.githooks/pre-commit`: gizli dosya ve büyük dosya kontrolü, kod üretimi ve ARB güncelliği, format, analyze, test.
- `.githooks/commit-msg`: tek satır Conventional Commits (English, en fazla 72 karakter, tipler: feat, fix, docs, test, refactor, perf, build, ci, chore, revert). Body, footer, `Co-authored-by` ve yapay zekâ imzası reddedilir.
- Kontroller `tools/checks/` altındaki script'lerdedir. Hook'lar ve CI aynı script'leri çağırır, böylece `--no-verify` ile atlanan kural CI'da yakalanır.
- CI: format, `flutter analyze --fatal-infos`, kod üretimi ve ARB güncelliği, `flutter test`, debug APK build, commit mesajı ve dosya kuralları.
