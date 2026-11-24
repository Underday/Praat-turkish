#!/usr/bin/env bash
# Praat Türkçe (Linux paketi): Türkçe araçlar eklentisini Praat'ın tercih klasörüne kopyalar.
# Sözlük (ceviri_tr.tsv) praat dosyasının yanında durduğu sürece kurulum gerekmez.
# Kullanım: ./kur.sh          eklentiyi kur
#           ./kur.sh --kaldir eklentiyi kaldır
set -eu
BURASI=$(cd "$(dirname "$0")" && pwd)
HEDEF="${XDG_CONFIG_HOME:-$HOME/.config}/praat"
case "${1:-}" in
  --kaldir)
    rm -rf "$HEDEF/plugin_TurkceAraclar"
    echo "Kaldırıldı: $HEDEF/plugin_TurkceAraclar"
    exit 0 ;;
esac
mkdir -p "$HEDEF"
rm -rf "$HEDEF/plugin_TurkceAraclar"
cp -r "$BURASI/plugin_TurkceAraclar" "$HEDEF/"
echo "Kuruldu: $HEDEF/plugin_TurkceAraclar"
echo "Başlatmak için: $BURASI/praat"
