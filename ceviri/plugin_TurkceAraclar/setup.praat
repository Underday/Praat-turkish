# setup.praat
# Türkçe araçlar eklentisi: Praat açılırken bu dosyayı çalıştırır ve komutları menülere ekler.
# Komutların iç adları İngilizcedir, ekranda Türkçe sözlükle çevrilir
# (arayüz dili İngilizce seçilirse İngilizce görünür).
# This file is free software under the GNU General Public License, version 3 or later.

# Sound seçiliyken
Add action command: "Sound", 0, "", 0, "", 0, "Turkish tools -", "", 0, ""
Add action command: "Sound", 0, "", 0, "", 0, "Voice quality report...", "Turkish tools -", 1, "ses_kalitesi.praat"
Add action command: "Sound", 0, "", 0, "", 0, "Spectral tilt measures...", "Voice quality report...", 1, "spektral_egim.praat"

# Sound ve TextGrid birlikte seçiliyken
Add action command: "Sound", 1, "TextGrid", 1, "", 0, "Turkish tools -", "", 0, ""
Add action command: "Sound", 1, "TextGrid", 1, "", 0, "Measure labelled intervals...", "Turkish tools -", 1, "aralik_olcum.praat"
Add action command: "Sound", 1, "TextGrid", 1, "", 0, "Vowel chart (F1-F2)...", "Measure labelled intervals...", 1, "unlu_grafigi.praat"
Add action command: "Sound", 1, "TextGrid", 1, "", 0, "Save labelled intervals as WAV files...", "Vowel chart (F1-F2)...", 1, "araliklari_kaydet.praat"

# Klasör işleri: Yeni menüsünde
Add menu command: "Objects", "New", "Turkish tools", "", 0, ""
Add menu command: "Objects", "New", "Voice quality of folder...", "Turkish tools", 1, "ses_kalitesi_klasor.praat"
Add menu command: "Objects", "New", "Measure folder...", "Voice quality of folder...", 1, "toplu_olcum.praat"
Add menu command: "Objects", "New", "Pause analysis of folder...", "Measure folder...", 1, "sessizlik_klasor.praat"
Add menu command: "Objects", "New", "Convert folder...", "Pause analysis of folder...", 1, "toplu_donustur.praat"
