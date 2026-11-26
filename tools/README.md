# Araçlar

## MuMu ile çalışma (`mumu.sh`)

Git Bash'te `source tools/mumu.sh` ile yüklenir. Fonksiyonlar: `mumu_start`, `ui`, `tap x y`, `shot dosya.png`, `txt`, `back`, `swipe_up`, `open_play <pkg>`, `launch <pkg>`, `tr_locale <pkg>`.

### Kurulum bilgisi

- MuMu yolu: `C:\Program Files\Netease\MuMuPlayer\nx_main\` (`MuMuManager.exe`, `adb.exe`).
- Instance 1 (`yeni-mumu`, Android 15, x86_64 + arm64 çeviri) kullanılır. Instance 0 (`eski-calismayan`) kullanılmaz.
- adb portu her açılışta değişebilir, sabit yazılmaz. `MuMuManager.exe info -v 1` çıktısındaki `adb_port` okunur, script bunu otomatik yapar.
- Play Store'da bir Google hesabı girişli. Uygulama kurmak için `open_play <pkg>`, sonra `ui` ile "Install" koordinatı bulunup `tap` yapılır.
- Ekran çözünürlüğü 900x1600. Koordinatlar bu ölçüdedir.

### Tuzaklar

- Tek adb kullanılır: Android SDK'daki (`platform-tools`). MuMu'nun kendi adb'si daha eski, ikisi karışırsa adb sunucusu sürekli yeniden başlar. Script SDK adb'sini seçer. mobile-mcp de PATH'teki SDK adb'sini kullanır.
- Git Bash `/sdcard/...` ve `/data/...` yollarını Windows yoluna çevirip komutu sessizce bozar. `MSYS_NO_PATHCONV=1` şarttır (script ayarlıyor).
- `adb pull` hedefi Windows yolu olmalı: `"$(cygpath -w "$hedef")"`.
- `uiautomator dump` her seferinde "Segmentation fault" yazar, dump yine de oluşur, zararsızdır.
- mobile-mcp kullanılırken `uiautomator dump` dosya üretmeyebilir ve `ui` boş döner. Bu durumda ekran mobile-mcp'nin `mobile_list_elements_on_screen` aracıyla okunur.
- `input text` Türkçe harf (ı, İ, ş) yazamaz. Türkçe metin mobile-mcp'nin `mobile_type_keys` aracıyla yazılır.
- `input text` boşluk kabul etmez, boşluk yerine `%s` yazılır.
- Sistem dilini değiştirmeden bir uygulamayı Türkçe açmak için: `tr_locale <pkg>` (Android 13+ uygulama başına dil).
- Play'den kurulan uygulamalar split APK'dır. `pm path <pkg>` tüm parçaları listeler, hepsi çekilmelidir.
- `aapt2` için `build-tools` altındaki tam kurulu sürüm kullanılır, yarım kalmış klasörde `aapt2.exe` olmaz.
- WebView tabanlı uygulamaların metinleri de `ui` çıktısında görünür. Ekran görüntüsü okumak yerine önce `ui` kullanmak çok daha ucuzdur.
- Sistem tarih seçicide yıl başlığına dokununca yıl listesi açılır. Eski yıllar için listeyi yukarıdan aşağıya kaydırmak gerekir.
- adb, MuMu'ya emülatörün Wi-Fi'si üzerinden bağlanır. Wi-Fi ve uçak modu adb ile kapatılmaz, çünkü adb kopar ve sonraki komut çalışmaz. Bu komutlar `MuMuManager.exe sh -v 1 -c "<komut>"` ile verilir.
- Bilgisayar ağ değiştirince MuMu eski DNS sunucusunda kalır ve sayfalar boş açılır. Wi-Fi `MuMuManager.exe sh` ile kapatılıp açılır, sonra adb yeniden bağlanır.
- Bilgisayar uykudan çıkınca MuMu'nun saati geride kalabilir ve Play "Authentication is required" der. `adb shell cmd network_time_update_service force_refresh` saati düzeltir.
- MuMu ara sıra kendi grafik modülünde (`libRenderer.dll`) çöküp kapanır, Windows olay günlüğüne `MuMuNxDevice.exe` hatası düşer. `MuMuManager.exe control -v 1 launch` ile tekrar açılır, uygulama verisi durur.
- Windows Defender'ın denetimli klasör erişimi açıkken MuMu, `Documents\MuMuSharedFolder` altına bağlı klasörlere (Download, Pictures) yazamaz. Dosya kaydetme testinde dosya seçicide cihaz hafızası ve Documents klasörü seçilir.

### Rakip uygulamalarla çalışırken

- Reklama tıklanmaz ve reklam izlenmez. Sekme değişince tam ekran reklam çıkabilir. `ui` çıktısında "Close", "Continue", "Skip" gibi bir buton aranıp ona dokunulur.
- Uygunsuz içerikli reklam ekran görüntüleri projeye kaydedilmez.
- Sistem izin pencereleri (konum vb.) "DON'T ALLOW" ile kapatılır. Bazı uygulamalar tekrar sorar, iki ret sonrası Android sormayı bırakır.

## TheClosedTest takası (`tct.sh`)

Git Bash'te repo kökünden `source tools/tct.sh` ile yüklenir, `mumu.sh`'yi kendisi yükler. Takas kuralları `docs/tasks/18-play-yukleme.md` içinde.

Fonksiyonlar:

- `tct_time`: Bilgisayarın saatini yazar. Takas günü Türkiye saatiyle 21:30'da kapanır.
- `tct_tests`: TheClosedTest'i Tests sekmesinde açar, günün özetini ve takas kartlarını yazar.
- `open_tct_task "<ad>"`: Takası Tests sekmesindeki tam adıyla açar.
- `show_partner_proof dosya.png`: Ortağın bekleyen kanıtına kaydırır ve ekran görüntüsünü bilgisayara kaydeder.
- `accept_proof`: Ekrandaki ortak kanıtını onaylar.
- `proof <ad>`: Ekranı cihazda `/sdcard/DCIM/TCT/<ad>.png` olarak kaydeder.
- `upload_here "<not>"`: En yeni görseli bugünün kanıtı olarak notla yükler. Nottaki boşluklar `%s` yazılır.
- `join_test <pkg>`: Chrome'da ortağın kapalı testine katılır.
- `install_app <pkg>`: Play Store'u yeniden başlatıp kurulumu başlatır.

Günlük akış:

1. `tct_time` ile saate bakılır.
2. `tct_tests` ile bekleyen takaslar listelenir.
3. Her takasta ortağın uygulaması `launch <pkg>` ile açılır, bir özelliği kullanılır ve ekran `proof <ad>` ile kaydedilir.
4. Takas `open_tct_task "<ad>"` ile açılır. "You need to approve" yazıyorsa kanıta `show_partner_proof` ile bakılır, gerçek kullanım varsa `accept_proof` çalıştırılır. Bu adım bekleyen her gün için tekrarlanır.
5. Kanıt `upload_here "<not>"` ile yüklenir.
6. Sonda `tct_tests` çıktısındaki "Completed Today" sayısı aktif takas sayısına eşit olmalıdır.

### Tuzaklar

- Saat düz `date` ile okunur, çünkü Git Bash'te saat dilimi veritabanı yok ve `TZ=Europe/Istanbul date` sessizce UTC yazar.
- Kanıtlar `/sdcard/DCIM/TCT` altına kaydedilir, çünkü `/sdcard/Pictures` MuMu'nun paylaşılan klasörüdür ve yazmayı reddeder.
- `proof`, `upload_here`'den hemen önce çalıştırılır, çünkü fotoğraf seçici en yeni görseli başa koyar ve `upload_here` ilk görseli seçer.
- `ui` çıktısı HTML karakterlerini korur. Adında `&` olan takas `"Fae &amp; Flame: Romantasy Color"` diye aranır.
- Eski kanıtı onaylanmamış takas, en eski bekleyen günle açılır. Onaylar bitmeden bugünün yükleme butonu görünmez.
- "Become a tester" adımından hemen sonra Play'in Install butonu bazen tepki vermez. `install_app` bu yüzden önce Play Store'u kapatır.
- Ortakların uygulamalarına erişilebilirlik gibi geniş izinler verilmez ve hesap açılmaz, çünkü cihazda Google hesabı açık. Giriş isteyen uygulamada giriş ekranının görüntüsü yüklenir.
- TheClosedTest bir uygulama için en fazla 12 takas kabul eder. Kontenjan dolunca yeni istekte "Capacity Reached" yazar.
