# 05 Flutter iskeleti ve ortak sözleşmeler

Bağımlılık: 02, 03 ve 04 bitmiş olmalı. Bu task paralel aşamadan önce tek başına yapılır. Klasör yapısı ve kurallar `docs/mimari.md` içinde.

Durum: tamamlandı. MuMu'da beş sekme gezildi, analyze ve 15 test temiz, repo GitHub'da public, CI yeşil. Arayüz imzaları kodda (`lib/domain/`, `lib/data/`), task 07-14 bunları değiştirmez.

## Amaç

Paralel task'ların birbirini beklemeden çalışabilmesi için projeyi, ortak modelleri, arayüzleri ve kalite kapılarını kurmak.

## Yapılacaklar

### Proje

1. Kök klasörde `flutter create --org com.izinplanla --project-name izin_planla --platforms android .` ve `applicationId`'yi `com.izinplanla.app` yap.
2. `.gitignore`: Flutter'ın standart girdileri korunur, `rakipler/`, `.tooling/`, `.claude/settings.local.json`, `key.properties`, `*.jks` ve `*.keystore` eklenir. Üretilen Dart dosyaları ignore edilmez.
3. `docs/araclar.md` içindeki tüm paketleri `pubspec.yaml`'a ekle, `flutter pub get`.
4. `analysis_options.yaml`: `very_good_analysis` + strict mod (`strict-casts`, `strict-inference`, `strict-raw-types`). Üretilen dosyalar analyzer'dan, `.tooling/` her şeyden hariç.
5. `build.yaml`: `freezed` ve `json_serializable` sadece `lib/domain/models/**`, `drift_dev` sadece `lib/data/database/**` için çalışır.
6. Kök `.ignore`: `*.g.dart`, `*.freezed.dart`, `lib/l10n/app_tr.arb`, gen-l10n çıktısı ve `.tooling/`, aramadan dışlanır.

### Modeller ve arayüzler

7. `lib/domain/models/` altında `freezed` modeller: `Profile` (kişi), `WorkSchedule`, `EmploymentType`, `LeaveRecord`, `LeaveType`, `OvertimeRecord`, `Holiday`, `HolidayType`, `Entitlement`, `EntitlementPeriod`, `AppliedRule` (kural + madde numarası), `DayBreakdown`, `BridgeSuggestion`, `AppSettings`. JSON serileştirme dâhil. Alanlar `docs/kapsam.md` bölüm 1 ve 3'teki tüm girdileri karşılar. `build_runner` bir kez çalışır, çıktı commit'lenir.
8. Arayüzler (sadece imza, gövde `UnimplementedError`):
   - `EntitlementCalculator` (task 07), `lib/domain/entitlement/`
   - `LeaveDayCounter`, `BalanceCalculator`, `SplitRuleChecker` (task 08), `lib/domain/day_count/`
   - `BridgePlanner` (task 09), `lib/domain/bridge/`
   - `ProfileRepository`, `LeaveRepository`, `OvertimeRepository`, `SettingsRepository`, `HolidayRepository`, `BackupCodec` (task 10), `lib/data/repositories/`
   - `NotificationService` (task 12), `ExportService` (task 13), `HomeWidgetService` (task 14), `lib/data/services/`
9. Her arayüz için ekranların kullanacağı fake implementasyon ve örnek veri: `lib/data/fakes/`.
10. Riverpod provider'ları arayüz tipinde tanımla. Uygulama başlangıçta fake'leri kullanır, task 16 gerçek implementasyonlara geçirir.

### UI iskeleti

11. `lib/app.dart`: geçici tema, `tr` locale, `localizationsDelegates`. Tema task 06'da değiştirilir.
12. `lib/routing/`: `go_router`, alt menü (Ana Sayfa, İzinlerim, Takvim, Köprü, Ayarlar) ve `docs/mimari.md`'deki her özellik klasörü için route.
13. `lib/ui/<özellik>/` altında her ekran için boş `widgets/<özellik>_screen.dart` ve `view_models/<özellik>_view_model.dart`.
14. Metinler: `l10n.yaml`, `lib/l10n/parts/common.arb` (ortak metinler), `tools/merge_arb.dart` (parçaları birleştirir, atomik yazar, `flutter gen-l10n` çalıştırır).
15. `lib/ui/CLAUDE.md`, `lib/domain/CLAUDE.md`, `lib/data/CLAUDE.md`: her biri en fazla 15 satır, klasörün kuralları ve hangi task'ın hangi alt klasöre yazdığı.

### Android

16. `minSdk 24` (Flutter 3.50.1'in alt sınırı), `targetSdk 36` (Play şartı), `compileSdk 37` (`flutter_local_notifications` şartı), uygulama adı "İzin Planla", `INTERNET` izni release manifest'te yok. `ndkVersion` Flutter'ın beklediği `28.2.13676358` kalır, `ndkPath` proje içindeki `.tooling/ndk/28.2.13676358` klasörünü gösterir (bkz. `docs/araclar.md`).
17. Ortak Android dosyaları burada tamamlanır, çünkü paralel task'lar `AndroidManifest.xml` ve `build.gradle.kts`'e yazmaz:
    - `flutter_local_notifications` için core library desugaring (`isCoreLibraryDesugaringEnabled`, `desugar_jdk_libs`), `POST_NOTIFICATIONS` ve `RECEIVE_BOOT_COMPLETED` izinleri, paketin README'sindeki receiver'lar. `SCHEDULE_EXACT_ALARM` ve `USE_EXACT_ALARM` eklenmez.
    - Task 14 için widget receiver satırı ve derlenen boş taslaklar: Kotlin widget provider sınıfı, `res/xml/` altında widget bilgisi, `res/layout/` altında yerleşim.

### Kalite kapıları

18. `tools/checks/` altında script'ler. Hook'lar ve CI aynı script'leri çağırır:
    - `commit_message.sh`: tek satır, `^(feat|fix|docs|test|refactor|perf|build|ci|chore|revert)(\([a-z0-9_-]+\))?: .+`, en fazla 72 karakter. İkinci satır varsa, `Co-authored-by` veya yapay zekâ imzası ("Generated with", "Claude", "Copilot" vb.) geçerse reddeder.
    - `forbidden_files.sh`: `key.properties`, `*.jks`, `*.keystore`, `.env*`, `local.properties`, `*.apk`, `*.aab` ve 5 MB üstü dosyaları reddeder.
    - `quality.sh`: `dart format --set-exit-if-changed`, `flutter analyze --fatal-infos`, `flutter test`.
    - `generated_fresh.sh`: `build_runner` ve `merge_arb.dart` yeniden çalışınca `git diff --exit-code`.
19. `.githooks/pre-commit` (`forbidden_files.sh` + `quality.sh`) ve `.githooks/commit-msg` (`commit_message.sh`).
20. `.github/workflows/ci.yml`: Flutter 3.50.1 sabit, push ve pull request'te tüm `tools/checks/` script'leri, `flutter build apk --debug`. Commit mesajı kontrolü push'taki tüm commit'lere uygulanır.
21. Açık kaynak dosyaları: `LICENSE` (GPL-3.0 tam metni), kısa `README.md` (Türkçe, altında kısa English özet, lisans, gizlilik ilkesi, derleme adımları), `CONTRIBUTING.md` (hook kurulumu, commit kuralları, klasör yapısı, `docs/` yönlendirmesi).
22. Git komutlarını kullanıcı çalıştırır. Task sonunda tek PowerShell bloğu verilir: `git init -b main`, `git config core.hooksPath .githooks`, ilk commit, `gh repo create` ile public repo ve push.

### Doğrulama

23. `flutter analyze` temiz, `flutter test` geçiyor, `flutter build apk --debug` başarılı.
24. Hook'lar elle denenir: hatalı mesaj, `Co-authored-by` satırı ve `key.properties` içeren commit reddediliyor.

## Çıktı

Derlenen boş uygulama, tüm modeller, arayüzler, fake'ler ve kalite kapıları. Paralel task'lar sadece implementasyon yazar.

## Kabul

- MuMu'da açılıyor, tüm sekmeler boş sayfa olarak geziliyor.
- `flutter analyze` sıfır uyarı.
- Hook'lar kural dışı commit'i reddediyor.
- Commit'e girecek dosyaların içeriğinde kişisel yol ve e-posta, repoda `rakipler/` içeriği yok.
