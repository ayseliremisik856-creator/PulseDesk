# PulseDesk geliştirme rehberi

## Kapsam ve güvenlik
- Yalnızca bu PulseDesk deposunda çalış; DevSession Ledger ve diğer projelere dokunma.
- Gerçek test sonucu raporla. Anahtarları, tokenları ve DATABASE_URL parolasını çıktı/log/Git'e yazma.
- `config/master.key`, `.env` ve SQLite dosyaları yereldir. Credentials'ı gereksiz yere yeniden üretme.
- Canlı PostgreSQL veya Render servisini silme; mevcut verilere uygun eklemeli migration kullan.

## Mimari
Rails 8.1.4 / Ruby 4.0.7 MVC monoliti. Yerelde/testte SQLite, Render üretiminde `DATABASE_URL` üzerinden PostgreSQL. Puma tek süreç; üretimde cache memory_store, Active Job inline, Cable async. Giriş/yetkilendirme ve tenant izolasyonu henüz yok: demo için sentetik veri kullan.

Brand markayı, Agent personeli, Ticket talebi, TicketResponse yazışmayı temsil eder. Ortak SLA politikası SlaPolicy ile markalara bağlanır. Yeni talepler hedef süreyi kayıt anında kopyalar; politika değişikliği geçmiş taleplerin sürelerini veya ihlalini geriye dönük değiştirmez. Bağlanmamış markalar 60 dakika kullanır.

## Kuralların değiştirileceği yer
| Kural / sorumluluk | Dosya |
| --- | --- |
| Yeni → açık → çözüldü; başlangıç new; geri/atlamalı geçiş yasağı | `app/models/ticket.rb` |
| İlk yanıt hedefi, tam sınır ve overdue hesabı | `app/services/first_response_sla.rb` |
| Ortak politika adı ve dakika doğrulaması | `app/models/sla_policy.rb` |
| Markanın politika bağlantısı | `app/models/brand.rb` |
| Yeni talebin değişmez hedef süresi kopyası | `app/models/ticket.rb` |
| Personel yanıtı first_response_at; müşteri yanıtı SLA'yı durdurmaz | `app/models/ticket_response.rb` |
| Formlardan izin verilen alanlar | `app/controllers/*_controller.rb` |
| Dashboard, talep ve politika ekranları | `app/views/tickets/`, `app/views/sla_policies/` |
| SLA ve durum metinleri | `app/helpers/tickets_helper.rb` |
| Veritabanı değişiklikleri | Yeni dosya: `db/migrate/`; uygulanmış migration'ı değiştirme |
| Veritabanı/üretim/port | `config/database.yml`, `config/environments/production.rb`, `config/puma.rb` |
| Anahtar doğrulaması | `lib/pulse_desk/master_key.rb`, `script/validate_credentials.rb` |
| Build/CI/deploy | `bin/render-build.sh`, `.github/workflows/ci.yml`, `render.yaml` |

## SLA değişmezleri
Süre talep oluşturulduğunda başlar; takvim dakikasıdır, mesai takvimi yoktur. Deadline = created_at + kaydedilmiş hedef dakika. Tam deadline'da ilk personel yanıtı zamanındadır; bir saniye sonrası ihlaldir. Yanıtsız ve deadline'ı geçmiş talep overdue'dur. İlk personel yanıt zamanı koşullu SQL güncellemesiyle yalnızca bir kez kaydedilir. Geç yanıt ve solved durumu ihlali silmez. Politika düzenlemek mevcut taleplerin hedefini değiştirmez.

## Geliştirme ve doğrulama komutları
```powershell
bundle install
ruby bin/rails db:prepare
ruby bin/rails server -b 127.0.0.1 -p 3000
# Ayrı test işlemi: RAILS_ENV=test yalnızca bu komutlar için ayarlanmalı.
$env:RAILS_ENV = 'test'
ruby bin/rails db:migrate
ruby bin/rails test
Remove-Item Env:RAILS_ENV
ruby bin/rails zeitwerk:check
```
Testler `test/models`, `test/integration`, `test/lib` içindedir; zaman testleri `travel_to` kullanır ve ardışık çalışır. `ruby bin/rails test test/models test/integration` iş akışını ayrı çalıştırır. Ek testlerle toplam sayı değişebilir; gerçek çıktıyı kullan.

## Canlıya geçiş
Önce migration/test/Zeitwerk ve assets kontrolü; sonra staged diff ve gizli bilgi taraması, commit/push. GitHub CI'nin Linux SQLite ve PostgreSQL üretim kontrollerini izle. Render mevcut serviste, CI başarılı olduğunda deploy eder. Üretimde migration build sırasında çalışır: eski sürümle uyumlu değişiklikler yap. Canlı `/`, `/up`, CSS ve sentetik talep akışını doğrula. Render CLI yetkisini yerel güvenli yapılandırmada tut; API değişikliğinde yalnızca gereken ortam değişkenini güncelle.

Bu dosya istenen `AGENT.md` proje rehberidir; araçların otomatik yüklemesi için `AGENTS.md` varmış gibi davranma.

Sunum satır haritası (bu sürüm): `FirstResponseSla` varsayılan hedef satır 3, deadline satır 9, ihlal satır 14; `Ticket` geçiş tablosu satır 4, snapshot satır 29, snapshot koruması satır 33, durum doğrulaması satır 37; `SlaPolicy` hedef aralığı satır 4. Düzenleme sonrası satırları `rg -n` ile yeniden kontrol et.
