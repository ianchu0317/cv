#!/usr/bin/env bash
# Genera las miniaturas y la imagen para redes a partir de los PDFs.
# Requiere: poppler-utils (pdftoppm), webp (cwebp), imagemagick.
#   Ubuntu/Debian: sudo apt install poppler-utils webp imagemagick
#   macOS:         brew install poppler webp imagemagick
set -euo pipefail

for pair in "cv.pdf:en" "cv-esp.pdf:es"; do
  pdf="${pair%%:*}"; lang="${pair##*:}"
  pdftoppm -png -r 110 -singlefile -f 1 -l 1 "$pdf" "cv-preview-$lang"
  cwebp -quiet -q 85 "cv-preview-$lang.png" -o "cv-preview-$lang.webp"
  rm "cv-preview-$lang.png"
done

# Imagen Open Graph 1200x630: parte superior de la primera página del CV en inglés
pdftoppm -png -scale-to-x 1200 -scale-to-y -1 -singlefile -f 1 -l 1 cv.pdf og-tmp
magick og-tmp.png -gravity north -crop 1200x630+0+0 +repage og.png
rm og-tmp.png
echo "Listo: cv-preview-en.webp, cv-preview-es.webp, og.png"