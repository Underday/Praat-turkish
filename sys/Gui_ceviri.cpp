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

namespace {

	std::unordered_map <std::u32string, std::u32string> sozluk;
	std::unordered_set <std::u32string> eksikYazilanlar;
	bool yuklendi = false;
	bool kapali = false;
	FILE *eksikDosyasi = nullptr;

	bool sonuIle (const std::u32string& s, const std::u32string& ek) {
		return s.size () > ek.size () && s.compare (s.size () - ek.size (), ek.size (), ek) == 0;
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
		for (const char32 *ek : korunacakEkler) {
			if (sonuIle (anahtar, ek) && ! sonuIle (karsilik, ek)) {
				fprintf (stderr, "Praat çeviri: satır %ld, \"%s\" karşılığında \"%s\" eki eksik, eklendi.\n",
						(long) satirNo, (const char *) Melder_peek32to8 (anahtar.c_str ()), (const char *) Melder_peek32to8 (ek));
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
		const conststring32 eksikYolu = Melder_getenv (U"PRAAT_CEVIRI_EKSIK");
		if (eksikYolu && eksikYolu [0] != U'\0')
			eksikDosyasi = fopen (Melder_peek32to8 (eksikYolu), "a");
	}

	const std::u32string *bul (const std::u32string& anahtar) {
		auto it = sozluk.find (anahtar);
		return it == sozluk.end () ? nullptr : & it -> second;
	}

}

conststring32 Gui_tr (conststring32 english) {
	if (! english || english [0] == U'\0')
		return english;
	if (! yuklendi)
		yukle ();
	if (kapali)
		return english;
	const std::u32string anahtar (english);
	if (const std::u32string *karsilik = bul (anahtar))
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
		Ekli biçim sözlükte yoksa eksiz biçime bak ve eki geri ekle.
		Sonuç, işaretçinin geçerli kalması için sözlüğe kaydedilir.
	*/
	for (const char32 *ek : korunacakEkler) {
		const std::u32string ekStr (ek);
		if (sonuIle (anahtar, ekStr)) {
			if (const std::u32string *kok = bul (anahtar.substr (0, anahtar.size () - ekStr.size ()))) {
				auto& yeni = sozluk [anahtar];
				yeni = *kok + ekStr;
				return yeni.c_str ();
			}
		}
	}
	if (eksikDosyasi && eksikYazilanlar.insert (anahtar).second) {
		fprintf (eksikDosyasi, "%s\n", (const char *) Melder_peek32to8 (english));
		fflush (eksikDosyasi);
	}
	return english;
}

/* End of file Gui_ceviri.cpp */
