# aralik_olcum.praat
# Seçili Sound ve TextGrid: bir katmandaki bütün etiketli aralıklar için süre, perde, şiddet,
# orta noktada F1 F2 F3 ve spektral momentler. Sonuç CSV dosyasına ve Bilgi penceresine yazılır.
# This file is free software under the GNU General Public License, version 3 or later.

include ortak.praat

form Measure labelled intervals
	natural Tier 1
	positive Pitch_floor_(Hz) 75
	positive Pitch_ceiling_(Hz) 500
	positive Maximum_formant_(Hz) 5500
	sentence Csv_file intervals.csv
endform

ses = selected ("Sound")
tg = selected ("TextGrid")
selectObject: ses
ad$ = selected$ ("Sound")
writeInfoLine: "Measure labelled intervals"
@aralikCsvBasligi: csv_file$
@etiketliAraliklar: ses, tg, tier, ad$, csv_file$, pitch_floor, pitch_ceiling, maximum_formant
appendInfoLine: ""
appendInfoLine: "Number of intervals: ", etiketliAraliklar.sayi
appendInfoLine: "CSV file: ", csv_file$
selectObject: ses, tg
