# toplu_donustur.praat
# Bir klasördeki .wav dosyalarını dönüştürür ve başka bir klasöre kaydeder:
# tek kanala indirme, yeniden örnekleme, bant geçiren süzgeç, düzey ayarı.
# Özgün dosyalara dokunulmaz.
# This file is free software under the GNU General Public License, version 3 or later.

include ortak.praat

form Convert folder
	sentence Input_folder
	sentence Output_folder
	boolean Convert_to_mono 1
	real New_sampling_frequency_(Hz,_0_=_keep) 0
	real Low_cutoff_frequency_(Hz,_0_=_none) 0
	real High_cutoff_frequency_(Hz,_0_=_none) 0
	optionmenu Normalization 1
		option none
		option peak 0.99
		option average intensity 70 dB
endform

if input_folder$ = ""
	input_folder$ = chooseFolder$ ("Folder with sound files")
endif
if output_folder$ = ""
	output_folder$ = chooseFolder$ ("Folder for the converted files")
endif
if output_folder$ = input_folder$
	exitScript: "The output folder must differ from the input folder."
endif
createFolder: output_folder$
@sesDosyalari: input_folder$
writeInfoLine: "Convert folder: ", input_folder$, " -> ", output_folder$
for i to sesDosyalari.n
	dosya$ = sesDosyalari.dosyalar$# [i]
	ses = Read from file: input_folder$ + "/" + dosya$
	kanal = Get number of channels
	if convert_to_mono and kanal > 1
		yeni = Convert to mono
		removeObject: ses
		ses = yeni
	endif
	if new_sampling_frequency > 0
		selectObject: ses
		yeni = Resample: new_sampling_frequency, 50
		removeObject: ses
		ses = yeni
	endif
	if low_cutoff_frequency > 0 or high_cutoff_frequency > 0
		selectObject: ses
		ust = high_cutoff_frequency
		if ust <= 0
			ust = Get sampling frequency
			ust = ust / 2
		endif
		yeni = Filter (pass Hann band): low_cutoff_frequency, ust, 100
		removeObject: ses
		ses = yeni
	endif
	selectObject: ses
	if normalization = 2
		Scale peak: 0.99
	elsif normalization = 3
		Scale intensity: 70
	endif
	Save as WAV file: output_folder$ + "/" + left$ (dosya$, rindex (dosya$, ".") - 1) + ".wav"
	appendInfoLine: dosya$
	removeObject: ses
endfor
appendInfoLine: ""
appendInfoLine: "Number of files: ", sesDosyalari.n
