#!/usr/bin/env bash
# Türkçe arayüz sözlüğünü Praat'ın tercih klasörüne kurar.
# Kullanım:
#   ceviri/kur.sh            sözlüğü kur (bağlantı olarak, depo güncellenince kendiliğinden güncel kalır)
#   ceviri/kur.sh --kopya    bağlantı yerine kopya kur
#   ceviri/kur.sh --kaldir   sözlüğü kaldır (arayüz İngilizceye döner)
#   ceviri/kur.sh --derle    önce Praat'ı derle, sonra sözlüğü kur
set -eu
DEPO=$(cd "$(dirname "$0")/.." && pwd)
SOZLUK="$DEPO/ceviri/ceviri_tr.tsv"
HEDEF_KLASOR="${XDG_CONFIG_HOME:-$HOME/.config}/praat"
HEDEF="$HEDEF_KLASOR/ceviri_tr.tsv"

case "${1:-}" in
  --kaldir)
    rm -f "$HEDEF"
    echo "Kaldırıldı: $HEDEF"
    exit 0 ;;
  --derle)
    make -C "$DEPO" -j"$(nproc)"
    echo "Derlendi: $DEPO/praat" ;;
esac

mkdir -p "$HEDEF_KLASOR"
rm -f "$HEDEF"
if [ "${1:-}" = "--kopya" ]; then
  cp "$SOZLUK" "$HEDEF"
else
  ln -s "$SOZLUK" "$HEDEF"
fi
echo "Kuruldu: $HEDEF"
echo "Başlatmak için: $DEPO/praat"
