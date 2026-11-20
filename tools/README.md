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
- `input text` boşluk kabul etmez, boşluk yerine `%s` yazılır.
- Sistem dilini değiştirmeden bir uygulamayı Türkçe açmak için: `tr_locale <pkg>` (Android 13+ uygulama başına dil).
- Play'den kurulan uygulamalar split APK'dır. `pm path <pkg>` tüm parçaları listeler, hepsi çekilmelidir.
- `aapt2` için `build-tools` altındaki tam kurulu sürüm kullanılır, yarım kalmış klasörde `aapt2.exe` olmaz.
- WebView tabanlı uygulamaların metinleri de `ui` çıktısında görünür. Ekran görüntüsü okumak yerine önce `ui` kullanmak çok daha ucuzdur.
- Sistem tarih seçicide yıl başlığına dokununca yıl listesi açılır. Eski yıllar için listeyi yukarıdan aşağıya kaydırmak gerekir.

### Rakip uygulamalarla çalışırken

- Reklama tıklanmaz ve reklam izlenmez. Sekme değişince tam ekran reklam çıkabilir. `ui` çıktısında "Close", "Continue", "Skip" gibi bir buton aranıp ona dokunulur.
- Uygunsuz içerikli reklam ekran görüntüleri projeye kaydedilmez.
- Sistem izin pencereleri (konum vb.) "DON'T ALLOW" ile kapatılır. Bazı uygulamalar tekrar sorar, iki ret sonrası Android sormayı bırakır.
