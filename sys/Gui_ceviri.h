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
 * Dosya yoksa arayüz İngilizce kalır.
 *
 * PRAAT_CEVIRI_EKSIK=<dosya> verilirse, sözlükte bulunmayan her etiket
 * o dosyaya bir kez yazılır. Yeni çevirilecek dizgeleri toplamak için.
 *
 * This file is free software under the GNU General Public License, version 3 or later.
 */

#include "melder.h"

conststring32 Gui_tr (conststring32 english);

#endif
/* End of file Gui_ceviri.h */
