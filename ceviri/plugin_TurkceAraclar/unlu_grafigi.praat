# unlu_grafigi.praat
# Seçili Sound ve TextGrid: bir katmandaki etiketli aralıkların orta noktasında F1 ve F2
# ölçülür, Çizim penceresinde F1-F2 ünlü grafiği çizilir (eksenler ters, fonetik geleneği).
# This file is free software under the GNU General Public License, version 3 or later.

form Vowel chart (F1-F2)
	natural Tier 1
	positive Maximum_formant_(Hz) 5500
	positive F1_maximum_(Hz) 1200
	positive F2_maximum_(Hz) 3000
	boolean Erase_first 1
endform

ses = selected ("Sound")
tg = selected ("TextGrid")
selectObject: ses
formant = To Formant (burg): 0, 5, maximum_formant, 0.025, 50
if erase_first
	Erase all
endif
Select outer viewport: 0, 6, 0, 6
Axes: f2_maximum, 200, f1_maximum, 150
Draw inner box
Marks bottom every: 1, 500, "yes", "yes", "no"
Marks left every: 1, 200, "yes", "yes", "no"
Text bottom: "yes", "F2 (Hz)"
Text left: "yes", "F1 (Hz)"
selectObject: tg
n = Get number of intervals: tier
writeInfoLine: "Vowel chart (F1-F2)"
for i to n
	selectObject: tg
	etiket$ = Get label of interval: tier, i
	if etiket$ <> ""
		bas = Get start time of interval: tier, i
		son = Get end time of interval: tier, i
		orta = (bas + son) / 2
		selectObject: formant
		f1 = Get value at time: 1, orta, "hertz", "linear"
		f2 = Get value at time: 2, orta, "hertz", "linear"
		if f1 <> undefined and f2 <> undefined
			Text: f2, "centre", f1, "half", etiket$
			appendInfoLine: etiket$, tab$, "F1: ", fixed$ (f1, 0), " Hz", tab$, "F2: ", fixed$ (f2, 0), " Hz"
		endif
	endif
endfor
removeObject: formant
selectObject: ses, tg
