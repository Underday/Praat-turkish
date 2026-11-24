# ses_kalitesi_klasor.praat
# Bir klasördeki bütün .wav dosyaları için ses kalitesi ölçümleri, sonuç bir CSV dosyasında.
# This file is free software under the GNU General Public License, version 3 or later.

include ortak.praat

form Voice quality of folder
	sentence Folder
	positive Pitch_floor_(Hz) 75
	positive Pitch_ceiling_(Hz) 500
	optionmenu Trend_line_fit_(CPPS) 1
		option Robust
		option Least squares
	sentence Csv_file voice_quality.csv
endform

if folder$ = ""
	folder$ = chooseFolder$ ("Folder with sound files")
endif
csvYolu$ = csv_file$
if not (startsWith (csvYolu$, "/") or index (csvYolu$, ":") = 2)
	csvYolu$ = folder$ + "/" + csvYolu$
endif
@sesDosyalari: folder$
@sesKalitesiCsvBasligi: csvYolu$
writeInfoLine: "Voice quality of folder: ", folder$
for i to sesDosyalari.n
	dosya$ = sesDosyalari.dosyalar$# [i]
	ses = Read from file: folder$ + "/" + dosya$
	@sesKalitesi: ses, 0, 0, pitch_floor, pitch_ceiling, trend_line_fit$
	@sesKalitesiCsvSatiri: csvYolu$, dosya$
	appendInfoLine: dosya$, tab$, "Jitter (local): ", fixed$ (sesKalitesi.jitYerel * 100, 3), " %", tab$, "HNR: ", fixed$ (sesKalitesi.hnr, 2), " dB", tab$, "CPPS: ", fixed$ (sesKalitesi.cpps, 2), " dB"
	removeObject: ses
endfor
appendInfoLine: ""
appendInfoLine: "Number of files: ", sesDosyalari.n
appendInfoLine: "CSV file: ", csvYolu$
