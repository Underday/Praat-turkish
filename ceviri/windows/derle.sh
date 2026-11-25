#!/usr/bin/env bash
# Linux üzerinde Windows (x64) için Praat.exe derler ve dağıtım zip'i hazırlar.
# Gerekenler (Arch): mingw-w64-gcc, rsync, zip
# Kullanım: ceviri/windows/derle.sh [çalışma klasörü]
# Varsayılan çalışma klasörü depo klasörünün yanındaki praat-win/ klasörüdür.
# Kaynaklar oraya kopyalanır, böylece Linux derlemesinin nesne dosyalarıyla karışmaz.
set -euo pipefail
DEPO=$(cd "$(dirname "$0")/../.." && pwd)
CALISMA=${1:-"$DEPO/../praat-win"}
ONEK=x86_64-w64-mingw32-

command -v ${ONEK}g++ >/dev/null || { echo "${ONEK}g++ yok. Kurmak için: sudo pacman -S mingw-w64-gcc"; exit 1; }

mkdir -p "$CALISMA"
rsync -a --delete \
  --exclude .git --exclude '*.o' --exclude '*.a' --exclude '/praat' --exclude '/praat_*' \
  --exclude '/Praat.exe' --exclude '/dagitim' \
  "$DEPO/" "$CALISMA/"

# Praat'ın zlib kopyasında zconf.h yok, Linux'ta sistemdeki dosya kullanılıyor.
# MinGW'de olmadığı için sistemdeki zconf.h çalışma klasörüne kopyalanır (zlib 1.3.x).
[ -f "$CALISMA/external/zlib/zconf.h" ] || cp /usr/include/zconf.h "$CALISMA/external/zlib/zconf.h"

# Arch'taki MinGW eski msvcrt kütüphanesini kullanır, %td gibi C99 biçimlerini tanımaz.
# Praat açılışta bunu denetler. MinGW'nin kendi printf/scanf sürümü bu yüzden açılır.
# (Praat'ın resmî derlemesi MSYS2 clang64, yani UCRT ile yapılır, orada bu gerekmez.)
make -C "$CALISMA" -j"$(nproc)" \
  PRAAT_OS=windows PRAAT_COMPILER=gcc PRAAT_ARCH=x64v1 \
  CC="${ONEK}gcc -D__USE_MINGW_ANSI_STDIO=1" CXX="${ONEK}g++ -D__USE_MINGW_ANSI_STDIO=1" LINKER_COMMAND=${ONEK}g++ \
  AR=${ONEK}ar RANLIB=${ONEK}ranlib WINDRES=${ONEK}windres

SURUM=$(grep -m1 'PRAAT_VERSION_STR' "$DEPO/main/main_Praat.h" | awk '{print $3}')
DAGITIM="$CALISMA/dagitim/Praat-tr-$SURUM-win-x64"
rm -rf "$DAGITIM"; mkdir -p "$DAGITIM"
cp "$CALISMA/Praat.exe" "$DAGITIM/"
${ONEK}strip "$DAGITIM/Praat.exe" || true
cp "$DEPO/ceviri/ceviri_tr.tsv" "$DAGITIM/"
cp "$DEPO/ceviri/windows/BENIOKU.txt" "$DAGITIM/"
cp "$DEPO/main/gpl-3.0.txt" "$DAGITIM/COPYING.txt"
rm -rf "$DAGITIM/plugin_TurkceAraclar"
cp -r "$DEPO/ceviri/plugin_TurkceAraclar" "$DAGITIM/"
( cd "$CALISMA/dagitim" && rm -f "Praat-tr-$SURUM-win-x64.zip" && zip -qr "Praat-tr-$SURUM-win-x64.zip" "Praat-tr-$SURUM-win-x64" )
echo "Hazır: $CALISMA/dagitim/Praat-tr-$SURUM-win-x64.zip"
