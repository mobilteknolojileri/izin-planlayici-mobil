# Katkı rehberi

## Başlamadan önce

- Proje dokümanları [`docs/README.md`](docs/README.md) ile başlar: kapsam, tasarım ilkeleri, mimari ve görev listesi orada.
- Hesap kuralları sadece [`docs/mevzuat.md`](docs/mevzuat.md) dosyasından alınır. Kaynağı olmayan kural koda girmez. Yeni bir kural önerecekseniz resmî kaynağıyla birlikte issue açın.
- Kod, identifier, yorum ve commit mesajı English, kullanıcıya görünen metinler ve dokümanlar Türkçe yazılır.

## Kurulum

```sh
flutter pub get
git config core.hooksPath .githooks
```

İkinci komut commit kurallarını yerel olarak açar. Aynı kontroller CI'da da çalışır.

## Klasör yapısı

Yapı Flutter'ın resmî mimari rehberini izler, ayrıntısı [`docs/mimari.md`](docs/mimari.md) içinde.

- `lib/ui/<özellik>/`: ekran (`widgets/`) ve view model (`view_models/`)
- `lib/domain/`: saf Dart modeller ve hesap motorları, Flutter import edilmez
- `lib/data/`: repository'ler, veritabanı ve platform servisleri
- `lib/l10n/parts/<özellik>.arb`: o özelliğin Türkçe metinleri
- `test/`: `lib/` ile birebir aynı yapı

`lib/ui/`, `lib/domain/` ve `lib/data/` içindeki `CLAUDE.md` dosyaları o klasörün kurallarını kısaca anlatır.

## Kod üretimi ve metinler

```sh
dart run build_runner build      # modeller ve veritabanı değişince
dart run tools/merge_arb.dart    # bir .arb dosyası değişince
```

Üretilen dosyalar elle düzenlenmez ve commit'lenir. CI bunları yeniden üretip fark olmadığını kontrol eder.

## Commit kuralları

- Tek satır, English, [Conventional Commits](https://www.conventionalcommits.org/) biçiminde, en fazla 72 karakter: `feat(leaves): add half-day leave`
- Tipler: `feat`, `fix`, `docs`, `test`, `refactor`, `perf`, `build`, `ci`, `chore`, `revert`
- Body, footer, `Co-authored-by` satırı ve yapay zekâ imzası yazılmaz.
- İmza anahtarı (`key.properties`, `*.jks`), `local.properties`, `.env`, APK, AAB ve 5 MB üstü dosyalar commit'lenmez.
- Dosyalarda kişisel kullanıcı yolu (`C:\Users\<ad>`) bulunmaz, yerine `%USERPROFILE%` yazılır.

## Göndermeden önce

```sh
dart format lib test tools
flutter analyze --fatal-infos
flutter test
```

Hook'lar bu adımları her commit'te çalıştırır.
