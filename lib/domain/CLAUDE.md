# lib/domain

- Saf Dart: Flutter ve `lib/data/`, `lib/ui/` import edilmez, çünkü motorlar `flutter test` ile tek başına test edilir.
- `models/` task 05'e aittir ve paralel aşamada değiştirilmez. İhtiyaç varsa task çıktısına not edilir. Modeller `freezed`, değiştikten sonra `dart run build_runner build`.
- `entitlement/` task 07, `day_count/` task 08, `bridge/` task 09. Her task `default_*.dart` dosyasındaki `UnimplementedError` gövdelerini doldurur, arayüz imzasını değiştirmez.
- Kurallar sadece `docs/mevzuat.md`'den alınır. `AppliedRule.legalReference` madde numarasını taşır.
- Tarihler UTC gece yarısı, sadece gün bilgisi (`DateTime.utc(y, m, d)`).
