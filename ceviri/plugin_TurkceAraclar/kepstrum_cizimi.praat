# kepstrum_cizimi.praat
# Seçili Sound için kepstrum grafiği: bir zaman noktasındaki (yumuşatılmış) güç kepstrumu,
# eğilim çizgisi ve kepstral tepe (CPP) işaretli olarak Çizim penceresine çizilir.
# Bilgi penceresine o noktadaki CPP ve bütün sesin CPPS değeri yazılır.
# Ayarlar Praat'ın varsayılanlarıdır (eğilim çizgisi 1-50 ms, düz, gürbüz uyum).
# This file is free software under the GNU General Public License, version 3 or later.

include ortak.praat

form Cepstrum plot (CPP)
	positive Pitch_floor_(Hz) 60
	positive Pitch_ceiling_(Hz) 330
	real Time_(s,_0_=_middle) 0
	positive Maximum_quefrency_(s) 0.02
	boolean Erase_first 1
endform

ses = selected ("Sound")
ad$ = selected$ ("Sound")
bas = Get start time
son = Get end time
zaman = time
if zaman = 0
	zaman = (bas + son) / 2
endif

kepstrogram = To PowerCepstrogram: 60, 0.002, 5000, 50
cpps = Get CPPS: "yes", 0.02, 0.0005, pitch_floor, pitch_ceiling, 0.05, "parabolic", 0.001, 0.05, "Straight", "Robust"
yumusak = Smooth: 0.02, 0.0005
kepstrum = To PowerCepstrum (slice): zaman
tepeQ = Get quefrency of peak: pitch_floor, pitch_ceiling, "parabolic"
cpp = Get peak prominence: pitch_floor, pitch_ceiling, "parabolic", 0.001, 0.05, "Straight", "Robust"
egilimTepe = Get trend line value: tepeQ, 0.001, 0.05, "Straight", "Robust"
egilimBas = Get trend line value: 0.001, 0.001, 0.05, "Straight", "Robust"
egilimSon = Get trend line value: maximum_quefrency, 0.001, 0.05, "Straight", "Robust"

if erase_first
	Erase all
endif
Select outer viewport: 0, 7, 0, 4.5
Black
Line width: 1
Draw: 0, maximum_quefrency, 0, 0, "yes"
Marks bottom every: 1, 0.005, "yes", "yes", "no"
Red
Line width: 2
Draw line: 0.001, egilimBas, maximum_quefrency, egilimSon
Blue
Dotted line
Draw line: tepeQ, egilimTepe, tepeQ, egilimTepe + cpp
Solid line
Text: tepeQ, "left", egilimTepe + cpp, "bottom", " CPP = " + fixed$ (cpp, 2) + " dB"
Black
Line width: 1
Text top: "no", ad$ + ", t = " + fixed$ (zaman, 3) + " s, CPPS = " + fixed$ (cpps, 2) + " dB"

writeInfoLine: "Cepstrum plot (CPP)"
appendInfoLine: "Sound: ", ad$
@yaz: "Time", zaman, 3, " s"
@yaz: "Cepstral peak prominence (CPP)", cpp, 2, " dB"
@yaz: "Quefrency of peak", tepeQ * 1000, 2, " ms"
@yaz: "Frequency of peak", 1 / tepeQ, 1, " Hz"
@yaz: "CPPS (whole sound)", cpps, 2, " dB"

removeObject: kepstrogram, yumusak, kepstrum
selectObject: ses
