# araliklari_kaydet.praat
# Seçili Sound ve TextGrid: bir katmandaki etiketli aralıkların her birini ayrı bir WAV
# dosyası olarak kaydeder. Dosya adı: <sıra>_<etiket>.wav
# This file is free software under the GNU General Public License, version 3 or later.

form Save labelled intervals as WAV files
	natural Tier 1
	sentence Output_folder
	real Margin_(s) 0
endform

ses = selected ("Sound")
tg = selected ("TextGrid")
if output_folder$ = ""
	output_folder$ = chooseFolder$ ("Folder for the WAV files")
endif
createFolder: output_folder$
selectObject: ses
sesBas = Get start time
sesSon = Get end time
selectObject: tg
n = Get number of intervals: tier
sayi = 0
writeInfoLine: "Save labelled intervals as WAV files"
for i to n
	selectObject: tg
	etiket$ = Get label of interval: tier, i
	if etiket$ <> ""
		bas = Get start time of interval: tier, i
		son = Get end time of interval: tier, i
		bas = max (sesBas, bas - margin)
		son = min (sesSon, son + margin)
		selectObject: ses
		parca = Extract part: bas, son, "rectangular", 1, "no"
		guvenli$ = replace_regex$ (etiket$, "[^A-Za-z0-9ÇĞİÖŞÜçğıöşü_-]", "_", 0)
		sayi += 1
		ad$ = output_folder$ + "/" + right$ ("000" + string$ (sayi), 3) + "_" + guvenli$ + ".wav"
		Save as WAV file: ad$
		removeObject: parca
		appendInfoLine: ad$
	endif
endfor
appendInfoLine: ""
appendInfoLine: "Number of files: ", sayi
selectObject: ses, tg
