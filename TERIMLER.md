# Terim sözlüğü (Praat Türkçe arayüz)

Bu dosya Praat arayüzünün Türkçeye çevirisinde kullanılan terimleri ve gerekçelerini toplar. Çeviri sözlüğü (`ceviri/ceviri_tr.tsv`) bu tabloya uymalı. Yeni bir terim eklenirken önce buraya yazılır, sonra sözlüğe geçer.

## İlkeler

1. Anlaşılırlık önce gelir. Kullanıcı kitlesi dil ve konuşma terapistleri (DKT), dilbilim ve fonetik öğrencileri. Türkçe dilbilim ve DKT literatüründe yerleşik bir karşılık varsa o kullanılır.
2. Yerleşik karşılık yoksa terim korunur, ilk geçtiği yerde parantezle açıklanır: "jitter (frekans düzensizliği)".
3. Praat nesne adları çevrilmez. Sound, TextGrid, Pitch, Intensity, Formant, Spectrogram, PointProcess, Harmonicity, Manipulation, PitchTier gibi adlar Nesneler penceresindeki listede, script komutlarında (`selectObject: "Sound ses"`, `To Pitch...`) ve kılavuzda İngilizce geçer. Arayüzde başka bir ad görünürse kullanıcı script yazarken ya da kılavuzu okurken eşleştiremez. Bu yüzden komut etiketlerinde nesne adı İngilizce bırakılır: "To Pitch..." için "Pitch hesapla...". Düzenleyici penceresindeki menü başlıkları (Perde (F0), Şiddet, Spektrogram, Formantlar) ise nesneyi değil ekranda gösterilen analizi adlandırdığı için çevrilir. Düzenleyicideki "Sound" menüsü çevrilmedi, çünkü aynı anahtar Yeni menüsünde nesne türü alt menüsü olarak da geçiyor ve sözlük bağlam ayırmıyor.
4. Komutların iç adları değişmez. Çeviri yalnızca ekranda görünen etikete uygulanır (`sys/Gui_ceviri.cpp`). Scriptler, "Paste history" ve düğme ayarları İngilizce komut adlarıyla çalışmaya devam eder. Dolayısıyla Türkçe arayüzde çalışan biri script yazarken İngilizce adı kullanmalı. Bunun için kılavuz ve Paste history yeterli.
5. Ekler korunur. "..." ile biten komut bir diyalog açar, ":" ile biten menü öğesi alt menüdür, " -" ile biten düğme bir eylem grubudur. Türkçe karşılık aynı ekle biter.
6. Fiil biçimi: menü komutları emir kipinde ve kısa: "Aç", "Kaydet", "Sorgula", "Çiz". Başlıklar ad biçiminde: "Analiz", "Sorgu", "Görünüm".

## Fonetik ve akustik terimler

| İngilizce | Türkçe | Not |
|---|---|---|
| sound | ses | Nesne adı olarak Sound kalır |
| waveform | dalga biçimi | |
| sample | örnek | "örneklem" istatistik terimi, burada kullanılmaz |
| sampling frequency | örnekleme frekansı | |
| amplitude | genlik | |
| frequency | frekans | "sıklık" da geçer, DKT literatüründe frekans yaygın |
| fundamental frequency (F0) | temel frekans (F0) | |
| pitch | perde | Algısal kavram. Praat'taki Pitch analizi aslında F0 kestirimi. Menüde "Perde (F0)" |
| intensity | şiddet | "Ses şiddeti" DKT'de yerleşik. "Yoğunluk" kullanılmaz |
| loudness | gürlük | |
| formant | formant | Yerleşik, çevrilmez |
| bandwidth | bant genişliği | |
| spectrum | spektrum | "Tayf" fizikte geçer, fonetikte spektrum yaygın |
| spectrogram | spektrogram | |
| spectral slice | spektral kesit | |
| cepstrum | kepstrum | |
| cepstral peak prominence (CPP) | kepstral tepe belirginliği (CPP) | |
| harmonicity, HNR | harmoniklik, harmonik/gürültü oranı (HNR) | |
| jitter | jitter (frekans düzensizliği) | Yerleşik Türkçe karşılık yok, terim korunur |
| shimmer | shimmer (genlik düzensizliği) | Yerleşik Türkçe karşılık yok, terim korunur |
| voice report | ses raporu | |
| voice breaks | ses kırılmaları | |
| voiced / voiceless | ötümlü / ötümsüz | Türkçe dilbilimde yerleşik. DKT'de "sesli/sessiz" de geçer, ancak "sesli" ünlü anlamıyla karışır |
| vowel / consonant | ünlü / ünsüz | |
| pulses (glottal pulses) | titreşim noktaları (pulses) | Praat'taki PointProcess nesnesi |
| glottal | glottal | |
| periodicity | periyodiklik | |
| autocorrelation | otokorelasyon | |
| cross-correlation | çapraz korelasyon | |
| LPC | LPC (doğrusal öngörülü kodlama) | |
| filter | süzgeç | "Filtre" de anlaşılır, dilbilim literatüründe süzgeç geçer |
| band | bant | |
| low-pass / high-pass | alçak geçiren / yüksek geçiren | |
| resample | yeniden örnekle | |
| manipulation | manipülasyon | Nesne adı Manipulation kalır |
| synthesis | sentez | |
| duration | süre | |
| time step | zaman adımı | |
| window length | pencere uzunluğu | |
| silence | sessizlik | |
| mean / minimum / maximum | ortalama / en küçük / en büyük | |
| standard deviation | standart sapma | |

## Etiketleme (TextGrid) terimleri

| İngilizce | Türkçe | Not |
|---|---|---|
| TextGrid | TextGrid | Nesne adı, çevrilmez. Açıklama: "etiketleme ızgarası" |
| annotation | etiketleme | "Açımlama" bazı kaynaklarda geçer, daha az anlaşılır |
| tier | katman | |
| interval tier | aralık katmanı | |
| point tier | nokta katmanı | |
| interval | aralık | |
| point | nokta | |
| boundary | sınır | |
| label | etiket | |
| segment | bölüt | Dilbilimde yerleşik. "Segment" de anlaşılır |
| align | hizala | |

## Arayüz terimleri

| İngilizce | Türkçe | Not |
|---|---|---|
| Objects window | Nesneler penceresi | |
| Picture window | Çizim penceresi | |
| Info window | Bilgi penceresi | |
| editor | düzenleyici | |
| View & Edit | Görüntüle ve düzenle | |
| Query | Sorgu (menü), Sorgula (komut) | |
| Analyse | Analiz | |
| Annotate | Etiketle | |
| Synthesize | Sentezle | |
| Modify | Değiştir | |
| Convert | Dönüştür | |
| Draw | Çiz | |
| Select | Seç | |
| selection | seçim | |
| cursor | imleç | |
| zoom in / out | yakınlaştır / uzaklaştır | |
| play | çal | |
| record | kaydet (ses kaydı), kayıt | Dosya kaydetme "Kaydet" ile karışmasın diye "Ses kaydet" |
| save | kaydet | |
| open / read | aç / oku | |
| settings | ayarlar | |
| preferences | tercihler | |
| show / hide | göster / gizle | |
| apply / OK / Cancel | uygula / Tamam / İptal | |
| standards | varsayılanlar | Diyalogdaki "Standards" düğmesi ayarları varsayılana döndürür |
| Remove | Kaldır | |
| Rename | Yeniden adlandır | |
| Inspect | İncele | |
| Info | Bilgi | |

## Açık terim soruları

- "pitch" için "perde (F0)" mi yoksa yalnızca "temel frekans" mı? Şimdilik menüde "Perde (F0)" kullanılıyor.
- "voiced / voiceless" için "ötümlü / ötümsüz" seçildi. DKT öğrencileri için "sesli / sessiz" daha tanıdık olabilir.
- "filter" için "süzgeç" seçildi. Klinik kullanıcılar "filtre" bekleyebilir.
