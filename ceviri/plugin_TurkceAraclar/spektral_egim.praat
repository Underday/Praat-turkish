# spektral_egim.praat
# Seçili Sound nesneleri için spektral eğim ölçüleri:
# H1-H2, H1-A1, H1-A3 (düzeltilmemiş), LTAS eğimi ve alfa oranı.
# This file is free software under the GNU General Public License, version 3 or later.

include ortak.praat

form Spectral tilt measures
	positive Pitch_floor_(Hz) 75
	positive Pitch_ceiling_(Hz) 500
	positive Maximum_formant_(Hz) 5500
	natural Number_of_measurement_points 20
	sentence Csv_file_(optional)
endform

sesler# = selected# ("Sound")
writeInfoLine: "Spectral tilt measures"
appendInfoLine: "(H1-H2, H1-A1 and H1-A3 are uncorrected for formant frequencies and bandwidths)"
if csv_file$ <> ""
	writeFileLine: csv_file$, "file,h1_h2_db,h1_a1_db,h1_a3_db,ltas_slope_db,alpha_ratio_db"
endif
for i to size (sesler#)
	selectObject: sesler# [i]
	ad$ = selected$ ("Sound")
	@spektralEgim: sesler# [i], 0, 0, pitch_floor, pitch_ceiling, number_of_measurement_points, maximum_formant
	appendInfoLine: ""
	appendInfoLine: "Sound: ", ad$
	@yaz: "H1-H2", spektralEgim.h1h2, 2, " dB"
	@yaz: "H1-A1", spektralEgim.h1a1, 2, " dB"
	@yaz: "H1-A3", spektralEgim.h1a3, 2, " dB"
	@yaz: "LTAS slope (0-1 kHz vs 1-10 kHz)", spektralEgim.ltasEgimi, 2, " dB"
	@yaz: "Alpha ratio (50-1000 Hz vs 1-5 kHz)", spektralEgim.alfa, 2, " dB"
	if csv_file$ <> ""
		satir$ = """" + ad$ + """"
		@sayi: spektralEgim.h1h2, 2
		satir$ = satir$ + "," + sayi.s$
		@sayi: spektralEgim.h1a1, 2
		satir$ = satir$ + "," + sayi.s$
		@sayi: spektralEgim.h1a3, 2
		satir$ = satir$ + "," + sayi.s$
		@sayi: spektralEgim.ltasEgimi, 2
		satir$ = satir$ + "," + sayi.s$
		@sayi: spektralEgim.alfa, 2
		satir$ = satir$ + "," + sayi.s$
		appendFileLine: csv_file$, satir$
	endif
endfor
selectObject: sesler#
