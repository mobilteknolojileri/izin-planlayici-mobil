# lib/ui

- `core/` task 06'ya aittir: tema (`theme/`) ve ortak bileşenler (`widgets/`). Ekranlar sadece bunları kullanır, kendi stilini icat etmez.
- `<özellik>/` task 11'e aittir: `widgets/<özellik>_screen.dart` ve `view_models/<özellik>_view_model.dart`. 11a ve 11b sadece kendi özellik klasörlerine yazar.
- Material import'u `package:material_ui/material_ui.dart`'tır, çünkü `package:flutter/material.dart` deprecated.
- View sadece kendi view model'ini izler, iş kuralı içermez. Hesaplar `lib/domain/`'den, veri provider'lar üzerinden (`lib/config/dependencies.dart`) gelir.
- Kullanıcıya görünen metin `lib/l10n/parts/<özellik>.arb` dosyasına yazılır, anahtar özellik adıyla başlar (`homeTitle`). Sonra `dart run tools/merge_arb.dart`.
- Her ekran için widget testi `test/ui/<özellik>/` altına yazılır.
