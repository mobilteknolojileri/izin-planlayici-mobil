# Araçlar, plugin'ler ve paketler

Task 04 çıktısı. Kurulumlar proje kapsamındadır (`.claude/settings.json`, `.mcp.json`), kullanıcı geneli ayarlara yazılmaz. Her kurulumdan önce kullanıcı onayı alınır.

## Geliştirme ortamı

| Araç | Sürüm | Not |
|---|---|---|
| Flutter | 3.50.1 stable | `%USERPROFILE%\develop\flutter`, `flutter doctor` sorunsuz |
| Dart | 3.14.0 | Flutter ile gelir |
| JDK | 17.0.21 (Microsoft), JBR 21.0.6 | `JAVA_HOME` 17.0.21'i gösterir. Flutter build'leri `flutter config --jdk-dir` ile ayarlı JBR 21'i kullanır (`%USERPROFILE%\develop\Android\jbr`) |
| Android SDK platform | 36, 37.0 | |
| Build-tools | 35.0.0, 35.0.1, 36.0.0, 37.0.0 | Yarım kalmış kurulumda `aapt2.exe` olmaz, tam kurulu sürüm kullanılır |
| Platform-tools (adb) | 37.0.3 | MuMu'nun kendi adb'si eski, ikisi karışırsa adb sunucusu yeniden başlar. Tek adb kullanılır: SDK'daki |
| cmdline-tools | 23.0 | `sdkmanager` deprecated, ilk çalışmada Android CLI'ı `~/.android/bin` altına indirir ve onun üzerinden çalışır. Android CLI kullanım verisi toplar, kapatmak için `--no-metrics` |
| Emulator | 37.3.10 | Testler MuMu'da yapılır, Android emülatörü yedek |
| NDK | 28.2.13676358 (r28c) | Proje içinde `.tooling/ndk/28.2.13676358`, global SDK'ya kurulmaz çünkü PC geneli değişmemeli. `android/build.gradle.kts` bu klasörü bütün modüllere `ndkPath` olarak verir ve Flutter plugin'inin `sdkmanager` ile global SDK'ya NDK kurmasını kapatır. Klasör yoksa (CI) normal davranış geçerlidir. Global SDK'daki `ndk/30.0.16248370` yarım kurulumdur, kullanılmaz |
| Android hedefleri | minSdk 24, targetSdk 36, compileSdk 37 | minSdk Flutter 3.50.1'in alt sınırı, targetSdk Play'in 31.8.2026'dan beri istediği düzey, compileSdk `flutter_local_notifications` 23'ün şartı |
| AGP, Gradle | 9.3.1, 9.5.0 | `flutter create` şablonundan |

## Kurulu Claude Code plugin'leri (proje)

| Plugin | Kaynak | İnceleme | İçerik | Doğrulama |
|---|---|---|---|---|
| Dart and Flutter (`dart-flutter`) | flutter/agent-plugins | Partner incelemeli | 25 skill + Dart MCP server | MCP bağlandı |
| Flutter Skills (`flutter`) | zakariaf/flutter-skills | İncelenmemiş, içerik okundu: sadece skill ve yerel script | 40 skill (Riverpod 3, test, kalıcı veri, erişilebilirlik, i18n) | Skill'ler yüklendi |
| Design (`design`) | anthropics/knowledge-work-plugins | Anthropic incelemeli | 7 skill: erişilebilirlik incelemesi, tasarım eleştirisi, design system, UX metni, handoff, araştırma | Skill'ler yüklendi. Ekledikleri 9 dış MCP (Slack, Figma, Notion vb.) `.claude/settings.json` içindeki `deniedMcpServers` ile engellendi |
| UXKIN (`uxkin`) | uxkin/agent | İncelenmemiş, içerik okundu | `no-ui-slop` skill + uxkin.com MCP | Skill yüklendi, MCP hesap girişi ister |
| Playcut Brush (`brush`) | mehrang0/playcut-brush | İncelenmemiş, içerik okundu: sadece 127.0.0.1'de yerel sunucu | SVG çizim skill'i | Skill yüklendi |
| Mobile Release Check | petrovicistefan/claude-code-plugins | İncelenmemiş, içerik okundu: yerel Python script, ağ yok | 3 skill: yayın öncesi kontrol | Skill'ler yüklendi |
| app-preview-craft | imshaikot/app-preview-craft-skill | İncelenmemiş, içerik okundu: yerel Chrome, three.js, ffmpeg | Store görseli ve cihaz mockup üretimi | Skill yüklendi, ilk kullanımda npm bağımlılıkları iner |

Önceden kullanıcı geneline kurulu olanlar: context7, playwright, typescript-lsp, rust-analyzer-lsp.

## Proje MCP server'ları

| Server | Komut | Not |
|---|---|---|
| mobile-mcp | `npx -y @mobilenext/mobile-mcp@1.0.18` | Sürüm sabit. Projede `claude` ilk açıldığında kullanıcı onayı ister |
| dart-mcp-server | `dart mcp-server` | Dart and Flutter plugin'i ile gelir |

## Elenenler

| Aday | Neden |
|---|---|
| UI Color Palette | Proje ayarına `"agent": "uicper"` yazıp ana ajanı değiştiriyor, GitHub ve GitLab dâhil 8 uzak MCP ekliyor. Kullanıcı kurmamayı seçti |
| kotlin-lsp | `kotlin-lsp` programı gerektiriyor, Kotlin sadece küçük bir widget dosyası |
| Very Good Ventures plugin'i | Hook'ları `flutter create` ve `flutter test`'i engelliyor, BLoC öneriyor. Kullanıcı Riverpod ile devam etmeyi seçti |
| dagovalsusa/claude-flutter-skills | 1 yıldız, 8 aydır güncellenmemiş, zakariaf ile örtüşüyor |
| Oh My Android | Sadece macOS |
| Android Emulator QA (ceabarr) | 0 yıldız, mobile-mcp aynı işi daha olgun yapıyor |
| appstore-screenshots (ntgussoni) | Expo ve React Native için |
| Icon Creator | Android adaptive ikon üretmiyor, `flutter_launcher_icons` bu işi yapıyor |
| Streamline Icons | Kullanıcı seçmedi |
| Mobbin, Appllama | Ücretli hesap gerektiriyor |
| Figma, Canva | Projede tasarım dosyası yok |

## Flutter paketleri (task 05'te eklenecek)

| Paket | Sürüm | Amaç |
|---|---|---|
| flutter_riverpod | 3.5.0 | State |
| go_router | 18.1.4 | Yönlendirme |
| intl | 0.20.3 | Tarih, Türkçe yerelleştirme |
| path_provider | 2.1.6 | Dışa aktarma için geçici dosya konumu |
| drift, drift_flutter | 2.35.4, 0.3.1 | Cihazda SQLite veritabanı, migration ve transaction |
| freezed_annotation, json_annotation | 3.1.0, 4.12.0 | Immutable modeller ve JSON |
| flutter_localizations | SDK | gen-l10n çıktısı için. Material metinleri `material_ui`'nin `GlobalMaterialLocalizations.delegates`'inden gelir |
| material_ui | 1.11.1 | Material bileşenleri. `package:flutter/material.dart` Flutter 3.47'den beri deprecated. `table_calendar`, `fl_chart` ve `printing` hâlâ eskisini kullandığı için `app.dart`'ta `MaterialUiCompatibilityBridge` var |
| table_calendar | 3.3.0 | Takvim |
| flutter_local_notifications | 23.0.3 | Bildirim |
| timezone | 0.11.2 | Bildirim saat dilimi |
| home_widget | 0.10.0 | Ana ekran widget'ı |
| pdf, printing | 3.13.1, 5.15.1 | PDF |
| archive | 4.7.1 | Excel (xlsx) dosyasını kendimiz üretmek için. `excel` paketi 2024'ten beri güncellenmemiş, Syncfusion lisansı kısıtlı |
| share_plus | 13.3.1 | Paylaşım |
| file_picker | 13.4.0 | Yedek geri yükleme |
| fl_chart | 1.3.1 | İstatistik grafikleri |
| flutter_svg | 2.5.0 | İllüstrasyonlar |
| flutter_animate | 4.5.2 | Kodla animasyon (kullanıcı onayladı) |
| animations | 3.0.0 | Material ekran geçişleri (kullanıcı onayladı) |
| very_good_analysis | 11.0.0 | Sıkı lint kuralları |
| mocktail | 1.0.5 | Test mock'ları |
| alchemist | 0.15.0 | Golden testler |
| flutter_launcher_icons, flutter_native_splash | 0.14.4, 2.4.8 | İkon ve açılış ekranı |
| build_runner, freezed, json_serializable, drift_dev | 2.17.1, 4.0.3, 6.15.2, 2.35.3 | Kod üretimi (dev_dependencies). build_runner 2.17'de `--delete-conflicting-outputs` kaldırıldı, sadece `dart run build_runner build` |

Kod üretimini sadece task 05 (modeller) ve task 10 (veritabanı) çalıştırır, çünkü iki ajanın aynı anda `build_runner` çalıştırması çıktıları bozar. Builder'lar `build.yaml` içinde `generate_for` ile kendi klasörlerine sınırlanır. Üretilen dosyalar commit'lenir, CI güncel olduklarını kontrol eder.
