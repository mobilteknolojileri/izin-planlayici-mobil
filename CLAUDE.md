# İzin Planla

Türkiye'deki çalışanlar için yıllık izin hesaplama, izin takibi ve köprü tatil planlama uygulaması (Flutter, Android).

## Başlarken

- İşe `docs/README.md` ile başla: klasörler, görev sırası ve kurallar orada.
- Sıradaki görevi `docs/tasks/` altındaki dosyaların "Durum" satırlarından bul. Durum satırı olmayan görev başlamamıştır.
- Bir görev bitince o görev dosyasındaki "Durum" satırını güncelle, çünkü sonraki oturumlar ilerlemeyi oradan okur.

## Kurallar

- Plugin, MCP server, Flutter paketi veya sistem aracı kurmadan önce kullanıcıya sor, çünkü kullanıcı her kurulumu onaylamak istiyor.
- Kurulum öncesi plugin'in hook, MCP ve script içeriğini oku, bulguyu `docs/araclar.md`'ye yaz, çünkü incelenmemiş plugin'ler ana ajanı değiştirebiliyor veya dış servise bağlanabiliyor.
- Hesap kuralları sadece `docs/mevzuat.md`'den alınır, çünkü rakip uygulamalar kanun sınırlarını yanlış uyguluyor.
- Ekranlar `docs/tasarim.md` ilkelerine ve task 06 bileşenlerine uyar, çünkü hedef kullanıcı uygulama kullanmayı iyi bilmiyor.
- Paralel subagent çalışmasında `docs/mimari.md` içindeki yazma alanı kuralları geçerlidir, çünkü ortak dosyaya iki ajan yazarsa çakışma olur.
- Kod, identifier, yorum ve commit mesajı English, kullanıcıya görünen metinler ve dokümanlar Türkçe.
- Repoya yazılan Türkçe metin (doküman, `CLAUDE.md`, ARB, store metni) `/turkce-yazim` skill'i ile yazılır veya düzeltilir, çünkü metinler TDK'ya ve kullanıcının yazım profiline uymalı. Sık hatalar: resmî, dinî, akdî, dâhil, tarih bildirmeyen gün adları küçük harf (cumartesi), "yalnızca" yerine "sadece".
- Commit mesajı tek satır Conventional Commits, en fazla 72 karakter. Body, `Co-authored-by` ve yapay zekâ imzası yazılmaz, çünkü `commit-msg` hook'u ve CI reddeder.
- Kullanıcıya görünen metin Dart koduna yazılmaz, `lib/l10n/parts/<özellik>.arb` dosyasına yazılır, çünkü metinler tek yerden denetlenir.
- Rakip uygulamalardan (`rakipler/`) metin, ikon ve görsel kopyalanmaz, çünkü sadece özellik ve hata analizi için tutuluyorlar.
- Repo public ve GPL-3.0. Dosya içeriğine kişisel yol ve e-posta yazılmaz, `rakipler/` commit'lenmez, çünkü git geçmişi geri alınamaz. Commit yazarı olarak global git e-postası kullanılır.

## Ortam

- Flutter 3.50.1 ve Android SDK sürümleri `docs/araclar.md` içinde.
- MuMu ve adb kullanımı `tools/README.md` içinde. Tek adb kullanılır: Android SDK'daki.
- Proje kapsamındaki plugin'ler `.claude/settings.json`, MCP server'lar `.mcp.json` içinde.
