# PulseDesk — Ödev 3: Fortune 500 SaaS aort dilimi

[![CI](https://github.com/ayseliremisik856-creator/PulseDesk/actions/workflows/ci.yml/badge.svg)](https://github.com/ayseliremisik856-creator/PulseDesk/actions/workflows/ci.yml)

- **Canlı:** https://pulsedesk-12n5.onrender.com
- **GitHub:** https://github.com/ayseliremisik856-creator/PulseDesk
- **Sağlık:** https://pulsedesk-12n5.onrender.com/up
- **Ajan rehberi:** [AGENT.md](AGENT.md)
- **Teslim:** 19 Ekim 2026 Pazartesi; ders saatinden önce Classroom'a canlı ve repo bağlantıları girilmeli. Classroom teslimi bu depodan yapılamaz.

Özgün ürün adı ve metin logosu PulseDesk'tir. İlham alınan kurumsal ürün Zendesk; onun adı/logosu uygulama ekranlarında kullanılmaz. Bu çalışma tam ürün klonu değil, çalışan bir müşteri destek aort dilimidir: **talep oluştur → ajan ata → aç → personel yanıtı → çöz**. Rails 8.1.4 / Ruby 4.0.7; yerelde/testte SQLite, Render'da PostgreSQL. Bireysel ödev, coding agent yardımıyla geliştirilmiştir; başka öğrenci katkısı iddia edilmez.

## Faz 1 — Kurumsal ölçek ve satın alma kanıtı

Araştırma tarihi: **19 Ekim 2026**. Esas evren **2026 ABD Fortune 500**; Global 500 değildir. Liste **ciroya göre** sıralanır; halka açık ve özel şirketleri kapsar. [Fortune açıklaması](https://fortune.com/article/what-is-a-fortune-500-company-the-story-behind-the-list/) Tarihli 2025 çalışan/SaaS araştırması aşağıda tarihsel veri olarak ayrıca etiketlenmiştir.

| İstenen ölçü | Doğrulanan sayı / kapsam | Kaynak |
| --- | --- | --- |
| Çalışan aralığı, 2025 | A-Mark **486** — Walmart yaklaşık **2.100.000** | [Fortune, 2 Haziran 2025](https://fortune.com/2025/06/02/fortune-500-employees-headcount-workforce-largest-smallest/) |
| Tüm 2026 Fortune 500'ün karşılaştırılabilir değerleme min–max aralığı | **Doğrulanamadı.** Aşağıdaki beş şirketlik aynı tarihli alternatif tüm evrenin minimum/maksimumu değildir. | [2026 liste](https://fortune.com/ranking/fortune500/) · [Veri ürünü](https://dc.fortune.com/analytics/fortune-500) |
| Bir kuruluşun SaaS portföyü | Ortalama **275 uygulama**, 2025 raporunun örneklemi | [Zylo, 2025 bulguları](https://zylo.com/blog/prioritizing-saas-management-in-2025-focus-on-these-3-things) |
| Yıllık SaaS harcaması | Ortalama **49 milyon USD/yıl**, aynı örneklem | [Zylo, 2025 bulguları](https://zylo.com/blog/prioritizing-saas-management-in-2025-focus-on-these-3-things) |

Çalışan aralığı kaynak yazının 2025 evrenine aittir; 2026 çalışan minimumu olarak sunulmaz. **Piyasa değeri = hisse fiyatı × toplam hisse sayısı.** Firma değeri (enterprise value), ciro ve marka değeri farklı ölçülerdir; hesapta kullanılmadı. SEC'in yalnızca non-affiliate hisseler için bildirdiği değer de tüm şirketin piyasa değeri kabul edilmedi.

### 2026 değerleme veri kümesi araştırması ve sınırlı alternatif

Fortune Analytics, 2026 tam veri ürününde market value alanını listeliyor. Bu, özel şirketlerin de aynı yöntemle değerlenmiş olduğu veya boş alan bulunmadığı kanıtı değildir. Satın alınmış veri dosyasına erişilmedi; bir veri ürünü bulunamadı demiyoruz. **Tüm 500 şirketi aynı tarihte ve aynı tanımla değerleyen erişilebilir bir veri kümesi doğrulanamadı.** Özel şirketlerde borsa piyasa değeri yoktur; boş değerler sıfır sayılamaz. [Fortune Analytics veri kapsamı](https://dc.fortune.com/analytics/fortune-500) · [Şirket kapsamı](https://dc.fortune.com/analytics/faq)

Üçüncü taraf [US500](https://us500.com/fortune-500-companies) yalnızca halka açık şirketleri içerdiğini söylüyor; açık tablosunda karşılaştırılabilir piyasa değeri sütunu bulunmuyor. [Databahn](https://www.databahn.com/products/2026-fortune-500-list-excel-spreadsheet-list-download-bogo-offer) market cap sütunlu ticari ürün sunuyor; dosyası alınmadığı ve ortak değerleme tarihi doğrulanmadığı için minimum hesabında kullanılmadı. Ücretli veri satın alınmadı, erişim engeli aşılmadı.

**Açıkça tanımlanan dar kapsam:** 2026 listesinin ciro bakımından ilk on şirketinin açık Fortune profilleri incelendi; bunların içinde piyasa değeri tarihi **18 Ağustos 2026** olan halka açık şirketlerin **tamamı** alındı. Tarih, bu profillerde ortak olan en kalabalık grup olduğu için seçildi; önceden kaydedilmiş bir araştırma protokolü değildir. Bu seçim bir kolaylık örneklemidir; tüm halka açık Fortune 500 şirketlerini temsil etmez. Tarih eşleme sonucunda beş kayıt kaldı. Aşağıdaki her değer şirket profilindeki USD milyon alanından alınmıştır; diğer beş şirket de dışlama tablosunda gösterilir.

| Dahil edilen şirket | Piyasa değeri (milyon USD), 18 Ağustos 2026 | Doğrudan kaynak |
| --- | ---: | --- |
| UnitedHealth Group | 353.590 | [UNH](https://fortune.com/company/unitedhealth-group/) |
| Exxon Mobil Holdings | 680.768 | [XOM](https://fortune.com/company/exxon-mobil/) |
| Walmart | 916.771 | [WMT](https://fortune.com/company/walmart/) |
| Amazon | 2.798.509 | [AMZN](https://fortune.com/company/amazon-com/) |
| Alphabet | 4.193.427 | [GOOGL](https://fortune.com/company/alphabet/) |

Bu **beş kayıt karşılaştırıldığında** alt sınır UnitedHealth Group **353,590 milyar USD**, üst sınır Alphabet **4,193427 trilyon USD** olur; birim dönüşümü milyon USD / 1.000 = milyar USD'dir. Bu sadece tanımlanan alt kümenin aralığıdır. Fortune 500'ün veya bütün halka açık üyelerinin minimum/maksimumu olduğu iddia edilmez. Apple/Nvidia gibi kapsam dışı şirketlerden daha büyük/küçük bir değer çıkması bu sınırlı hesabı değiştirmez.

| İlk on içindeki dışlanan şirket | Profildeki piyasa değeri tarihi | Kaynak |
| --- | --- | --- |
| Apple | 16 Ağustos 2026 | [AAPL](https://fortune.com/company/apple/) |
| CVS Health | 13 Temmuz 2026 | [CVS](https://fortune.com/company/cvs-health/) |
| Berkshire Hathaway | 13 Temmuz 2026 | [BRK.A](https://fortune.com/company/berkshire-hathaway/) |
| McKesson | 13 Temmuz 2026 | [MCK](https://fortune.com/company/mckesson/) |
| Cencora | 13 Temmuz 2026 | [COR](https://fortune.com/company/amerisourcebergen/) |

İlk on üyeliği [2026 resmî sıralamasından](https://fortune.com/ranking/fortune500/) kontrol edildi. Açık profiller zamanla güncellenir: burada veri erişim tarihi ile piyasa değeri tarihi ayrıdır. **Ödevin bütün evren için en küçük–en büyük şartı halen eksiktir.** En güçlü sonraki adım, lisanslı 2026 dosyasının halka açık üyelerinde ortak tarih/eksik kayıt denetimi yapıp tüm dolu market value satırlarını sıralamaktır; bu bile özel şirketler dahil tam değerleme olmaz.

Zylo bir SaaS yönetim satıcısının müşteri/veri örneklemidir; Fortune 500'e özel rastgele örneklem değildir. Bu yüzden 275 ve 49 milyon rakamları her Fortune 500 firmasının kesin kullanımı/harcaması değildir. Eski rapor adresinin artık 2026 raporuna yönlendiği görüldüğünden tarihli 2025 bulgularını koruyan kaynak sayfa kullanılmıştır. [2025 bulgularının bağımsız çapraz kontrolü — High Alpha, 21 Ocak 2025](https://www.highalpha.com/blog/navigating-saas-spending-in-2025-insights-from-zylos-saas-management-index)

### Bir Fortune 500 şirketi neden bu SaaS'a para ödüyor?

**Stanley Black & Decker, 2025 Fortune 500'de 283. sıradadır.** [Fortune, 2025 şirket sırası](https://fortune.com/article/fortune-500-power-moves-june-28-july-3/)

Zendesk'in kendi müşteri vaka çalışması, şirketin bir ürün paketi için anlaşma yapıp farklı ülkelerdeki destek kanallarını birleştirdiğini anlatır. Amaç e-posta, telefon, sohbet ve bilgi bankasını tek operasyon altında yönetmektir. Kaynakta aylık yaklaşık **10.000 talep** ve **bir saatlik ilk yanıt SLA'sı** belirtilir. Bu, ticari ürün paketi edinimi ve fiilî kullanım kanıtıdır; sözleşme bedeli veya ödenmiş fatura kamuya açık değildir. Bugün hâlâ aynı sözleşmeyle ödeme yapıldığı sonucu çıkarılamaz. [Zendesk resmî 2019 vaka çalışması, PDF sayfa 7](https://web-assets.zendesk.com/pdf/The_Zendesk_Customer_Experience_Trends_2019_How-To_Guide.pdf#page=7)

Bu kaynak kullanım/satın alma ilişkisini destekler; öğretmen ödeme dekontunu şart koşarsa o belge doğrulanamadı. PulseDesk'in ilk yanıt/zaman takibi dilimi bu operasyonun küçük bir parçasını ele alır.

## Faz 2 — Kod ölçeği, tahmin ve gerçek maliyet

### Zendesk kaç satır kod?

Yaklaşık **2 milyon satır** büyüklüğünde Rails monoliti: Zendesk mühendisleri Cristian Planas ve Anatoly Mikhaylov'un rubyday 2024 sunum başlığı ve resmî programı bu ölçeği bildirir. Tahmin yöntemi rastgele modül çarpanı değil, ürünün mühendislerinin tarihli beyanını temel almaktır. Bu sayı 2024 monolitine aittir; 2026'daki bütün servislerin, testlerin ve bağımlılıkların yeniden ölçülmüş toplamı değildir. Kapalı kaynak depoya erişip LOC ölçümü yapmadık. [Konferansın birincil kaynağı](https://2024.rubyday.it/talks_speakers/) · [Konuşma kaydı/transkript](https://www.rubyevents.org/talks/2-000-engineers-2-million-lines-of-code-the-history-of-a-rails-monolith-rubyday-2024)

Ödevin yaklaşık **300.000 satır** ölçek şartından daha büyük gerçek bir kurumsal üründür; tam 300.000 olduğunu iddia etmiyoruz. Eğer şart "en az bu mertebe" yerine "yaklaşık tam bu büyüklük" anlamındaysa öğretmen teyidi gerekir.

PulseDesk'in bu sürümünde `app/` + `lib/` altındaki Ruby/ERB/JS/CSS dosyalarında **504 fiziksel satır** sayıldı: Ruby 303, ERB 151, JS 49, CSS 1. `ruby script/project_metrics.rb` ile tekrar üretilebilir. Boş satır/yorum dahil, test/bağımlılık/generated schema hariçtir; CSS tek satıra sıkıştırıldığı için bu ölçü emek veya kalite ölçütü değildir. Bu sayı Zendesk LOC tahminine oranlanmaz.

### Coding agent ile bu aort dilimini üretme tahmini

Tahmin kapsamı PulseDesk çekirdeğidir, Zendesk'in milyon satırlık bütün ürününü yeniden üretmek değildir. **3–6 saat** çalışma bütçesi bir planlama varsayımıdır: model/durum/SLA, ekranlar, testler, ortam/deploy ve inceleme için zaman ayrılmıştır. Ölçülmüş piyasa verimi veya garantili teslim süresi değildir. Tam kurumsal ürünün süresini küçük aort diliminden doğrusal ölçekleyemiyoruz.

Planlama için örnek API bütçesi: kısa bağlamda **2 milyon uncached input + 0,2 milyon output = 6 USD**; **10 milyon + 1 milyon = 30 USD**. Token hacimleri varsayımdır; cache, uzun bağlam, araç, vergi ve insan emeği hariçtir. Gerçek kayıtlarda görülen model **gpt-6.1-sol** için Standard birim fiyat kullanıldı: milyon token başına **2 USD input / 0,10 USD cached input / 10 USD output**. **272.000 input tokenı aşan istekler** için bütün istekte **4 / 0,20 / 15 USD** uygulanır. [OpenAI resmî model ve fiyat kuralları](https://developers.openai.com/api/docs/models/gpt-6.1-sol)

### Erişilebilir gerçek token kaydı ve API eşdeğeri

Yalnızca çalışma dizini PulseDesk olan mevcut Codex Desktop oturumu incelendi. Ham oturum, mesajlar, araç çıktıları ve kimlik bilgileri depoya eklenmedi. Sayısal, anonim özet: [JSON kanıtı](docs/codex-usage-2026-10-19.json); yeniden hesaplayan [betik](script/audit_codex_usage.rb). Resmî App Server belgesi oturum token kullanım bildirimini tanımlar; yerel JSONL formatı fatura sözleşmesi olarak kabul edilmez. [OpenAI kullanım bildirimi](https://learn.chatgpt.com/docs/app-server#streaming-events)

**Sabit veri kesimi:** 19 Ekim 2026 **02:36:30 TRT** (18 Ekim 23:36:30 UTC). Bu kesim önceki çalışan sürümün belgelemesini kapsar; bu son teslim araştırmasının sonraki tüketimini kapsamaz. Görünen tek model `gpt-6.1-sol`; ilk/son kullanım kaydı **00:22:03,011–02:36:06,182 TRT**. Bunlar bu oturumun kayıtlarıdır; içeri aktarılan eski sohbetin veya başka oturumların tam token geçmişi olduğu iddia edilmez.

| Doğrulanan ölçü | Token |
| --- | ---: |
| Toplam input (cache dahil) | 28.539.461 |
| Cached input (input'un alt kümesi) | 27.851.776 |
| Uncached input (fark) | 687.685 |
| Cache write | 0 |
| Output (reasoning dahil) | 93.833 |
| Reasoning output (output'un alt kümesi; tekrar eklenmez) | 20.248 |
| Input + output toplamı | 28.633.294 |

Yöntem: **157** benzersiz `response_id` için `token_usage_record.payload.usage` toplandı; son `thread_token_usage` ile alan alan birebir eşleşti. Tekrarlanan `event_msg` kümülatif sayaçları ve `turn_token_usage` tekrar toplanmadı. Tek bir uzun metnin token sayımı değil, tekrar kullanılan bağlamlar dahil istek tüketimidir. Bütün satırların kaynağı yukarıdaki yerel sayısal özet/betiktir; bağımsız ödeme belgesi değildir.

| İstek grubu | İstek | Input | Cached input | Output |
| --- | ---: | ---: | ---: | ---: |
| Input ≤ 272.000 | 122 | 16.427.692 | 15.847.808 | 67.399 |
| Input > 272.000 | 35 | 12.111.769 | 12.003.968 | 26.434 |

**Standard API eşdeğer formülü (USD):**

```text
[(16.427.692 − 15.847.808) × 2 + 15.847.808 × 0,10 + 67.399 × 10
 + (12.111.769 − 12.003.968) × 4 + 12.003.968 × 0,20 + 26.434 × 15] / 1.000.000
= 6,647046 USD ≈ 6,65 USD
```

Bu **kayıtlı tüketimin Standard API fiyatlarıyla karşılığıdır**, gerçek harcama değildir. Endpoint/bölge ve işlem hızı faturadan doğrulanmadığı için Standard/default bölge varsayıldı; Fast/Ultrafast ücretleri, araç bedelleri, kredi satın alımları, vergi ve abonelik bedeli dahil değil. Gerçek kullanılan model doğrulandı; gerçek faturalama katmanı doğrulanmadı. Codex'in aboneliğe dahil kullanımı API fiyatlarıyla faturalandırılmaz. Hesabın planı, ödenen abonelik tutarı, dönem faturası ve projeye düşen payı gösteren erişilebilir ödeme belgesi bulunmadı; bunlara **0 USD** atanmadı. [OpenAI abonelik/API ayrımı](https://learn.chatgpt.com/docs/pricing)

Yerelde tekrar üretim (SESSION_JSONL bu PulseDesk oturumunun özel yerel dosyasıdır; Git'e eklenmez):

```powershell
ruby script/audit_codex_usage.rb SESSION_JSONL 2026-10-18T23:36:30Z
```

### Gerçekte doğrulanabilen süre ve maliyet

- İlk proje dosyası oluşturma kaydı: **19 Ekim 2026 00:25:06 TRT**, yerel `.ruby-version` dosya oluşturma zamanı. İlk commit: **01:10:12 TRT**, anahtar düzeltme commit'i: **01:49:53 TRT**. [Git geçmişi](https://github.com/ayseliremisik856-creator/PulseDesk/commits/main/)
- İlk başarılı Render deploy bitişi: **02:19:11 TRT**. [Gerçek deploy kaydı](https://dashboard.render.com/web/srv-dbakkne1egvs73b330b0/deploys/dep-dbal6tlg1s2s73chiigg). İlk proje dosyası ile canlı deploy arasında yaklaşık **1 saat 54 dakika 5 saniye** var. Bu geçen takvim süresidir; aktif kodlama süresi değildir ve sonraki araştırma/ortak SLA geliştirmesi bu aralığa dahil değildir.
- Daha güçlü oturum kapsamı: yerel `session_meta` başlangıcı **00:21:53,666 TRT**, son kesim öncesi kullanım **02:36:06,182 TRT**: **2 saat 14 dakika 12,516 saniye geçen süre**. Git'in ilk commit'i **01:10:12**, kesim öncesi son commit `c8477a1` **02:33:58 TRT**: commitler arası **1 saat 23 dakika 46 saniye**. `git log --format="%h %aI %s"` ile kontrol edilir. Git zamanları bilgisayar saatine dayanır; bekleme, deploy ve araştırma içerir. Hiçbiri aktif çalışma saati veya insan mesaisi değildir. [Token/oturum özeti](docs/codex-usage-2026-10-19.json)
- Önceki doğrulama: **27 test / 136 assertion**. Ortak politika geliştirmesi sonrası yerelde gerçekten çalıştırılan son paket: **39 test / 195 assertion, 0 failure, 0 error, 0 skip**. Sonraki CI/canlı kanıtları commit ve Actions kayıtlarından kontrol edilir; bu yazı gelecekteki koşuları peşinen başarılı saymaz.
- Render web ve PostgreSQL kaynakları `free` planıyla yapılandırılmıştır; planın liste bedeli **0 USD**, fakat toplam hesap faturası ve agent abonelik/kredi dökümü okunmadı. **Gerçek toplam ödenen maliyet doğrulanamadı**; "0 dolar harcadım" sonucu çıkarılamaz. [Render ücretsiz plan koşulları](https://render.com/docs/free)

## Gerçek kullanıcı sorunu → çalışan küçük çözüm

**Kimin sorunu?** Alex M., Senior Project Coordinator, Consumer Services; G2'de 2 Ekim 2026 tarihli, **4/5** puanlı “Multi-Brand Support Made Simple: One Team, One Queue, Unified Reporting” yorumu. G2 bunu Current User / Validated Reviewer / Incentivized / Seller invite olarak etiketler; teşvikli oluşu belirtilmiştir. [Doğrudan yorumun bulunduğu kaynak](https://www.g2.com/products/zendesk-for-customer-service/reviews#:~:text=Multi-Brand%20Support%20Made%20Simple)

Kısa alıntı: “Keeping triggers and automations consistent across both brands took more care than I expected”. Kullanıcı bir markaya eklediği kuralı diğerine yansıtmayı unuttuğu için otomatik etiketleme tutarsızlığı yaşadığını anlatıyor. Bu tüm ürünün teknik olarak ortak kurala izin vermediğinin kanıtı değildir; bir kullanıcının kural bakımı deneyimidir. Ayrıca yorum doğrudan SLA değil, markalar arası trigger/otomasyon tutarlılığı hakkındadır. **SLA yönetimi bu sorunun PulseDesk'te seçilmiş dar uygulamasıdır; otomatik etiketleme geliştirilmedi.**

**Sunum cümlesi:** “G2'deki Alex M.'nin iki markada otomasyon kopyasını unutma sorununu, PulseDesk'te markaların aynı SLA politikasına bağlanması ve yeni taleplerin tek merkezdeki hedefi kullanmasıyla çözüyoruz.”

### Çalışan ortak politika davranışı

1. Üst menüden **Ortak SLA** ekranına gir; politika oluştur.
2. İki markayı aynı politikaya bağla.
3. Hedefi aynı ekrandan bir kez değiştir.
4. Her iki markada yeni talep oluştur: kaydedilmiş hedef dakika aynı olur.
5. Daha önce oluşturulan talepler kendi hedefini korur; bir hedef uzatılması geçmiş ihlali silemez.

Politikalar ilk yanıt için **1–1440 tam dakika** kabul eder (proje tasarım sınırı, dış araştırma sayısı değildir). Politikasız marka **60 dakika** kullanır. Takvim dakikası hesaplanır; mesai/tatil takvimi yoktur. Değişiklik yalnızca yeni taleplere uygulanır; mevcut bekleyen taleplerin hedefi de sabittir. Markadan politika bağlantısı kaldırılınca gelecekteki talepler varsayılana döner. Hedef talebe kayıt anında kopyalanır, böylece geçmiş SLA sonuçları yeniden yazılmaz.

### Korunan aort kuralları

- `new → open → solved`; yeni kayıt `new`, atama durum değiştirmez, atlama/geri dönüş reddedilir.
- Deadline = `created_at + sla_target_minutes`; tam sınır zamanında, bir saniye sonrası ihlal.
- İlk geçerli personel yanıtı `first_response_at` alanını yalnızca bir kez doldurur; müşteri yanıtı doldurmaz.
- Yanıtlar açık talebe eklenir. Geç yanıt veya çözülme geçmiş ihlali kaldırmaz.
- Mevcut canlı kayıtlar eklemeli migration ile **60 dakika** hedefini korur; tablo/veri silinmez.

## Geliştirme, test ve deploy

```powershell
bundle install
ruby bin/rails db:migrate
ruby bin/rails server -b 127.0.0.1 -p 3000
```

```powershell
$env:RAILS_ENV='test'
ruby bin/rails db:migrate
ruby bin/rails test
Remove-Item Env:RAILS_ENV
ruby bin/rails zeitwerk:check
```

Testlerde `travel_to` ile varsayılan/özel hedef sınırı, geç yanıttan sonra kalıcı ihlal, geriye dönük politika koruması, HTTP bağlantı/düzenleme ve tam talep akışı denetlenir. [Testler](test/) · [CI workflow](.github/workflows/ci.yml)

CI, Ubuntu üzerinde SQLite testlerini ve ayrı PostgreSQL üretim işinde gerçek Render build betiğini çalıştırır. Üretim işi geçici CI credentials kullanır; gerçek anahtar kullanmaz. PostgreSQL iş akışı transaction içinde rollback edilir; ardından `/`, `/up` ve derlenmiş CSS kontrol edilir. Windows'ta geçen testler Linux başarısının yerine geçmez; Actions sonucunu ayrıca incele.

Mevcut Render servisi korunur. `render.yaml`, aynı bölgedeki `pulsedesk-db` bağlantısını `DATABASE_URL` olarak verir; production SQLite kullanmaz. Build: `bash bin/render-build.sh`; start: `bundle exec puma -C config/puma.rb -b tcp://0.0.0.0:${PORT:-10000}`. `RAILS_ENV=production`, `BUNDLE_WITHOUT=development:test`, `BUNDLE_DEPLOYMENT=true`, `RAILS_MAX_THREADS=3`, `WEB_CONCURRENCY=0`. `RAILS_MASTER_KEY` gizli olarak Render'da tutulur; `SECRET_KEY_BASE` yerine geçmez. Üretim cache memory_store, job inline, Cable async; ek Solid veritabanı gerekmez.

Free planda pre-deploy komutu olmadığından migration build sırasında çalışır. Eski uygulama sürümüyle uyumlu eklemeli değişiklikler kullanılmalıdır. CI yeşil olduktan sonra `checksPass` otomatik deploy tetikler; canlı test sonucu ayrıca doğrulanır. [Render Rails 8 rehberi](https://render.com/docs/deploy-rails-8)

`.gitignore` anahtarları, `.env`, SQLite ve tmp/log çıktısını dışlar. Şifreli `credentials.yml.enc` Git'tedir; anahtarı yoktur. `.gitattributes` Linux için LF satır sonlarını korur; lockfile Windows ve Linux platformlarını içerir. Agent erişim tokenları yalnızca güvenli yerel CLI yapılandırmasındadır, repo veya README'ye yazılmaz.

## Yapamadıklarım

- 2026 Fortune 500'ün tüm şirketlerinde aynı tarihteki **tam değerleme minimum–maksimumu** doğrulanamadı. Beş şirketlik tarih eşlenmiş alt küme sunuldu; tüm halka açık üyelerin aralığı bile olduğu iddia edilmedi. Lisanslı tam verinin elde edilmesi ve eksik/tarih kontrolü gerekir.
- PulseDesk oturumunun gerçek token sayıları doğrulandı; **gerçek ödeme/abonelik faturası** ve aktif çalışma süresi doğrulanamadı. Kesim sonrası tüketim özette yok. 6,65 USD Standard API eşdeğeri toplam gerçek maliyet değildir.
- Müşteri anlaşması/kullanımı kaynaklıdır; Stanley Black & Decker'ın ödeme dekontu, ücret tutarı veya halen devam eden kontratı kamuya açık olarak doğrulanamadı.
- Kaynak Zendesk monoliti yaklaşık 2 milyon satır bildiriyor; tam 300.000 satır veya güncel tüm ürün LOC ölçümü doğrulanamadı.
- Render'ın bu öğrencinin daha önce hiç kullanmadığı platform olduğu yalnızca öğrencinin geçmişiyle teyit edilebilir; bu depodan doğrulanamaz.
- Classroom'a bağlantı gönderimi, ders başlamadan teslim ve canlı sunum burada yapılamaz; öğrenci tamamlamalıdır.
- Login, kullanıcı yetkilendirmesi, tenant izolasyonu, ödeme sistemi, mesai/tatil takvimi, otomatik etiketleme ve tam bir Zendesk klonu yok. Var oldukları sunumda iddia edilmemelidir.
- Ortak politika mevcut taleplere geriye dönük uygulanmaz. Kalıcı kuyruk/planlı job veya çok süreçli Cable yok.
- Free Render PostgreSQL **30 gün sonra sona erer**; kalıcı ticari hosting/backup çözümü tamamlanmadı. Aktif Storage yerel diski geçicidir, ek dosya yükleme özelliği sunulmuyor. [Ücretsiz plan sınırları](https://render.com/docs/free)

## Beş dakikalık sunum akışı

| Süre | Gösterilecek |
| --- | --- |
| 30 sn | PulseDesk, ticari müşteri kanıtı ve dar destek iş akışı |
| 2 dk | Canlıda oluştur → ata → aç → yanıtla → çöz |
| 1 dk | `FirstResponseSla#deadline` / `#breached?`, `Ticket#valid_status_transition` ve travel_to testleri |
| 1 dk | Alex M. yorumu; iki marka/tek politika ve geçmiş hedefin korunması; eksikler |
| 30 sn | `AGENT.md` dosya haritası: süre hesabı serviste, geçiş modeli Ticket'ta, politika hedefi SlaPolicy'de |

Resmî kontrol listesinin madde madde mevcut durumu [docs/assignment-checklist.md](docs/assignment-checklist.md) içinde tutulur. Çalışan özelliklere ilişkin kanıt ile eksik araştırma maddeleri ayrıdır; **tüm 85/100 koşulları sağlandı** veya kesin not garantisi iddia edilmez.

Kod commit'i `eafc01e` için tamamlanan Linux CI, Render deploy ve gerçek canlı ortak politika kontrolü: [19 Ekim doğrulama kaydı](docs/verification-2026-10-19.md). Bu belge yalnızca gerçekleştirilmiş kontrolleri listeler.

Son araştırma ve yerel test denetimi: [son teslim kaydı](docs/final-audit-2026-10-19.md). Güncel commit'in CI sonucu üstteki rozet/Actions bağlantısından izlenir.
