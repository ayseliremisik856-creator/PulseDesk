# Gerçek doğrulama kaydı — 19 Ekim 2026

Bu belge aşağıdaki **kod commit'i** için gözlenmiş sonuçları kaydeder; ilerideki sürümlere otomatik başarı atfetmez. Terminal çıktılarından ve resmî GitHub/Render API cevaplarından hazırlanmıştır; gizli anahtar veya veritabanı URL parolası içermez.

- Kod commit'i: `eafc01e0414c8a6b6bebddd00707c7e36ca5906c`.
- Yerel Windows / Ruby 4.0.7: `ruby bin/rails test` → **39 runs, 195 assertions, 0 failures, 0 errors, 0 skips**.
- Geliştirme ve test migration'ı başarıyla uygulandı. Zeitwerk ve üretim assets simülasyonu geçti. Gerçek master key ve encrypted credentials dosyalarının değişmediği hash karşılaştırmasıyla doğrulandı.
- [GitHub Actions koşusu 39176734173](https://github.com/ayseliremisik856-creator/PulseDesk/actions/runs/39176734173): **Rails tests (SQLite) success**; **Production build and PostgreSQL smoke (Linux) success**. İkinci iş gerçek PostgreSQL'de ortak politikayı ve geçmiş SLA korumasını rollback edilen transaction içinde denedi, assets üretti ve HTTP/CSS kontrolü yaptı.
- [Render deploy dep-dbaldbdg1s2s73bfs1e0](https://dashboard.render.com/web/srv-dbakkne1egvs73b330b0/deploys/dep-dbaldbdg1s2s73bfs1e0): **live**, bitiş **19 Ekim 2026 02:32:04 TRT**. `AddSharedSlaPolicies` migration'ı üretim PostgreSQL'de başarıyla uygulandı; servis/veritabanı silinmedi.

## Gerçek canlı HTTPS kontrolü

- `GET /` → **200**, PulseDesk dashboard işareti bulundu.
- `GET /up` → **200**.
- Sayfadan alınan derlenmiş CSS URL'si → **200**.
- Sentetik talep oluştur → ajan ata → aç → personel yanıtı/SLA → çöz akışı geçti. [Sentetik talep #2](https://pulsedesk-12n5.onrender.com/tickets/2) çözüldü olarak bırakıldı.
- İki sentetik marka, aynı politika kaydına bağlandı. Hedef tek işlemle **30 → 45 dakika** değiştirildi. İki markanın yeni talepleri de **45 dakika** aldı; önceden oluşturulan talep **30 dakika** kaldı. Talepler personel yanıtı verilerek çözüldü.
- Deploy'dan önce mevcut olan [talep #1](https://pulsedesk-12n5.onrender.com/tickets/1) hâlâ mevcut, solved ve kaydedilmiş hedefi **60 dakika**.
- Canlı talep metninde orijinal SaaS adı bulunmadı; uygulama kaynak/görünüm dosyalarında `rg -n -i zendesk app public config/routes.rb` eşleşme vermedi.
- Demo politika adı: **Ortak demo 233239**; [Ortak SLA ekranı](https://pulsedesk-12n5.onrender.com/sla_policies). İki demo markası bu politikaya bağlıdır; gerçek müşteri verisi kullanılmadı.

## Bilinen sınırlar

Canlı uzun süreli SLA ihlali için saat manipüle edilmedi veya beklenmedi; bu sınırlar gerçek `travel_to` otomatik testlerinde doğrulandı. Windows'taki önceki isteğe bağlı libvips DLL uyarıları sürüyor; testleri engellemedi. Tam Fortune 500 değerleme aralığı, gerçek toplam agent faturası, kişisel platform geçmişi ve Classroom teslimi doğrulanamadı; README'de eksik olarak yer alıyor.
