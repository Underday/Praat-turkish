# toplu_olcum.praat
# Bir klasördeki .wav dosyaları. Aynı adlı bir .TextGrid varsa seçilen katmandaki etiketli
# aralıklar, yoksa bütün dosya ölçülür. Sonuç tek bir CSV dosyasında.
# This file is free software under the GNU General Public License, version 3 or later.

include ortak.praat

form Measure folder
	sentence Folder
	natural Tier 1
	positive Pitch_floor_(Hz) 75
	positive Pitch_ceiling_(Hz) 500
	positive Maximum_formant_(Hz) 5500
	sentence Csv_file measurements.csv
endform

if folder$ = ""
	folder$ = chooseFolder$ ("Folder with sound files")
endif
csvYolu$ = csv_file$
if not (startsWith (csvYolu$, "/") or index (csvYolu$, ":") = 2)
	csvYolu$ = folder$ + "/" + csvYolu$
endif
@sesDosyalari: folder$
@aralikCsvBasligi: csvYolu$
writeInfoLine: "Measure folder: ", folder$
toplam = 0
for i to sesDosyalari.n
	dosya$ = sesDosyalari.dosyalar$# [i]
	ses = Read from file: folder$ + "/" + dosya$
	tgYolu$ = folder$ + "/" + left$ (dosya$, rindex (dosya$, ".") - 1) + ".TextGrid"
	if fileReadable (tgYolu$)
		tg = Read from file: tgYolu$
		@etiketliAraliklar: ses, tg, tier, dosya$, csvYolu$, pitch_floor, pitch_ceiling, maximum_formant
		toplam += etiketliAraliklar.sayi
		removeObject: tg
	else
		selectObject: ses
		bas = Get start time
		son = Get end time
		@aralikOlcumu: ses, bas, son, pitch_floor, pitch_ceiling, maximum_formant
		@aralikCsvSatiri: csvYolu$, dosya$, 0, 0, ""
		toplam += 1
		appendInfoLine: dosya$, tab$, fixed$ (aralikOlcumu.sure, 3), " s"
	endif
	removeObject: ses
endfor
appendInfoLine: ""
appendInfoLine: "Number of files: ", sesDosyalari.n
appendInfoLine: "Number of intervals: ", toplam
appendInfoLine: "CSV file: ", csvYolu$
