# Resmî ödev kontrol listesi

Kaynak: öğrencinin bu geliştirme görüşmesinde paylaştığı 19 Ekim 2026 Ödev 3 yönergesi. Bu belge öğretmenin verdiği not değildir. Canlı uygulama ve CI değişebilir; aşağıdaki kanıt bağlantılarının güncel sonucu esastır.

## 0 puana yol açan koşullar

| Koşul | Durum / kanıt |
| --- | --- |
| Canlı URL yok | Yok: [mevcut canlı URL](https://pulsedesk-12n5.onrender.com) var; yeni sürüm sonrası tekrar kontrol edilir. |
| Aort uçtan uca çalışmıyor | Önceki canlı sürümde gerçek HTTP akışı doğrulandı; yeni sürümde aynı akış ve ortak politika doğrulanacak. |
| Var denilen özellik çalışmıyor | Yalnızca talep akışı ve ortak politika sunulur; login/ödeme/otomatik etiketleme yok, README'de açık. |
| Uydurma test raporu | Yerel gerçek sonuç: 39 test / 195 assertion; 0 failure/error/skip. CI sonucu ayrıca [Actions](https://github.com/ayseliremisik856-creator/PulseDesk/actions) üzerinden izlenir. |
| Orijinal ürün markası/logosu uygulamada | Uygulama görünümü PulseDesk; kaynak ürün adı yalnızca araştırma dokümanlarında. Kod/görünüm taraması ve canlı sayfalarla kontrol edilir. |

## 85 puan — tümü zorunlu

| No | Kriter | Durum |
| --- | --- | --- |
| 1 | Kaynaklı Fortune 500 müşteri kanıtı | Tamamlandı: Stanley Black & Decker, Fortune sırası + Zendesk resmî ürün edinimi/kullanım vakası. Ödeme dekontu yok; aşağıdaki özel şartın yorumu önemlidir. |
| 2a | Değerleme en küçük–en büyük | **Eksik:** tüm evren için aynı tarihli güvenilir aralık yok. Piyasa değeri/firma değeri ayrımı ve tarihli örnekler var; bunlar evren aralığı değildir. |
| 2b | Çalışan aralığı | Tamamlandı: kaynaklı 2025 aralığı README'de. |
| 2c | Yaklaşık SaaS sayısı | Tamamlandı: Zylo örneklem ortalaması, Fortune 500 genellemesi olmadığı belirtilir. |
| 2d | Yaklaşık yıllık SaaS harcaması | Tamamlandı: aynı örneklem ve tarih; her rakam yanında kaynak. |
| 3a | Ürün LOC ve yöntem | Tamamlandı: mühendislerin konferans beyanıyla yaklaşık 2 milyon; kapsam/tarih ve ölçüm sınırı açık. |
| 3b | Agent maliyet/süre tahmini | Tamamlandı: açık kapsam/varsayım, fiyat kaynağı, 8–40 USD API senaryosu ve 3–6 saat planlama bütçesi. |
| 3c | Gerçek süre/maliyet | **Kısmen:** dosya/Git/deploy ile geçen süre doğrulandı; aktif süre ve gerçek toplam fatura doğrulanamadı. |
| 4 | Rails 8+ canlı aort | Mevcut Rails 8.1.4 canlı; yeni sürüm deploy sonucu ve canlı kontrol ayrıca kaydedilir. |
| 5 | Zaman kuralı ve durum geçişi | Tamamlandı: kayıt hedefi + new/open/solved. |
| 6 | Otomatik test ve travel_to | Tamamlandı: varsayılan/ortak hedef sınırı ve kalıcı ihlal testleri. |
| 7 | Yeşil GitHub Actions + rozet | Rozet mevcut; bu değişikliğin CI sonucu push sonrası [Actions'ta](https://github.com/ayseliremisik856-creator/PulseDesk/actions) ayrıca doğrulanır. Eski commit'in yeşili yeni commit için kanıt sayılmaz. |
| 8 | AGENT.md | Tamamlandı; ajanla üretildi, dosya/kural haritası ve komutlar var. |
| 9 | Yapamadıklarım | Tamamlandı; gerçek araştırma ve teslim eksikleri gizlenmedi. |

## 100 puan ve üzeri

| Kriter | Durum |
| --- | --- |
| Tüm 85 şartları | **Eksik:** 2a ve gerçek fatura maddesi nedeniyle tam karşılandı denemez. |
| Gerçek kullanıcı yorumu ve kaynak | Tamamlandı: G2 Alex M., 2 Ekim 2026, başlık/tarih/puan/teşvik etiketi ve kaynak bağlantısı README'de. |
| Kullanıcının yapabiliyor/ama sorunu | Tamamlandı: multibrand tek kuyruk var; markalar arası otomasyon kopyasını unutma tutarsızlığı var. Yorum SLA eksikliği iddiası olarak çarpıtılmaz. |
| Çalışan çözüm | Yerel model/HTTP testleri geçti: ortak politika, marka bağlantısı, tek noktadan değişiklik, gelecekte tutarlı hedef; canlı yeni sürüm ayrıca doğrulanır. |
| Tek cümle sunum | README'de hazır. |

## Diğer zorunlu şartlar

| Kriter | Durum |
| --- | --- |
| Fortune 500 firmasının ücretli SaaS ilişkisi | Resmî vaka ürün paketi anlaşmasını doğruluyor. **Ödeme dekontu/bedeli ve halen devam eden abonelik doğrulanamadı.** Ticari müşteri kanıtı ile fatura kanıtı ayrılmıştır. |
| Yaklaşık 300.000 satır kurumsal ürün | Kaynak ürün daha büyük: 2024 beyanı yaklaşık 2 milyon. En az bu ölçek yorumunu karşılar; tam yaklaşık 300.000 şartıysa **öğretmen teyidi gerekli**. |
| Özgün ad/logo | Tamamlandı: PulseDesk metin logosu. |
| Daha önce kullanılmamış deploy platformu | Render kullanıldı; öğrencinin kişisel geçmişi **doğrulanamadı**. |
| 19 Ekim dersinde canlı sunum | **Öğrenci tamamlamalı**; bu depo gerçekleştiğini kanıtlamaz. |
| Ders öncesi Classroom bağlantıları | **Öğrenci tamamlamalı**; Classroom'a erişilmedi. |
| Bireysel çalışma | Öğrenci beyanı gerekir; coding agent yardımı şeffaf biçimde belirtilmiştir. |
| Eksiklerin açıkça belirtilmesi | Tamamlandı. |

Sonuç: çalışan özellik ve dürüst rapor geliştirilmiştir; kesin 85/100 notu veya tüm zorunlu araştırmanın tamamlandığı iddia edilmez.
