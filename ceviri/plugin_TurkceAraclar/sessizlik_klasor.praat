# sessizlik_klasor.praat
# Bir klasördeki .wav dosyaları için sessizlik ve konuşma bölümlerini bulur, her dosya için
# bir TextGrid kaydeder ve duraklama özetini CSV dosyasına yazar.
# This file is free software under the GNU General Public License, version 3 or later.

include ortak.praat

form Pause analysis of folder
	sentence Folder
	positive Pitch_floor_(Hz) 75
	real Silence_threshold_(dB) -25
	positive Minimum_pause_duration_(s) 0.15
	positive Minimum_sounding_duration_(s) 0.1
	boolean Save_TextGrids 1
	sentence Csv_file pauses.csv
endform

if folder$ = ""
	folder$ = chooseFolder$ ("Folder with sound files")
endif
csvYolu$ = csv_file$
if not (startsWith (csvYolu$, "/") or index (csvYolu$, ":") = 2)
	csvYolu$ = folder$ + "/" + csvYolu$
endif
@sesDosyalari: folder$
writeFileLine: csvYolu$, "file,duration,speech_time,pause_time,number_of_pauses,mean_pause,number_of_speech_parts,speech_ratio_pct"
writeInfoLine: "Pause analysis of folder: ", folder$
for i to sesDosyalari.n
	dosya$ = sesDosyalari.dosyalar$# [i]
	ses = Read from file: folder$ + "/" + dosya$
	sure = Get total duration
	intensity = To Intensity: pitch_floor, 0, "yes"
	tg = To TextGrid (silences): silence_threshold, minimum_pause_duration, minimum_sounding_duration, "silent", "sounding"
	n = Get number of intervals: 1
	konusma = 0
	duraklama = 0
	duraklamaSayisi = 0
	konusmaSayisi = 0
	for j to n
		etiket$ = Get label of interval: 1, j
		bas = Get start time of interval: 1, j
		son = Get end time of interval: 1, j
		if etiket$ = "sounding"
			konusma += son - bas
			konusmaSayisi += 1
		elsif j > 1 and j < n
			# Baştaki ve sondaki sessizlik duraklama sayılmaz.
			duraklama += son - bas
			duraklamaSayisi += 1
		endif
	endfor
	if save_TextGrids
		Save as text file: folder$ + "/" + left$ (dosya$, rindex (dosya$, ".") - 1) + ".TextGrid"
	endif
	ortalama = undefined
	if duraklamaSayisi > 0
		ortalama = duraklama / duraklamaSayisi
	endif
	@sayi: ortalama, 3
	appendFileLine: csvYolu$, """", dosya$, """,", fixed$ (sure, 3), ",", fixed$ (konusma, 3), ",", fixed$ (duraklama, 3), ",", duraklamaSayisi, ",", sayi.s$, ",", konusmaSayisi, ",", fixed$ (100 * konusma / sure, 1)
	appendInfoLine: dosya$, tab$, "Number of pauses: ", duraklamaSayisi, tab$, "Pause time: ", fixed$ (duraklama, 2), " s"
	removeObject: ses, intensity, tg
endfor
appendInfoLine: ""
appendInfoLine: "Number of files: ", sesDosyalari.n
appendInfoLine: "CSV file: ", csvYolu$
