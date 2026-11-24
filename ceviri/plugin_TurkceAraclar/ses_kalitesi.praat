# ses_kalitesi.praat
# Seçili Sound nesneleri için ses kalitesi raporu: perde, jitter, shimmer, HNR, CPPS.
# İsteğe bağlı olarak sonuçlar bir CSV dosyasına yazılır.
# This file is free software under the GNU General Public License, version 3 or later.

include ortak.praat

form Voice quality report
	positive Pitch_floor_(Hz) 75
	positive Pitch_ceiling_(Hz) 500
	sentence Csv_file_(optional)
endform

sesler# = selected# ("Sound")
writeInfoLine: "Voice quality report"
if csv_file$ <> ""
	@sesKalitesiCsvBasligi: csv_file$
endif
for i to size (sesler#)
	selectObject: sesler# [i]
	ad$ = selected$ ("Sound")
	@sesKalitesi: sesler# [i], 0, 0, pitch_floor, pitch_ceiling
	appendInfoLine: ""
	appendInfoLine: "Sound: ", ad$
	@sesKalitesiniYaz
	if csv_file$ <> ""
		@sesKalitesiCsvSatiri: csv_file$, ad$
	endif
endfor
if csv_file$ <> ""
	appendInfoLine: ""
	appendInfoLine: "CSV file: ", csv_file$
endif
selectObject: sesler#
