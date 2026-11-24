# ortak.praat
# Türkçe araçlar eklentisinin ortak yordamları. Öteki scriptler bunu "include" ile alır.
# Ölçümler Praat'ın kendi komutlarıyla yapılır. Jitter, shimmer ve HNR değerleri
# Praat'ın "Voice report" çıktısından okunur, böylece ses raporuyla birebir aynıdır.
#
# This file is free software under the GNU General Public License, version 3 or later.

# Seçili tek Sound için ses kalitesi ölçümleri (tmin = tmax = 0 ise bütün ses).
# Sonuçlar .alan değişkenlerinde döner. Ölçülemeyen değerler undefined olur.
# .uyum$: CPPS eğilim çizgisi uydurması, "Robust" (tekrarlanabilir) ya da "Least squares" (hızlı, değerler farklı).
# Praat formlarının varsayılanı "Robust slow" rastgele örnekleme kullanır, her çalıştırmada biraz farklı sonuç verir.
procedure sesKalitesi: .ses, .tmin, .tmax, .f0min, .f0max, .uyum$
	selectObject: .ses
	if .tmin = 0 and .tmax = 0
		.tmin = Get start time
		.tmax = Get end time
	endif
	.sure = .tmax - .tmin
	.pitch = To Pitch (raw cross-correlation): 0, .f0min, .f0max, 15, "no", 0.03, 0.45, 0.01, 0.35, 0.14
	selectObject: .ses, .pitch
	.noktalar = To PointProcess (cc)
	selectObject: .ses, .pitch, .noktalar
	.rapor$ = Voice report: .tmin, .tmax, .f0min, .f0max, 1.3, 1.6, 0.03, 0.45
	.f0ortanca = extractNumber (.rapor$, "Median pitch: ")
	.f0ort = extractNumber (.rapor$, "Mean pitch: ")
	.f0sd = extractNumber (.rapor$, "Standard deviation: ")
	.f0enAz = extractNumber (.rapor$, "Minimum pitch: ")
	.f0enCok = extractNumber (.rapor$, "Maximum pitch: ")
	.otumsuz = extractNumber (.rapor$, "Fraction of locally unvoiced frames: ")
	.kirilma = extractNumber (.rapor$, "Number of voice breaks: ")
	.jitYerel = extractNumber (.rapor$, "Jitter (local): ")
	.jitRap = extractNumber (.rapor$, "Jitter (rap): ")
	.jitPpq5 = extractNumber (.rapor$, "Jitter (ppq5): ")
	.shimYerel = extractNumber (.rapor$, "Shimmer (local): ")
	.shimDb = extractNumber (.rapor$, "Shimmer (local, dB): ")
	.shimApq3 = extractNumber (.rapor$, "Shimmer (apq3): ")
	.shimApq5 = extractNumber (.rapor$, "Shimmer (apq5): ")
	.shimApq11 = extractNumber (.rapor$, "Shimmer (apq11): ")
	.hnr = extractNumber (.rapor$, "Mean harmonics-to-noise ratio: ")
	removeObject: .pitch, .noktalar
	# CPPS: Praat'ın kepstrogram ayarları, eğilim çizgisi uydurması seçilebilir (yukarıdaki nota bakın).
	selectObject: .ses
	.parca = Extract part: .tmin, .tmax, "rectangular", 1, "no"
	.kepstrogram = To PowerCepstrogram: 60, 0.002, 5000, 50
	.cpps = Get CPPS: "yes", 0.02, 0.0005, 60, 330, 0.05, "parabolic", 0.001, 0.05, "Straight", .uyum$
	removeObject: .parca, .kepstrogram
endproc

# Spektral eğim ölçüleri. H1-H2, H1-A1 ve H1-A3 düzeltilmemiş (formant bant genişliği düzeltmesi yok).
# Ötümlü bölgede eşit aralıklı .noktaSayisi noktada ölçülür, ortalaması verilir.
procedure spektralEgim: .ses, .tmin, .tmax, .f0min, .f0max, .noktaSayisi, .enYuksekFormant
	selectObject: .ses
	if .tmin = 0 and .tmax = 0
		.tmin = Get start time
		.tmax = Get end time
	endif
	.pitch = To Pitch (raw cross-correlation): 0, .f0min, .f0max, 15, "no", 0.03, 0.45, 0.01, 0.35, 0.14
	selectObject: .ses
	.formant = To Formant (burg): 0, 5, .enYuksekFormant, 0.025, 50
	.h1h2 = 0
	.h1a1 = 0
	.h1a3 = 0
	.sayi = 0
	for .i to .noktaSayisi
		.t = .tmin + (.i - 0.5) * (.tmax - .tmin) / .noktaSayisi
		selectObject: .pitch
		.f0 = Get value at time: .t, "Hertz", "linear"
		selectObject: .formant
		.f1 = Get value at time: 1, .t, "hertz", "linear"
		.f3 = Get value at time: 3, .t, "hertz", "linear"
		if .f0 <> undefined and .f1 <> undefined and .f3 <> undefined
			# Üç periyotluk Gauss penceresi
			.pencere = 3 / .f0
			selectObject: .ses
			.kesit = Extract part: .t - .pencere, .t + .pencere, "Gaussian1", 1, "no"
			.spektrum = To Spectrum: "yes"
			.ltas = To Ltas (1-to-1)
			.h1 = Get maximum: .f0 * 0.9, .f0 * 1.1, "none"
			.h2 = Get maximum: .f0 * 1.9, .f0 * 2.1, "none"
			.a1 = Get maximum: .f1 * 0.9, .f1 * 1.1, "none"
			.a3 = Get maximum: .f3 * 0.9, .f3 * 1.1, "none"
			removeObject: .kesit, .spektrum, .ltas
			.h1h2 += .h1 - .h2
			.h1a1 += .h1 - .a1
			.h1a3 += .h1 - .a3
			.sayi += 1
		endif
	endfor
	if .sayi > 0
		.h1h2 /= .sayi
		.h1a1 /= .sayi
		.h1a3 /= .sayi
	else
		.h1h2 = undefined
		.h1a1 = undefined
		.h1a3 = undefined
	endif
	removeObject: .pitch, .formant
	# Uzun süreli ortalama spektrum eğimleri
	selectObject: .ses
	.parca = Extract part: .tmin, .tmax, "rectangular", 1, "no"
	.ltas = To Ltas: 100
	.ltasEgimi = Get slope: 0, 1000, 1000, 10000, "energy"
	.alfa = Get slope: 50, 1000, 1000, 5000, "energy"
	removeObject: .parca, .ltas
endproc

# Bir aralığın temel ölçümleri: süre, perde, şiddet, orta noktada F1 F2 F3, spektral momentler.
procedure aralikOlcumu: .ses, .tmin, .tmax, .f0min, .f0max, .enYuksekFormant
	.f0ort = undefined
	.sure = .tmax - .tmin
	selectObject: .ses
	.parca = Extract part: .tmin, .tmax, "rectangular", 1, "yes"
	.pitch = To Pitch (raw cross-correlation): 0, .f0min, .f0max, 15, "no", 0.03, 0.45, 0.01, 0.35, 0.14
	.f0ort = Get mean: 0, 0, "Hertz"
	.f0enAz = Get minimum: 0, 0, "Hertz", "parabolic"
	.f0enCok = Get maximum: 0, 0, "Hertz", "parabolic"
	selectObject: .parca
	if .sure > 6.4 / .f0min
		.intensity = To Intensity: .f0min, 0, "yes"
		.siddet = Get mean: 0, 0, "energy"
		removeObject: .intensity
	else
		.siddet = undefined
	endif
	selectObject: .parca
	.formant = To Formant (burg): 0, 5, .enYuksekFormant, 0.025, 50
	.orta = (.tmin + .tmax) / 2
	.f1 = Get value at time: 1, .orta, "hertz", "linear"
	.f2 = Get value at time: 2, .orta, "hertz", "linear"
	.f3 = Get value at time: 3, .orta, "hertz", "linear"
	selectObject: .parca
	.spektrum = To Spectrum: "yes"
	.agirlikMerkezi = Get centre of gravity: 2
	.spektralSd = Get standard deviation: 2
	.carpiklik = Get skewness: 2
	.basiklik = Get kurtosis: 2
	removeObject: .parca, .pitch, .formant, .spektrum
endproc

# CSV için sayı biçimi: tanımsızsa "NA".
procedure sayi: .x, .basamak
	if .x = undefined
		.s$ = "NA"
	else
		.s$ = fixed$ (.x, .basamak)
	endif
endproc

# Klasördeki .wav dosyaları (Windows ve macOS'ta büyük küçük harf ayrımı yok, Linux'ta .WAV da aranır).
procedure sesDosyalari: .klasor$
	.kucuk$# = fileNames$# (.klasor$ + "/*.wav")
	.n = size (.kucuk$#)
	.nBuyuk = 0
	if unix
		.buyuk$# = fileNames$# (.klasor$ + "/*.WAV")
		.nBuyuk = size (.buyuk$#)
	endif
	.dosyalar$# = empty$# (.n + .nBuyuk)
	for .i to .n
		.dosyalar$# [.i] = .kucuk$# [.i]
	endfor
	for .i to .nBuyuk
		.dosyalar$# [.n + .i] = .buyuk$# [.i]
	endfor
	.n += .nBuyuk
endproc

# Bilgi penceresine "Etiket: değer birim" satırı. Etiket İngilizcedir, ekranda sözlükle çevrilir.
procedure yaz: .etiket$, .x, .basamak, .birim$
	if .x = undefined
		appendInfoLine: "   ", .etiket$, ": --undefined--"
	else
		appendInfoLine: "   ", .etiket$, ": ", fixed$ (.x, .basamak), .birim$
	endif
endproc

# Ses kalitesi sonuçlarını Bilgi penceresine yazar (@sesKalitesi sonrasında).
procedure sesKalitesiniYaz
	@yaz: "Duration", sesKalitesi.sure, 3, " s"
	@yaz: "Median pitch", sesKalitesi.f0ortanca, 2, " Hz"
	@yaz: "Mean pitch", sesKalitesi.f0ort, 2, " Hz"
	@yaz: "Standard deviation", sesKalitesi.f0sd, 2, " Hz"
	@yaz: "Minimum pitch", sesKalitesi.f0enAz, 2, " Hz"
	@yaz: "Maximum pitch", sesKalitesi.f0enCok, 2, " Hz"
	@yaz: "Fraction of locally unvoiced frames", sesKalitesi.otumsuz * 100, 2, " %"
	@yaz: "Number of voice breaks", sesKalitesi.kirilma, 0, ""
	@yaz: "Jitter (local)", sesKalitesi.jitYerel * 100, 3, " %"
	@yaz: "Jitter (rap)", sesKalitesi.jitRap * 100, 3, " %"
	@yaz: "Jitter (ppq5)", sesKalitesi.jitPpq5 * 100, 3, " %"
	@yaz: "Shimmer (local)", sesKalitesi.shimYerel * 100, 3, " %"
	@yaz: "Shimmer (local, dB)", sesKalitesi.shimDb, 3, " dB"
	@yaz: "Shimmer (apq3)", sesKalitesi.shimApq3 * 100, 3, " %"
	@yaz: "Shimmer (apq5)", sesKalitesi.shimApq5 * 100, 3, " %"
	@yaz: "Shimmer (apq11)", sesKalitesi.shimApq11 * 100, 3, " %"
	@yaz: "Mean harmonics-to-noise ratio", sesKalitesi.hnr, 2, " dB"
	@yaz: "CPPS", sesKalitesi.cpps, 2, " dB"
endproc

procedure sesKalitesiCsvBasligi: .dosya$
	writeFileLine: .dosya$, "file,start,end,duration,f0_median,f0_mean,f0_sd,f0_min,f0_max,unvoiced_pct,voice_breaks,jitter_local_pct,jitter_rap_pct,jitter_ppq5_pct,shimmer_local_pct,shimmer_local_db,shimmer_apq3_pct,shimmer_apq5_pct,shimmer_apq11_pct,hnr_db,cpps_db"
endproc

procedure sesKalitesiCsvSatiri: .dosya$, .ad$
	.s$ = """" + .ad$ + """"
	@ekle: sesKalitesi.tmin, 3
	@ekle: sesKalitesi.tmax, 3
	@ekle: sesKalitesi.sure, 3
	@ekle: sesKalitesi.f0ortanca, 2
	@ekle: sesKalitesi.f0ort, 2
	@ekle: sesKalitesi.f0sd, 2
	@ekle: sesKalitesi.f0enAz, 2
	@ekle: sesKalitesi.f0enCok, 2
	@ekle: sesKalitesi.otumsuz * 100, 2
	@ekle: sesKalitesi.kirilma, 0
	@ekle: sesKalitesi.jitYerel * 100, 3
	@ekle: sesKalitesi.jitRap * 100, 3
	@ekle: sesKalitesi.jitPpq5 * 100, 3
	@ekle: sesKalitesi.shimYerel * 100, 3
	@ekle: sesKalitesi.shimDb, 3
	@ekle: sesKalitesi.shimApq3 * 100, 3
	@ekle: sesKalitesi.shimApq5 * 100, 3
	@ekle: sesKalitesi.shimApq11 * 100, 3
	@ekle: sesKalitesi.hnr, 2
	@ekle: sesKalitesi.cpps, 2
	appendFileLine: .dosya$, .s$
endproc

# sesKalitesiCsvSatiri.s$ sonuna virgülle bir sayı ekler.
procedure ekle: .x, .basamak
	@sayi: .x, .basamak
	sesKalitesiCsvSatiri.s$ = sesKalitesiCsvSatiri.s$ + "," + sayi.s$
endproc

procedure aralikCsvBasligi: .dosya$
	writeFileLine: .dosya$, "file,tier,interval,label,start,end,duration,f0_mean,f0_min,f0_max,intensity_db,f1_mid,f2_mid,f3_mid,cog,spectral_sd,skewness,kurtosis"
endproc

procedure aralikCsvSatiri: .dosya$, .ad$, .katman, .aralik, .etiket$
	.s$ = """" + .ad$ + """," + string$ (.katman) + "," + string$ (.aralik) + ",""" + replace$ (.etiket$, """", """""", 0) + """"
	for .k to 14
		if .k = 1
			.x = aralikOlcumu.tmin
		elsif .k = 2
			.x = aralikOlcumu.tmax
		elsif .k = 3
			.x = aralikOlcumu.sure
		elsif .k = 4
			.x = aralikOlcumu.f0ort
		elsif .k = 5
			.x = aralikOlcumu.f0enAz
		elsif .k = 6
			.x = aralikOlcumu.f0enCok
		elsif .k = 7
			.x = aralikOlcumu.siddet
		elsif .k = 8
			.x = aralikOlcumu.f1
		elsif .k = 9
			.x = aralikOlcumu.f2
		elsif .k = 10
			.x = aralikOlcumu.f3
		elsif .k = 11
			.x = aralikOlcumu.agirlikMerkezi
		elsif .k = 12
			.x = aralikOlcumu.spektralSd
		elsif .k = 13
			.x = aralikOlcumu.carpiklik
		else
			.x = aralikOlcumu.basiklik
		endif
		@sayi: .x, 3
		.s$ = .s$ + "," + sayi.s$
	endfor
	appendFileLine: .dosya$, .s$
endproc

# Bir TextGrid'in bir katmanındaki etiketli aralıkları ölçer ve CSV'ye yazar.
# Katman nokta katmanıysa ya da etiketli aralık yoksa bütün ses tek aralık olarak ölçülür.
procedure etiketliAraliklar: .ses, .tg, .katman, .ad$, .csv$, .f0min, .f0max, .enYuksekFormant
	.sayi = 0
	selectObject: .tg
	.araliKatmani = Is interval tier: .katman
	if .araliKatmani
		.n = Get number of intervals: .katman
		for .i to .n
			selectObject: .tg
			.etiket$ = Get label of interval: .katman, .i
			if .etiket$ <> ""
				.bas = Get start time of interval: .katman, .i
				.son = Get end time of interval: .katman, .i
				@aralikOlcumu: .ses, .bas, .son, .f0min, .f0max, .enYuksekFormant
				@aralikCsvSatiri: .csv$, .ad$, .katman, .i, .etiket$
				.sayi += 1
				appendInfoLine: .ad$, tab$, .etiket$, tab$, fixed$ (aralikOlcumu.sure, 3), " s", tab$, "F1 ", fixed$ (aralikOlcumu.f1, 0), tab$, "F2 ", fixed$ (aralikOlcumu.f2, 0)
			endif
		endfor
	endif
endproc
