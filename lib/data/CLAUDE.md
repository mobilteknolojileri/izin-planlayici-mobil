# lib/data

- `repositories/` ve `database/` task 10'a aittir. Repository verinin tek yazma yoludur ve domain modeli döner, `drift` tipleri bu klasörün dışına çıkmaz.
- `services/notifications/` task 12, `services/export/` task 13, `services/home_widget/` task 14. Her biri kendi arayüzünü implement eder, imzayı değiştirmez.
- `services/links/` linki tarayıcıda açar, `services/app_info/` kurulu sürümü okur. İkisi de task 16'da eklenen ince plugin sarmalayıcılarıdır.
- Beklenen hatalar `Result` (`lib/utils/result.dart`) ile döner, programlama hataları throw eder.
- `fakes/` task 05'e aittir: testlerin kullandığı örnek veri. Testler bunları `test/config/fake_dependencies.dart` içindeki `withFakeDependencies` ile bağlar. Fake'ler release build'e girmez.
- `AndroidManifest.xml` ve `build.gradle.kts` paralel aşamada değiştirilmez, eksik ayar task çıktısına not edilir.
