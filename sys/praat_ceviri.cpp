/* praat_ceviri.cpp
 *
 * Praat > Settings > Interface language... komutu ve açılış penceresi
 * (çeviriyi yapan, sürüm, depoda yeni sürüm olup olmadığı).
 * Komutun iç adı İngilizcedir, scriptlerde şöyle kullanılır:
 *    Interface language: "English"
 * Ekranda sözlük sayesinde "Arayüz dili..." olarak görünür.
 *
 * This file is free software under the GNU General Public License, version 3 or later.
 */

#include "praatP.h"
#include "praatM.h"
#include "praat_script.h"
#include <vector>

/*
	Çeviri sürümü. Depoda yeni sürüm "tr-v0.2" biçiminde bir GitHub Release olarak yayımlanır.
*/
#define CEVIRI_SURUM  U"0.3"
#define CEVIRI_YAPAN  U"Underday"
#define CEVIRI_EPOSTA  U"github.com/Underday"
#define CEVIRI_DEPO_API  U"https://api.github.com/repos/Underday/Praat-turkish/releases/latest"
#define CEVIRI_DEPO_SAYFA  U"https://github.com/Underday/Praat-turkish/releases/latest"

FORM (SETTINGS__interfaceLanguage, U"Interface language", nullptr) {
	CHOICE (language, U"Interface language", 1)
		OPTION (U"Turkish")
		OPTION (U"English")
OK
	SET_OPTION (language, Gui_ceviri_turkceMi () ? 1 : 2)
DO
	PREFS
		const bool turkce = ( language == 1 );
		if (turkce != Gui_ceviri_turkceMi ()) {
			Gui_ceviri_turkceAyarla (turkce);
			if (! Melder_batch)
				Melder_warning (turkce
					? U"Arayüz Praat yeniden açıldığında Türkçe olacak.\n(The interface will be in Turkish after restarting Praat.)"
					: U"Arayüz Praat yeniden açıldığında İngilizce olacak.\n(The interface will be in English after restarting Praat.)"
				);
		}
	PREFS_END
}

void praat_ceviri_addMenus () {
	praat_addMenuCommand (U"Objects", U"Settings", U"-- interface language --", nullptr, 0, nullptr);
	praat_addMenuCommand (U"Objects", U"Settings", U"Interface language...", nullptr, GuiMenu_UNHIDABLE, SETTINGS__interfaceLanguage);
}

/*
	Açılış penceresi ayarları ceviri_ayar.txt içinde, dil satırının yanında tutulur:
		acilis_gizli: <o sırada bilinen en yeni sürüm>
	Bu satır varsa pencere yalnızca daha yeni bir sürüm çıkınca yeniden gösterilir.
*/
static bool ayarDosyasi (MelderFile dosya) {
	MelderFolder tercihKlasoru = Melder_preferencesFolder ();
	if (MelderFolder_isNull (tercihKlasoru))
		return false;
	MelderFolder_getFile (tercihKlasoru, U"ceviri_ayar.txt", dosya);
	return true;
}

static std::u32string ayarOku (conststring32 anahtar) {
	structMelderFile dosya { };
	if (! ayarDosyasi (& dosya) || ! MelderFile_exists (& dosya))
		return U"";
	try {
		autostring32 metin = MelderFile_readText (& dosya);
		const std::u32string tum (metin.get ()), aranan = std::u32string (anahtar) + U": ";
		size_t bas = 0;
		while (bas < tum.size ()) {
			size_t son = tum.find (U'\n', bas);
			if (son == std::u32string::npos)
				son = tum.size ();
			if (tum.compare (bas, aranan.size (), aranan) == 0)
				return tum.substr (bas + aranan.size (), son - bas - aranan.size ());
			bas = son + 1;
		}
	} catch (MelderError) {
		Melder_clearError ();
	}
	return U"";
}

static void ayarYaz (conststring32 anahtar, conststring32 deger) {
	structMelderFile dosya { };
	if (! ayarDosyasi (& dosya))
		return;
	std::u32string tum;
	try {
		if (MelderFile_exists (& dosya))
			tum = MelderFile_readText (& dosya).get ();
	} catch (MelderError) {
		Melder_clearError ();
	}
	const std::u32string aranan = std::u32string (anahtar) + U": ";
	std::u32string yeni;
	size_t bas = 0;
	while (bas < tum.size ()) {
		size_t son = tum.find (U'\n', bas);
		if (son == std::u32string::npos)
			son = tum.size ();
		if (son > bas && tum.compare (bas, aranan.size (), aranan) != 0)
			yeni += tum.substr (bas, son - bas) + U"\n";
		bas = son + 1;
	}
	if (deger)
		yeni += aranan + deger + U"\n";
	try {
		MelderFile_writeText_i (& dosya, yeni.c_str (), kMelder_textOutputEncoding::UTF8);
	} catch (MelderError) {
		Melder_clearError ();
	}
}

/*
	"tr-v0.2", "v0.2", "0.2" gibi etiketlerdeki sayılar. Boşsa sürüm okunamadı.
*/
static std::vector <long> surumSayilari (const std::u32string& etiket) {
	std::vector <long> sayilar;
	long sayi = -1;
	for (const char32 c : etiket) {
		if (c >= U'0' && c <= U'9') {
			sayi = ( sayi < 0 ? 0 : sayi * 10 ) + (c - U'0');
		} else if (sayi >= 0) {
			sayilar.push_back (sayi);
			sayi = -1;
		}
	}
	if (sayi >= 0)
		sayilar.push_back (sayi);
	return sayilar;
}

static bool dahaYeni (const std::u32string& a, const std::u32string& b) {
	std::vector <long> x = surumSayilari (a), y = surumSayilari (b);
	if (x.empty ())
		return false;
	while (x.size () < y.size ()) x.push_back (0);
	while (y.size () < x.size ()) y.push_back (0);
	return x > y;
}

/*
	GitHub'daki en son Release etiketini curl ile alır (Linux, macOS ve Windows 10 sonrası curl ile gelir).
	Bağlantı yoksa, depo erişilemiyorsa ya da Release yoksa boş döner.
*/
static std::u32string sonSurumuAl () {
	try {
		autostring32vector argumanlar (6);
		argumanlar [1] = Melder_dup (U"-s");
		argumanlar [2] = Melder_dup (U"-f");
		argumanlar [3] = Melder_dup (U"-m");
		argumanlar [4] = Melder_dup (U"4");
		argumanlar [5] = Melder_dup (U"-L");
		const conststring32 adres = Melder_getenv (U"PRAAT_CEVIRI_SURUM_ADRESI");   // sınama için, ör. file:///tmp/surum.json
		argumanlar [6] = Melder_dup (adres ? adres : CEVIRI_DEPO_API);
		autostring32 yanit = runSubprocess_STR (U"curl", 6, argumanlar.peek2 ());
		const std::u32string json (yanit.get ());
		size_t yer = json.find (U"\"tag_name\"");
		if (yer == std::u32string::npos)
			return U"";
		yer = json.find (U'"', json.find (U':', yer));
		if (yer == std::u32string::npos)
			return U"";
		const size_t son = json.find (U'"', yer + 1);
		if (son == std::u32string::npos)
			return U"";
		return json.substr (yer + 1, son - yer - 1);
	} catch (MelderError) {
		Melder_clearError ();
		return U"";
	}
}

static void indirmeSayfasiniAc () {
	try {
		autostring32vector argumanlar (1);
		argumanlar [1] = Melder_dup (CEVIRI_DEPO_SAYFA);
		#if defined (_WIN32)
			Melder_runSubprocess (U"explorer", 1, argumanlar.peek2 ());
		#elif defined (macintosh)
			Melder_runSubprocess (U"open", 1, argumanlar.peek2 ());
		#else
			Melder_runSubprocess (U"xdg-open", 1, argumanlar.peek2 ());
		#endif
	} catch (MelderError) {
		Melder_clearError ();   // explorer başarılı olsa da 1 döndürebilir
	}
}

static void acilisPenceresiniGoster () {
	const std::u32string sonSurum = sonSurumuAl ();
	const bool yeniVar = dahaYeni (sonSurum, CEVIRI_SURUM);
	const std::u32string gizli = ayarOku (U"acilis_gizli");
	if (! gizli.empty () && ! (yeniVar && dahaYeni (sonSurum, gizli.c_str () [0] == U'-' ? std::u32string (CEVIRI_SURUM) : gizli)))
		return;

	constexpr int GENISLIK = 440, SATIR = 25;
	const int x = Gui_LEFT_DIALOG_SPACING, sag = GENISLIK - Gui_RIGHT_DIALOG_SPACING;
	const int yukseklik = Gui_TOP_DIALOG_SPACING + 5 * SATIR + 4 * Gui_VERTICAL_DIALOG_SPACING_SAME
			+ 2 * Gui_VERTICAL_DIALOG_SPACING_DIFFERENT + Gui_CHECKBUTTON_HEIGHT + Gui_PUSHBUTTON_HEIGHT + Gui_BOTTOM_DIALOG_SPACING;
	GuiDialog pencere = GuiDialog_create (theCurrentPraatApplication -> topShell, 150, 120, GENISLIK, yukseklik,
			U"Turkish interface", nullptr, nullptr, GuiDialog_Modality::BLOCKING);
	int y = Gui_TOP_DIALOG_SPACING;
	auto satir = [&] (conststring32 metin, uint32 bayrak) {
		GuiLabel_createShown (pencere, x, sag, y, y + SATIR, metin, GuiLabel_CENTRE | bayrak);
		y += SATIR + Gui_VERTICAL_DIALOG_SPACING_SAME;
	};
	satir (U"Praat Turkish interface", GuiLabel_BOLD);
	satir (Melder_cat (Gui_tr (U"Version:"), U" ", CEVIRI_SURUM), 0);
	satir (Melder_cat (Gui_tr (U"Translation:"), U" ", CEVIRI_YAPAN), 0);
	satir (CEVIRI_EPOSTA, 0);
	y += Gui_VERTICAL_DIALOG_SPACING_DIFFERENT - Gui_VERTICAL_DIALOG_SPACING_SAME;
	if (yeniVar)
		satir (Melder_cat (Gui_tr (U"A new version is available:"), U" ", sonSurum.c_str ()), GuiLabel_BOLD);
	else if (sonSurum.empty ())
		satir (U"Could not check for updates.", 0);
	else
		satir (U"You are using the latest version.", 0);
	GuiCheckButton gosterme = GuiCheckButton_createShown (pencere, x, sag, y, y + Gui_CHECKBUTTON_HEIGHT,
			U"Do not show again until a new version", nullptr, nullptr, 0);
	y += Gui_CHECKBUTTON_HEIGHT + Gui_VERTICAL_DIALOG_SPACING_DIFFERENT;
	const int dugme = 200;
	if (yeniVar)
		GuiButton_createShown (pencere, x, x + dugme, y, y + Gui_PUSHBUTTON_HEIGHT,
				U"Open download page", nullptr, nullptr, 0);
	GuiButton_createShown (pencere, sag - Gui_OK_BUTTON_WIDTH, sag, y, y + Gui_PUSHBUTTON_HEIGHT,
			U"OK", nullptr, nullptr, GuiButton_DEFAULT);

	GuiThing_show (pencere);
	const integer tiklanan = GuiDialog_run (pencere);
	const bool gizle = GuiCheckButton_getValue (gosterme);
	GuiThing_hide (pencere);
	GuiObject_destroy (pencere -> d_widget);

	if (gizle)
		ayarYaz (U"acilis_gizli", sonSurum.empty () ? U"-" : sonSurum.c_str ());
	else if (! gizli.empty ())
		ayarYaz (U"acilis_gizli", nullptr);
	if (yeniVar && tiklanan == 1)
		indirmeSayfasiniAc ();
}

/*
	praat_run () ana döngüye girmeden çağırır. Pencere, Praat penceresi göründükten sonra çıkar.
	Script modunda ve PRAAT_CEVIRI_ACILIS=0 iken gösterilmez.
	PRAAT_CEVIRI_SURUM_ADRESI ile denetlenen adres değiştirilebilir (sınama için).
*/
void praat_ceviri_acilis () {
	if (Melder_batch)
		return;
	const conststring32 ortam = Melder_getenv (U"PRAAT_CEVIRI_ACILIS");
	if (ortam && str32equ (ortam, U"0"))
		return;
	Gui_addWorkProc ([] () { acilisPenceresiniGoster (); });
}

/*
	Programın yanındaki eklentiler. Paketteki plugin_TurkceAraclar klasörü Praat.exe (ya da praat)
	ile aynı klasörde durur, Praat açılırken buradan yüklenir. Kullanıcının kurulum yapması gerekmez.
	Aynı adlı eklenti tercih klasöründe de varsa (eski kur.bat ya da kur.sh kurulumu) programın
	yanındaki sürüm kullanılır, tercih klasöründeki atlanır (praat.cpp).
*/
bool praat_ceviri_programdaEklentiVar (conststring32 eklentiAdi) {
	structMelderFolder programKlasoru { }, eklentiKlasoru { };
	structMelderFile kurulum { };
	if (! Gui_ceviri_programKlasoru (& programKlasoru))
		return false;
	MelderFolder_getSubfolder (& programKlasoru, eklentiAdi, & eklentiKlasoru);
	MelderFolder_getFile (& eklentiKlasoru, U"setup.praat", & kurulum);
	return MelderFile_readable (& kurulum);
}

void praat_ceviri_programEklentileri () {
	structMelderFolder programKlasoru { };
	if (! Gui_ceviri_programKlasoru (& programKlasoru))
		return;
	structMelderFile arama { };
	MelderFolder_getFile (& programKlasoru, U"plugin_*", & arama);
	try {
		autoSTRVEC adlar = folderNames_STRVEC (MelderFile_peekPath (& arama));
		for (integer i = 1; i <= adlar.size; i ++) {
			structMelderFolder eklentiKlasoru { };
			structMelderFile kurulum { };
			MelderFolder_getSubfolder (& programKlasoru, adlar [i].get(), & eklentiKlasoru);
			MelderFolder_getFile (& eklentiKlasoru, U"setup.praat", & kurulum);
			if (! MelderFile_readable (& kurulum))
				continue;
			Melder_backgrounding = true;
			try {
				praat_executeScript_noGUI (& kurulum, false);
			} catch (MelderError) {
				Melder_flushError (Melder_upperCaseAppName(), U": plugin ", & kurulum, U" contains an error.");
			}
			Melder_backgrounding = false;
		}
	} catch (MelderError) {
		Melder_clearError ();   // klasör okunamadı
	}
}

/* End of file praat_ceviri.cpp */
