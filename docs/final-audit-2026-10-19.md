# Son teslim kanıt denetimi — 19 Ekim 2026

Bu çalışma uygulama davranışını, migration'ları ve üretim verisini değiştirmez. README, araştırma kanıtları ve yerel kullanım denetim betiği güncellenmiştir. Son commit CI/deploy sonucu teslim mesajında ayrıca bildirilir; burada gelecekteki koşuya başarı yazılmaz.

## Araştırma kontrolü

- Fortune 2026 ABD listesi esas alındı. Tam veri ürünü vardır; dosyaya erişilmiş gibi davranılmadı. Tüm özel ve halka açık üyelerde karşılaştırılabilir değerleme bulunamadı. README'deki tarih eşlenmiş alt küme, bütün evrene genellenmez.
- İlk on şirketin tümü incelendi; aynı tarihteki beş kayıt sıralandı, diğer beş kayıt tarih nedeniyle dışlandı. Kaynaklar ve birimler README tablosunda. Bu en güçlü erişilebilir sınırlı alternatiftir; tam değerleme şartı halen eksik.
- Çalışan aralığı 2025 tarihli kaynaklı bulgudur; 2026 alt/üst sınırı değildir. SaaS portföyü ve harcama da açıkça tarihli Zylo örneklemidir; Fortune 500 ortalaması değildir. Bu kapsamlar öğretmenin 2026 tüm-evren ölçümü istemesi halinde yeterli sayılmaz.
- Stanley Black & Decker'ın Fortune üyeliği ile Zendesk'in tarihsel ticari ürün edinimi/kullanım vakası ayrı kaynaklarla desteklenir. [Resmî vaka PDF, sayfa 7](https://web-assets.zendesk.com/pdf/The_Zendesk_Customer_Experience_Trends_2019_How-To_Guide.pdf#page=7) yeniden açıldı. Kullanım ve ürün anlaşması var; fatura, ücret tutarı ve güncel abonelik yok. Kaynak bunları iddia etmek için kullanılmadı.
- [G2 yorum sayfası](https://www.g2.com/products/zendesk-for-customer-service/reviews#:~:text=Multi-Brand%20Support%20Made%20Simple) yeniden açıldı; README'de tanımlanan yorum ve marka kurallarını eşleme sorunu mevcut. Yorum doğrudan SLA eksikliği kanıtı değildir. Ortak SLA seçilmiş dar çözümdür; otomatik etiketleme yoktur.
- Zendesk monolitinin LOC beyanı [rubyday resmî programında](https://2024.rubyday.it/talks_speakers/) yeniden kontrol edildi; güncel tüm ürünün bağımsız ölçümü değildir.
- OpenAI Docs becerisiyle resmî model fiyatı ve abonelik/API ayrımı kontrol edildi. Yerel oturumdaki gerçek model kullanıldı; önceki temsili farklı model fiyatı kaldırıldı. Ham özel kayıtlar depoya taşınmadı. Sayılar [anonim özette](codex-usage-2026-10-19.json), yöntem [betikte](../script/audit_codex_usage.rb). Gerçek fatura halen yok.

## Gerçek yerel doğrulama

- `ruby bin/rails test`, `RAILS_ENV=test`, seed **30836**: **39 runs, 195 assertions, 0 failures, 0 errors, 0 skips**; 0,644897 saniye test koşusu. Bu süre geliştirme süresi değildir.
- `ruby bin/rails zeitwerk:check`: **All is good!**
- Windows libvips'in isteğe bağlı HEIF/JXL/ImageMagick/OpenSlide/Poppler eklentileri için yükleme uyarıları var. Testler sıfır çıkış koduyla tamamlandı; uyarılar gizlenmedi. Bu özellikler uygulamanın destek iş akışında kullanılmıyor.
- `test/models/ticket_test.rb`: oluşturma, new/open/solved, geri/atlamalı geçişler; `travel_to` ile tam sınır, geç yanıt ve kalıcı ihlal.
- `test/models/sla_policy_test.rb`: ortak hedef, iki markada yeni taleplere tutarlı uygulama, özel sınırda `travel_to`, geçmiş hedef/ihlal korunması ve geçiş kurallarının değişmemesi.
- `test/integration/ticket_workflow_test.rb` ve `test/integration/shared_sla_workflow_test.rb`: HTTP iş akışı ve politika ekranları.
- `AGENT.md` ve README Yapamadıklarım bölümü mevcut. CI rozeti `.github/workflows/ci.yml` adresine bağlıdır. Orijinal ürün markası uygulama ekranına eklenmedi.

Önceki gerçek üretim akışı ve iki markalı canlı kontrol kanıtı: [ilk doğrulama kaydı](verification-2026-10-19.md). Son teslim için yeni CI ve Render sonuçları son commit hash'i ile ayrıca kontrol edilir; yalnızca HTTP 200 sonucu uçtan uca akışın yeniden çalıştırılması diye raporlanmaz.
