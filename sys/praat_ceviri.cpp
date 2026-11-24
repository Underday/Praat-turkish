/* praat_ceviri.cpp
 *
 * Praat > Settings > Interface language... komutu.
 * Komutun iç adı İngilizcedir, scriptlerde şöyle kullanılır:
 *    Interface language: "English"
 * Ekranda sözlük sayesinde "Arayüz dili..." olarak görünür.
 *
 * This file is free software under the GNU General Public License, version 3 or later.
 */

#include "praatP.h"
#include "praatM.h"

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

/* End of file praat_ceviri.cpp */
