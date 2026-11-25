#ifndef _Gui_ceviri_h_
#define _Gui_ceviri_h_
/* Gui_ceviri.h
 *
 * Arayüz çevirisi (Türkçe yerelleştirme katmanı).
 *
 * Gui_tr () yalnızca ekranda görünen metni çevirir. Komutların iç adları
 * (praat_addAction, praat_addMenuCommand, script komutları) İngilizce kalır,
 * dolayısıyla eski scriptler değişmeden çalışır.
 *
 * Sözlük dosyası: sekmeyle ayrılmış iki sütun (İngilizce, Türkçe), UTF-8.
 * Aranan yerler, sırayla:
 *    1. PRAAT_CEVIRI ortam değişkenindeki yol ("0" ya da "yok" ise çeviri kapalı)
 *    2. <tercih klasörü>/ceviri_tr.tsv   (Linux: ~/.config/praat/ceviri_tr.tsv)
 *    3. programın kendi klasöründeki ceviri_tr.tsv
 * Dosya yoksa arayüz İngilizce kalır.
 *
 * PRAAT_CEVIRI_EKSIK=<dosya> verilirse, sözlükte bulunmayan her etiket
 * o dosyaya bir kez yazılır. Yeni çevirilecek dizgeleri toplamak için.
 *
 * This file is free software under the GNU General Public License, version 3 or later.
 */

#include "melder.h"

conststring32 Gui_tr (conststring32 english);

/*
	Düzenleyicilerin çizim alanındaki açıklamalar ("~ %%non-modifiable copy of sound").
	"%%" ya da "##" işaretinden sonraki ad çevrilir, simge korunur.
*/
conststring32 Gui_trLejant (conststring32 lejant);

/*
	printf biçim dizgeleri ("Total duration %f seconds"). Karşılıktaki % sayısı aynı olmalı.
*/
const char *Gui_trBicim (const char *bicim);

/*
	Bilgi penceresinde görünen metin. Yalnızca ekrana giden kopya çevrilir,
	scriptlerin info$ () ile okuduğu metin İngilizce kalır.
	PRAAT_CEVIRI_BILGI=0 ile kapatılabilir.
*/
conststring32 Gui_trMetin (conststring32 metin);

/*
	Arayüz dili ayarı. Varsayılan Türkçe. Değişiklik Praat yeniden açılınca geçerli olur.
*/
bool Gui_ceviri_turkceMi ();
void Gui_ceviri_turkceAyarla (bool turkce);

/*
	Çalışan programın (praat, Praat.exe) bulunduğu klasör. Bulunamazsa false.
*/
bool Gui_ceviri_programKlasoru (MelderFolder klasor);

/*
	Praat > Settings > Interface language... komutunu ekler (praat_ceviri.cpp).
*/
void praat_ceviri_addMenus ();

#endif
/* End of file Gui_ceviri.h */
