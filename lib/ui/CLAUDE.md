# lib/ui

- `core/` task 06'ya aittir: tema (`theme/`) ve ortak bileşenler (`widgets/`). Ekranlar sadece bunları kullanır, kendi stilini icat etmez.
- `<özellik>/` task 11'e aittir: `widgets/<özellik>_screen.dart` ve `view_models/<özellik>_view_model.dart`. 11a ve 11b sadece kendi özellik klasörlerine yazar.
- Renk, boşluk, köşe ve süre `lib/ui/core/theme/` dışında sabit değer olarak yazılmaz. Renk `Theme.of(context).colorScheme` veya `AppColors.of(context)`, boşluk `AppSpacing`, köşe `AppRadius` ve `AppShapes`, süre `AppMotion` ile okunur, çünkü kontrast testleri sadece tema renklerini kapsar.
- İzin, tatil, arife ve hafta sonu gibi anlamlar `Meaning` ve `MeaningTile` ile gösterilir, çünkü renk tek başına anlam taşımaz, her anlamın ikonu, metin taşımayan işaretlerde deseni de vardır.
- Tarih ve gün sayısı `AppFormat` ile biçimlenir: "20 Kasım 2026, Cuma", "4,5".
- Görünüm iOS düzenindedir: sekme ekranı için `LargeTitlePage`, kart için `InsetCard`, büyük sayı için `BigNumberCard`, alt menü `AppTabBar`. Sekmelerin üstüne açılan ekranlar geri butonlu `AppBar` kullanır. Köşeler `AppShapes` ile superellipse çizilir, ikonlar `LucideIcons`'tan gelir, çünkü tek ikon seti ve tek köşe biçimi kullanılır.
- Yapay zekâ ürünlerini çağrıştıran süs ikonları (sparkles, konfeti, yıldız) kullanılmaz. Her ikon bir anlam taşır, çünkü uygulama hazır şablondan çıkmış gibi görünmemeli.
- Web linkleri `LinkButton` ile tarayıcıda açılır. Açılamazsa link kopyalanır ve kullanıcıya söylenir, çünkü kaynak her zaman ulaşılabilir olmalı.
- Bileşenler debug build'de galeri ekranında görülür: `flutter run --dart-define=START_ROUTE=/gallery` (Git Bash'te önüne `MSYS_NO_PATHCONV=1`). Golden'lar `test/ui/core/widgets/goldens/` altındadır, CI sadece `ci/` klasörünü karşılaştırır. Her golden %100, doğrusal %200 ve Android %200 yazı boyutunda çizilir, çünkü doğrusal ölçek cihazdaki taşmaları kaçırdı.
- Material import'u `package:material_ui/material_ui.dart`'tır, çünkü `package:flutter/material.dart` deprecated.
- View sadece kendi view model'ini izler, iş kuralı içermez. Hesaplar `lib/domain/`'den, veri provider'lar üzerinden (`lib/config/dependencies.dart`) gelir.
- Kullanıcıya görünen metin `lib/l10n/parts/<özellik>.arb` dosyasına yazılır, anahtar özellik adıyla başlar (`homeTitle`). Sonra `dart run tools/merge_arb.dart`.
- Her ekran için widget testi `test/ui/<özellik>/` altına yazılır.
