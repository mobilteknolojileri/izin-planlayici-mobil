# lib/data

- `repositories/` ve `database/` task 10'a aittir. Repository verinin tek yazma yoludur ve domain modeli döner, `drift` tipleri bu klasörün dışına çıkmaz.
- `services/notifications/` task 12, `services/export/` task 13, `services/home_widget/` task 14. Her biri kendi arayüzünü implement eder, imzayı değiştirmez.
- Beklenen hatalar `Result` (`lib/utils/result.dart`) ile döner, programlama hataları throw eder.
- `fakes/` task 05'e aittir: gerçek implementasyonlar gelene kadar uygulamanın kullandığı sahte veri. Task 16 provider'ları gerçeklere çevirir.
- `AndroidManifest.xml` ve `build.gradle.kts` paralel aşamada değiştirilmez, eksik ayar task çıktısına not edilir.
