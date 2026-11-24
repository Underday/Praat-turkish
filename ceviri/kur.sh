#!/usr/bin/env bash
# Türkçe arayüz sözlüğünü ve Türkçe araçlar eklentisini Praat'ın tercih klasörüne kurar.
# Kullanım:
#   ceviri/kur.sh            sözlüğü kur (bağlantı olarak, depo güncellenince kendiliğinden güncel kalır)
#   ceviri/kur.sh --kopya    bağlantı yerine kopya kur
#   ceviri/kur.sh --kaldir   sözlüğü ve eklentiyi kaldır (arayüz İngilizceye döner)
#   ceviri/kur.sh --derle    önce Praat'ı derle, sonra sözlüğü kur
set -eu
DEPO=$(cd "$(dirname "$0")/.." && pwd)
SOZLUK="$DEPO/ceviri/ceviri_tr.tsv"
HEDEF_KLASOR="${XDG_CONFIG_HOME:-$HOME/.config}/praat"
HEDEF="$HEDEF_KLASOR/ceviri_tr.tsv"
EKLENTI="$DEPO/ceviri/plugin_TurkceAraclar"
EKLENTI_HEDEF="$HEDEF_KLASOR/plugin_TurkceAraclar"

case "${1:-}" in
  --kaldir)
    rm -f "$HEDEF"
    rm -rf "$EKLENTI_HEDEF"
    echo "Kaldırıldı: $HEDEF ve $EKLENTI_HEDEF"
    exit 0 ;;
  --derle)
    make -C "$DEPO" -j"$(nproc)"
    echo "Derlendi: $DEPO/praat" ;;
esac

mkdir -p "$HEDEF_KLASOR"
rm -f "$HEDEF"
rm -rf "$EKLENTI_HEDEF"
if [ "${1:-}" = "--kopya" ]; then
  cp "$SOZLUK" "$HEDEF"
  cp -r "$EKLENTI" "$EKLENTI_HEDEF"
else
  ln -s "$SOZLUK" "$HEDEF"
  ln -s "$EKLENTI" "$EKLENTI_HEDEF"
fi
echo "Kuruldu: $HEDEF"
echo "Kuruldu: $EKLENTI_HEDEF"
echo "Başlatmak için: $DEPO/praat"
