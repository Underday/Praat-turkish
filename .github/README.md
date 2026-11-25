[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.24525320-2f5bff)](https://doi.org/10.5281/zenodo.24525320) [![Sürüm](https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fraw.githubusercontent.com%2FUnderday%2FPraat-turkish%2Fmain%2FCITATION.cff&query=%24.version&label=s%C3%BCr%C3%BCm&color=12b886)](https://underday.github.io/Praat-turkish/) [![Lisans](https://img.shields.io/badge/lisans-GPL--3.0-8c5cff)](https://github.com/Underday/Praat-turkish/blob/main/LICENSE)

> **Praat Türkçe:** Praat 7.0.03'ün Türkçe arayüzlü, değiştirilmiş ve resmî olmayan sürümü.
> - **İndirme ve kurulum:** [tanıtım sayfası](https://underday.github.io/Praat-turkish/)
> - **Kaynaktan derleme, çeviri katmanı, katkı ve atıf:** [README_TR.md](https://github.com/Underday/Praat-turkish/blob/main/README_TR.md)
> - **Terim kararları:** [TERIMLER.md](https://github.com/Underday/Praat-turkish/blob/main/TERIMLER.md)
>
> Aşağıdaki metin Praat'ın kendi README dosyasının Türkçe çevirisidir. İngilizce asıl metin: [README.md](https://github.com/Underday/Praat-turkish/blob/main/README.md)

# Praat: bilgisayarla fonetik

Praat'a hoş geldiniz! Praat, bilgisayarla fonetik çalışmak için kullanılan bir konuşma analizi programıdır.
Konuşmayı analiz edebilir, sentezleyebilir ve değiştirebilir, yayınlarınız için yüksek kaliteli çizimler üretebilir.
Praat, Amsterdam Üniversitesi Fonetik Bilimleri Enstitüsü'nden Paul Boersma ve David Weenink tarafından geliştirildi.

Praat'ın öne çıkan özelliklerinden bazıları:

#### Konuşma analizi

Praat ile konuşmanın perde, formant, şiddet ve ses kalitesi gibi farklı yönlerini analiz edebilirsiniz.
Spektrogramlara (sesin zaman içindeki değişiminin görsel gösterimi)
ve koklegramlara (iç kulağın sesi alış biçimine daha çok benzeyen özel bir spektrogram türü) erişebilirsiniz.

#### Konuşma sentezi

Praat, sizin oluşturduğunuz bir perde eğrisinden ve süzgeçlerden (akustik sentez)
ya da kas etkinliklerinden (artikülatör sentez) konuşma üretebilir.

#### Konuşma manipülasyonu

Praat ile var olan konuşma kayıtlarını değiştirebilirsiniz. Konuşmanın perdesini, şiddetini ve süresini değiştirebilirsiniz.

#### Konuşma etiketleme

Praat, örneklerinizi IPA (Uluslararası Fonetik Alfabesi) ile kendi istediğiniz biçimde etiketlemenize
ve ses bölümlerinizi incelemek istediğiniz değişkenlere göre işaretlemenize olanak tanır.
Çok dilli metinden konuşmaya araçları, sesi sözcüklere ve fonemlere bölmenizi sağlar.

#### Dilbilgisi modelleri

Praat ile Optimallik Kuramı ve Harmonik Dilbilgisi öğrenmesini,
ayrıca çeşitli yapay sinir ağı modellerini deneyebilirsiniz.

#### İstatistiksel analiz

Praat'ta çok boyutlu ölçekleme, temel bileşenler analizi ve ayırma (diskriminant) analizi
gibi çeşitli istatistik yöntemlerini uygulayabilirsiniz.

Daha fazla bilgi için Praat'ın içindeki kapsamlı kılavuza (Yardım menüsü)
ve birçok dilde Praat eğitimleri bulunan [praat.org](https://praat.org) sitesine bakın.

## 1. Hazır program dosyaları

Desteklenen (ya da eskiden desteklenen) bütün platformlar için en güncel program [Praat sitesinde](https://praat.org) bulunur.
[GitHub'daki sürümler](https://github.com/praat/praat.github.io/releases) ayrıca birçok eski sürümü de içerir.

GitHub'daki dosya adlarının anlamı aşağıda (hâlâ güncellenen sürümler kalın yazılmıştır).
Bu dosyalar resmî İngilizce Praat'tır. Türkçe sürümün paketleri [tanıtım sayfasında](https://underday.github.io/Praat-turkish/).

### 1.1. Windows
- **`praatXXXX_win-x64v3.zip`: Intel64/AMD64(v3) Windows (10 ve sonrası) için zip'li program**
- **`praatXXXX_win-x64v1.zip`: Intel64/AMD64(v1) Windows (10 ve sonrası) için zip'li program**
- **`praatXXXX_win-arm64.zip`: ARM64 Windows (11 ve sonrası) için zip'li program**
- **`praatXXXX_win-intel32.zip`: Intel32 Windows (7 [6.4.52'ye kadar] ve sonrası) için zip'li program**
- `praatXXXX_win-intel64.zip`: Intel64/AMD64(v1) Windows (7 [6.4.52'ye kadar] ve sonrası) için zip'li program
- `praatXXXX_win64.zip`: Intel64/AMD64 Windows (XP ve sonrası ya da 7 ve sonrası) için zip'li program
- `praatXXXX_win32.zip`: Intel32 Windows (XP ve sonrası ya da 7 ve sonrası) için zip'li program
- `praatconXXXX_win64.zip`: Intel64/AMD64 Windows için zip'li program, konsol sürümü
- `praatconXXXX_win32.zip`: Intel32 Windows için zip'li program, konsol sürümü
- `praatconXXXX_win32sit.exe`: Intel32 Windows için kendi kendini açan StuffIt arşivi, konsol sürümü
- `praatXXXX_win98.zip`: Windows 98 için zip'li program
- `praatXXXX_win98sit.exe`: Windows 98 için kendi kendini açan StuffIt arşivi

### 1.2. Mac
- **`praatXXXX_mac.dmg`: (64 bit) Intel ve Apple Silicon Mac'ler için evrensel program içeren disk görüntüsü (Cocoa)**
- **`praatXXXX_xcodeproj.zip`: evrensel (64 bit) sürüm için zip'li Xcode proje dosyası (Cocoa)**
- `praatXXXX_mac64.dmg`: 64 bit Intel Mac'ler için disk görüntüsü (Cocoa)
- `praatXXXX_xcodeproj64.zip`: 64 bit sürüm için zip'li Xcode proje dosyası (Cocoa)
- `praatXXXX_mac32.dmg`: 32 bit Intel Mac'ler için disk görüntüsü (Carbon)
- `praatXXXX_xcodeproj32.zip`: 32 bit sürüm için zip'li Xcode proje dosyası (Carbon)
- `praatXXXX_macU.dmg`: (32 bit) PPC ve Intel Mac'ler için evrensel program içeren disk görüntüsü (Carbon)
- `praatXXXX_macU.sit`: (32 bit) PPC ve Intel Mac'ler için evrensel program, StuffIt arşivi (Carbon)
- `praatXXXX_macU.zip`: (32 bit) PPC ve Intel Mac'ler için zip'li evrensel program (Carbon)
- `praatXXXX_macX.zip`: MacOS X (PPC) için zip'li program
- `praatXXXX_mac9.sit`: MacOS 9 için StuffIt arşivi
- `praatXXXX_mac9.zip`: MacOS 9 için zip'li program
- `praatXXXX_mac7.sit`: MacOS 7 için StuffIt arşivi

### 1.3. Linux
- **`praatXXXX_linux-x64v3-barren.tar.gz`: Intel64/AMD64(v3) Linux (Ubuntu, Debian...) için arayüzsüz, sessiz ve grafiksiz program**
- **`praatXXXX_linux-x64v3.tar.gz`: Intel64/AMD64(v3) Linux (Ubuntu, Debian...) için program (GTK 3)**
- **`praatXXXX_linux-s390x-barren.tar.gz`: s390x Linux için arayüzsüz, sessiz ve grafiksiz program**
- **`praatXXXX_linux-s390x.tar.gz`: s390x Linux için program (GTK 3)**
- **`praatXXXX_linux-arm64-barren.tar.gz`: ARM64 Linux (Ubuntu, Debian...) için arayüzsüz, sessiz ve grafiksiz program**
- **`praatXXXX_linux-arm64.tar.gz`: ARM64 Linux (Ubuntu, Debian...) için program (GTK 3)**
- `praatXXXX_linux-intel64-barren.tar.gz`: Intel64/AMD64(v1) Linux (Ubuntu, Debian...) için arayüzsüz, sessiz ve grafiksiz program
- `praatXXXX_linux-intel64.tar.gz`: Intel64/AMD64(v1) Linux (Ubuntu, Debian...) için program (GTK 3)
- `praatXXXX_linux-arm64-nogui.tar.gz`: ARM64 Linux için arayüzsüz ve sessiz, grafikli (Cairo ve Pango) program
- `praatXXXX_linux-intel64-nogui.tar.gz`: Intel64/AMD64 Linux için arayüzsüz ve sessiz, grafikli (Cairo ve Pango) program
- `praatXXXX_linux64barren.tar.gz`: Intel64/AMD64 Linux için arayüzsüz, sessiz ve grafiksiz program
- `praatXXXX_linux64nogui.tar.gz`: Intel64/AMD64 Linux için arayüzsüz ve sessiz, grafikli (Cairo ve Pango) program
- `praatXXXX_linux64.tar.gz`: Intel64/AMD64 Linux için program (GTK 2 ya da 3)
- `praatXXXX_linux32.tar.gz`: Intel32 Linux için program (GTK 2)
- `praatXXXX_linux_motif64.tar.gz`: Intel64/AMD64 Linux için program (Motif)
- `praatXXXX_linux_motif32.tar.gz`: Intel32 Linux için program (Motif)

Linux dosyalarının hepsi gzip ile sıkıştırılmış tar arşividir.

### 1.4. Chromebook
- **`praatXXXX_chrome-x64v1.tar.gz`: Intel64/AMD64 Chromebook'larda Intel64/AMD64(v1) Linux için program (GTK 3)**
- **`praatXXXX_chrome-arm64.tar.gz`: ARM64 Chromebook'larda Linux için program (GTK 3)**
- `praatXXXX_chrome-intel64.tar.gz`: Intel64/AMD64 Chromebook'larda Intel64/AMD64(v1) Linux için program (GTK 3)
- `praatXXXX_chrome64.tar.gz`: Intel64/AMD64 Chromebook'larda 64 bit Linux için program (GTK 2 ya da 3)

### 1.5. Raspberry Pi
- **`praatXXXX_rpi-armv7.tar.gz`: Raspberry Pi 4B'de (32 bit) ARMv7 Linux için program (GTK 3)**
- `praatXXXX_rpi_armv7.tar.gz`: Raspberry Pi 4B'de (32 bit) ARMv7 Linux için program (GTK 2 ya da 3)

### 1.6. Diğer Unix sistemleri (hepsi eski)
- `praatXXXX_solaris.tar.gz`: Sun Solaris için program
- `praatXXXX_sgi.tar.gz`: Silicon Graphics Iris için program
- `praatXXXX_hpux.tar.gz`: HP-UX (Hewlett-Packard Unix) için program

## 2. Kaynak kodu derlemek

Praat'ın kaynak koduna yalnızca şu durumlarda ihtiyacınız olur:

1. Praat'a C ya da C++ kodu ekleyerek yeni işlevler kazandırmak istiyorsanız;
2. Praat'ın kaynak kodunu anlamak ya da yeniden kullanmak istiyorsanız;
3. Praat'ı hazır programı bulunmayan bir bilgisayar için derlemek istiyorsanız
(örneğin Intel dışı bazı bilgisayarlarda Linux, FreeBSD, HP-UX, SGI ya da SPARC Solaris).

Kaynak koduna dalmadan önce Praat programının nasıl çalıştığını ve Praat scripti yazmayı bilmeniz gerekir.
Praat programı https://praat.org ya da https://www.fon.hum.uva.nl/praat adresinden indirilebilir.

### 2.1. Lisans

Praat'ın kaynak kodunun çoğu GitHub'da GNU Genel Kamu Lisansı (GPL),
[sürüm 2](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html) ya da sonrası,
veya [sürüm 3](https://praat.org/manual/General_Public_License__version_3.html) ya da sonrası ile dağıtılır.
Ancak Praat başkalarının yazdığı yazılımları da içerdiği için,
Praat'ın bütünü GNU Genel Kamu Lisansı [sürüm 3](https://praat.org/manual/General_Public_License__version_3.html) ya da sonrası ile dağıtılır.
Praat'a dahil edilen başka yazılım kütüphanelerinin lisansları için [Acknowledgments](https://praat.org/manual/Acknowledgments.html) sayfasına bakın.
Praat kaynak koduna yapılan her iyileştirme yazarlar tarafından elbette memnuniyetle karşılanır.

Bu Türkçe sürüm de GPL 3 ya da sonrası ile dağıtılır, lisans metni [LICENSE](https://github.com/Underday/Praat-turkish/blob/main/LICENSE) dosyasında.

### 2.2. Arşivi indirmek

Praat'ın en güncel kaynak kodunu GitHub'dan indirmek için
son sürümdeki *zip* ya da *tar.gz* arşivine tıklayın,
ya da sonraki herhangi bir değişiklikte praat/praat deposunu çatallayın ("clone").

### 2.3. Praat'ı genişletmek isterseniz izlenecek adımlar

Önce kaynak kodun olduğu gibi derlenebildiğinden emin olun.
Sonra `main/main_Praat.cpp` ya da `fon/praat_Fon.cpp` dosyasını düzenleyerek kendi düğmelerinizi ekleyin.
Ayrıntı için kılavuzdaki [Programming](https://praat.org/manual/Programming_with_Praat.html) sayfasına bakın.

### 2.4. Programlama dili

Kaynak kodun çoğu C++ ile, bazı bölümleri C ile yazılmıştır.
Kod, derleyicinizin C99 ve C++17 desteklemesini gerektirir.

## 3. Praat'ı tek bir platform için geliştirmek

[HOW_TO_BUILD_ONE.md](https://github.com/Underday/Praat-turkish/blob/main/HOW_TO_BUILD_ONE.md) dosyasına bakın (İngilizce).

## 4. Praat'ı bütün platformlar için aynı anda geliştirmek

[HOW_TO_BUILD_ALL.md](https://github.com/Underday/Praat-turkish/blob/main/HOW_TO_BUILD_ALL.md) dosyasına bakın (İngilizce).
