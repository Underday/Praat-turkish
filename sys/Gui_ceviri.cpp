/* Gui_ceviri.cpp
 *
 * Arayüz çevirisi. Açıklama için Gui_ceviri.h dosyasına bakın.
 *
 * This file is free software under the GNU General Public License, version 3 or later.
 */

#include "Gui_ceviri.h"
#include <cstdio>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

namespace {

	std::unordered_map <std::u32string, std::u32string> sozluk;
	std::unordered_map <std::u32string, std::u32string> kelimeler;   // "@" ile başlayan satırlar
	std::vector <std::pair <std::u32string, std::u32string>> kaliplar;   // "~" ile başlayan satırlar
	std::unordered_map <std::string, std::string> bicimler;   // printf biçimleri, UTF-8
	std::unordered_set <std::u32string> eksikYazilanlar;
	bool yuklendi = false;
	bool kapali = false;
	bool bilgiKapali = false;
	FILE *eksikDosyasi = nullptr;

	bool sonuIle (const std::u32string& s, const std::u32string& ek) {
		return s.size () > ek.size () && s.compare (s.size () - ek.size (), ek.size (), ek) == 0;
	}

	integer yuzdeSayisi (const std::u32string& s) {
		integer n = 0;
		for (char32 c : s)
			if (c == U'%')
				n ++;
		return n;
	}

	integer yildizSayisi (const std::u32string& s) {
		integer n = 0;
		for (char32 c : s)
			if (c == U'*')
				n ++;
		return n;
	}

	void uyar (integer satirNo, const std::u32string& anahtar, conststring32 neden) {
		fprintf (stderr, "Praat çeviri: satır %ld, \"%s\": %s\n",
				(long) satirNo, (const char *) Melder_peek32to8 (anahtar.c_str ()), (const char *) Melder_peek32to8 (neden));
	}

	/*
		Bir anahtar "..." (diyalog açar), ":" (alt menü) ya da " -" (eylem düğmesi grubu)
		ile bitiyorsa, karşılığı da aynı ekle bitmeli. Bitmiyorsa ek eklenir ve uyarı verilir.
	*/
	const char32 *const korunacakEkler [] = { U"...", U":", U" -" };

	void satiriEkle (std::u32string satir, integer satirNo) {
		if (! satir.empty () && satir.back () == U'\r')
			satir.pop_back ();
		if (satir.empty () || satir [0] == U'#')
			return;
		const size_t sekme = satir.find (U'\t');
		if (sekme == std::u32string::npos || sekme == 0 || sekme + 1 >= satir.size ())
			return;
		std::u32string anahtar = satir.substr (0, sekme);
		std::u32string karsilik = satir.substr (sekme + 1);
		if (yuzdeSayisi (anahtar) != yuzdeSayisi (karsilik)) {
			uyar (satirNo, anahtar, U"% işaretlerinin sayısı tutmuyor, satır atlandı.");
			return;
		}
		if (anahtar [0] == U'@' && anahtar.size () > 1) {
			kelimeler [anahtar.substr (1)] = karsilik;
			return;
		}
		if (anahtar [0] == U'~' && anahtar.size () > 1) {
			anahtar.erase (0, 1);
			if (yildizSayisi (anahtar) != yildizSayisi (karsilik)) {
				uyar (satirNo, anahtar, U"* işaretlerinin sayısı tutmuyor, satır atlandı.");
				return;
			}
			kaliplar.emplace_back (anahtar, karsilik);
			return;
		}
		for (const char32 *ek : korunacakEkler) {
			if (sonuIle (anahtar, ek) && ! sonuIle (karsilik, ek)) {
				uyar (satirNo, anahtar, U"karşılıkta ek eksik, eklendi.");
				karsilik += ek;
			}
		}
		sozluk [anahtar] = karsilik;
	}

	void yukle () {
		const conststring32 ortam = Melder_getenv (U"PRAAT_CEVIRI");
		structMelderFile dosya { };
		if (ortam && ortam [0] != U'\0') {
			if (Melder_equ (ortam, U"0") || Melder_equ (ortam, U"yok")) {
				kapali = true;
				yuklendi = true;
				return;
			}
			Melder_pathToFile (ortam, & dosya);
		} else {
			MelderFolder tercihKlasoru = Melder_preferencesFolder ();
			if (MelderFolder_isNull (tercihKlasoru))
				return;   // henüz belirlenmedi, bir sonraki çağrıda yeniden dene
			MelderFolder_getFile (tercihKlasoru, U"ceviri_tr.tsv", & dosya);
		}
		if (! Gui_ceviri_turkceMi ()) {
			kapali = true;
			yuklendi = true;
			return;
		}
		yuklendi = true;
		if (! MelderFile_exists (& dosya)) {
			kapali = true;
			return;
		}
		try {
			autostring32 metin = MelderFile_readText (& dosya);
			std::u32string satir;
			integer satirNo = 0;
			for (const char32 *p = metin.get (); ; p ++) {
				if (*p == U'\n' || *p == U'\0') {
					satiriEkle (satir, ++ satirNo);
					satir.clear ();
					if (*p == U'\0')
						break;
				} else {
					satir += *p;
				}
			}
		} catch (MelderError) {
			Melder_clearError ();
			kapali = true;
			return;
		}
		const conststring32 bilgi = Melder_getenv (U"PRAAT_CEVIRI_BILGI");
		bilgiKapali = bilgi && (Melder_equ (bilgi, U"0") || Melder_equ (bilgi, U"yok"));
		const conststring32 eksikYolu = Melder_getenv (U"PRAAT_CEVIRI_EKSIK");
		if (eksikYolu && eksikYolu [0] != U'\0')
			eksikDosyasi = fopen (Melder_peek32to8 (eksikYolu), "a");
	}

	bool hazir () {
		if (! yuklendi)
			yukle ();
		return ! kapali;
	}

	const std::u32string *bul (const std::u32string& anahtar) {
		auto it = sozluk.find (anahtar);
		return it == sozluk.end () ? nullptr : & it -> second;
	}

	void eksikYaz (const std::u32string& anahtar) {
		if (eksikDosyasi && eksikYazilanlar.insert (anahtar).second) {
			fprintf (eksikDosyasi, "%s\n", (const char *) Melder_peek32to8 (anahtar.c_str ()));
			fflush (eksikDosyasi);
		}
	}

	/*
		Sözlükte tam eşleşme, yoksa eksiz biçimi arar ve eki geri ekler.
		Sonuç, işaretçinin geçerli kalması için sözlüğe kaydedilir.
	*/
	const std::u32string *ara (const std::u32string& anahtar) {
		if (const std::u32string *karsilik = bul (anahtar))
			return karsilik;
		for (const char32 *ek : korunacakEkler) {
			const std::u32string ekStr (ek);
			if (sonuIle (anahtar, ekStr)) {
				if (const std::u32string *kok = bul (anahtar.substr (0, anahtar.size () - ekStr.size ()))) {
					auto& yeni = sozluk [anahtar];
					yeni = *kok + ekStr;
					return & yeni;
				}
			}
		}
		return nullptr;
	}

	/*
		Bilgi penceresi: değer kısmındaki birim sözcükleri ("seconds") çevrilir.
		Sözcüğün başındaki "(" ve sonundaki ")", ",", "." korunur.
	*/
	std::u32string kelimeCevir (const std::u32string& metin) {
		if (kelimeler.empty ())
			return metin;
		std::u32string sonuc;
		size_t i = 0;
		while (i < metin.size ()) {
			if (metin [i] == U' ') {
				sonuc += U' ';
				i ++;
				continue;
			}
			size_t son = metin.find (U' ', i);
			if (son == std::u32string::npos)
				son = metin.size ();
			std::u32string kelime = metin.substr (i, son - i);
			size_t bas = 0, bit = kelime.size ();
			while (bas < bit && kelime [bas] == U'(')
				bas ++;
			while (bit > bas && (kelime [bit - 1] == U')' || kelime [bit - 1] == U',' || kelime [bit - 1] == U'.'))
				bit --;
			auto it = kelimeler.find (kelime.substr (bas, bit - bas));
			if (it != kelimeler.end ())
				sonuc += kelime.substr (0, bas) + it -> second + kelime.substr (bit);
			else
				sonuc += kelime;
			i = son;
		}
		return sonuc;
	}

	/*
		"~" kalıpları: "*" herhangi bir metni yakalar, karşılıktaki "*" yerlerine sırayla konur.
	*/
	bool kalipla (const std::u32string& satir, const std::u32string& kalip, const std::u32string& karsilik, std::u32string& sonuc) {
		std::vector <std::u32string> parcalar;
		size_t bas = 0;
		for (;;) {
			const size_t yildiz = kalip.find (U'*', bas);
			parcalar.push_back (kalip.substr (bas, yildiz == std::u32string::npos ? std::u32string::npos : yildiz - bas));
			if (yildiz == std::u32string::npos)
				break;
			bas = yildiz + 1;
		}
		if (satir.compare (0, parcalar [0].size (), parcalar [0]) != 0)
			return false;
		std::vector <std::u32string> yakalananlar;
		size_t konum = parcalar [0].size ();
		for (size_t k = 1; k < parcalar.size (); k ++) {
			const std::u32string& parca = parcalar [k];
			size_t bulunan;
			if (k == parcalar.size () - 1) {
				if (satir.size () < konum + parca.size () || satir.compare (satir.size () - parca.size (), parca.size (), parca) != 0)
					return false;
				bulunan = satir.size () - parca.size ();
			} else {
				bulunan = satir.find (parca, konum);
				if (bulunan == std::u32string::npos)
					return false;
			}
			yakalananlar.push_back (satir.substr (konum, bulunan - konum));
			konum = bulunan + parca.size ();
		}
		if (parcalar.size () == 1 && satir.size () != parcalar [0].size ())
			return false;
		sonuc.clear ();
		size_t y = 0;
		for (char32 c : karsilik) {
			if (c == U'*' && y < yakalananlar.size ())
				sonuc += kelimeCevir (yakalananlar [y ++]);
			else
				sonuc += c;
		}
		return true;
	}

	std::u32string satirCevir (const std::u32string& satir) {
		const size_t girinti = satir.find_first_not_of (U' ');
		if (girinti == std::u32string::npos)
			return satir;
		const std::u32string bas = satir.substr (0, girinti);
		const std::u32string icerik = satir.substr (girinti);
		if (const std::u32string *karsilik = ara (icerik))
			return bas + *karsilik;
		std::u32string sonuc;
		for (const auto& kalip : kaliplar)
			if (kalipla (icerik, kalip.first, kalip.second, sonuc))
				return bas + sonuc;
		const size_t ikiNokta = icerik.find (U": ");
		if (ikiNokta != std::u32string::npos && ikiNokta > 0) {
			const std::u32string etiket = icerik.substr (0, ikiNokta);
			if (const std::u32string *karsilik = ara (etiket))
				return bas + *karsilik + U": " + kelimeCevir (icerik.substr (ikiNokta + 2));
			eksikYaz (etiket);
			return bas + etiket + U": " + kelimeCevir (icerik.substr (ikiNokta + 2));
		}
		return bas + kelimeCevir (icerik);
	}

	std::u32string metinCevir (const std::u32string& metin) {
		std::u32string sonuc;
		size_t bas = 0;
		while (bas < metin.size ()) {
			size_t son = metin.find (U'\n', bas);
			if (son == std::u32string::npos) {
				sonuc += satirCevir (metin.substr (bas));
				break;
			}
			sonuc += satirCevir (metin.substr (bas, son - bas));
			sonuc += U'\n';
			bas = son + 1;
		}
		return sonuc;
	}

}

/*
	Arayüz dili ayarı <tercih klasörü>/ceviri_ayar.txt dosyasında tutulur ("dil: tr" ya da "dil: en").
	Praat'ın kendi tercih dosyası menüler kurulduktan sonra okunduğu için ayrı bir dosya kullanılır.
	Dosya yoksa arayüz Türkçe açılır.
*/
static bool ayarDosyasi (MelderFile dosya) {
	MelderFolder tercihKlasoru = Melder_preferencesFolder ();
	if (MelderFolder_isNull (tercihKlasoru))
		return false;
	MelderFolder_getFile (tercihKlasoru, U"ceviri_ayar.txt", dosya);
	return true;
}

bool Gui_ceviri_turkceMi () {
	structMelderFile dosya { };
	if (! ayarDosyasi (& dosya) || ! MelderFile_exists (& dosya))
		return true;
	try {
		autostring32 metin = MelderFile_readText (& dosya);
		return ! str32str (metin.get (), U"dil: en");
	} catch (MelderError) {
		Melder_clearError ();
		return true;
	}
}

void Gui_ceviri_turkceAyarla (bool turkce) {
	structMelderFile dosya { };
	if (! ayarDosyasi (& dosya))
		return;
	MelderFile_writeText_i (& dosya, turkce ? U"dil: tr\n" : U"dil: en\n", kMelder_textOutputEncoding::UTF8);
}

conststring32 Gui_tr (conststring32 english) {
	if (! english || english [0] == U'\0')
		return english;
	if (! hazir ())
		return english;
	const std::u32string anahtar (english);
	if (const std::u32string *karsilik = ara (anahtar))
		return karsilik -> c_str ();
	/*
		Düzenleyici menülerindeki alt öğeler baştaki boşluklarla girintilenir.
		Girinti korunur, sözlükte girintisiz biçim aranır.
	*/
	const size_t girinti = anahtar.find_first_not_of (U' ');
	if (girinti != 0 && girinti != std::u32string::npos) {
		const conststring32 ic = Gui_tr (english + girinti);
		if (ic != english + girinti) {
			auto& yeni = sozluk [anahtar];
			yeni = anahtar.substr (0, girinti) + ic;
			return yeni.c_str ();
		}
		return english;
	}
	/*
		Diyalog başlıkları "Sound: To Intensity" biçimindedir.
		Nesne türü (iki noktadan önceki kısım) korunur, komut adı çevrilir.
	*/
	const size_t ikiNokta = anahtar.find (U": ");
	if (ikiNokta != std::u32string::npos && ikiNokta > 0 && ikiNokta + 2 < anahtar.size ()
		&& anahtar.find (U' ') > ikiNokta)
	{
		if (const std::u32string *komut = bul (anahtar.substr (ikiNokta + 2))) {
			auto& yeni = sozluk [anahtar];
			yeni = anahtar.substr (0, ikiNokta + 2) + *komut;
			return yeni.c_str ();
		}
		/*
			Başlıkta "..." yoktur, sözlükte ise komut "..." ile kayıtlı olabilir.
		*/
		if (const std::u32string *komut = bul (anahtar.substr (ikiNokta + 2) + U"...")) {
			auto& yeni = sozluk [anahtar];
			yeni = anahtar.substr (0, ikiNokta + 2) + komut -> substr (0, komut -> size () - 3);
			return yeni.c_str ();
		}
	}
	eksikYaz (anahtar);
	return english;
}

conststring32 Gui_trLejant (conststring32 lejant) {
	if (! lejant || lejant [0] == U'\0' || ! hazir ())
		return lejant;
	const std::u32string metin (lejant);
	if (const std::u32string *onceki = bul (metin))
		return onceki -> c_str ();
	size_t isaret = metin.find (U"%%");   // italik açıklama: türetilmiş, değiştirilemez
	if (isaret == std::u32string::npos)
		isaret = metin.find (U"##");   // kalın açıklama: değiştirilebilir
	if (isaret == std::u32string::npos)
		return lejant;
	const std::u32string ad = metin.substr (isaret + 2);
	const std::u32string *karsilik = ara (ad);
	if (! karsilik) {
		eksikYaz (ad);
		return lejant;
	}
	auto& yeni = sozluk [metin];
	yeni = metin.substr (0, isaret + 2) + *karsilik;
	return yeni.c_str ();
}

const char *Gui_trBicim (const char *bicim) {
	if (! bicim || bicim [0] == '\0' || ! hazir ())
		return bicim;
	const std::string anahtar8 (bicim);
	auto onceki = bicimler.find (anahtar8);
	if (onceki != bicimler.end ())
		return onceki -> second.c_str ();
	std::u32string anahtar;
	for (unsigned char c : anahtar8) {
		if (c >= 128)
			return bicim;   // biçim dizgeleri ASCII, değilse dokunma
		anahtar += (char32) c;
	}
	const std::u32string *karsilik = ara (anahtar);
	if (! karsilik) {
		eksikYaz (anahtar);
		return bicim;
	}
	auto& yeni = bicimler [anahtar8];
	yeni = (const char *) Melder_peek32to8 (karsilik -> c_str ());
	return yeni.c_str ();
}

conststring32 Gui_trMetin (conststring32 metin) {
	if (! metin || metin [0] == U'\0' || ! hazir () || bilgiKapali)
		return metin;
	/*
		Bilgi penceresi her yazışta bütün metni yeniden alır.
		Önceki metin aynen başta duruyorsa yalnızca yeni eklenen satırlar çevrilir.
	*/
	static std::u32string oncekiGirdi, oncekiCikti;
	const std::u32string girdi (metin);
	if (! oncekiGirdi.empty () && oncekiGirdi.back () == U'\n'
		&& girdi.size () >= oncekiGirdi.size () && girdi.compare (0, oncekiGirdi.size (), oncekiGirdi) == 0)
	{
		oncekiCikti += metinCevir (girdi.substr (oncekiGirdi.size ()));
	} else {
		oncekiCikti = metinCevir (girdi);
	}
	oncekiGirdi = girdi;
	return oncekiCikti.c_str ();
}

/* End of file Gui_ceviri.cpp */
