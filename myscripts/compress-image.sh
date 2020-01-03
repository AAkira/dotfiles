#!/bin/bash
argv=("$@")
for i in `seq 1 $#` 
do
  originFile="${argv[$i-1]}"    # with extension
  fileName=${originFile%.*}     # without extension
  compressedImage="$fileName-compressed"

  echo "Convert to webp[1920]: $originFile"
  sips -Z 1920 "$originFile" --out "$compressedImage.jpg"
  jpegoptim -s "$compressedImage.jpg"
  cwebp "$compressedImage.jpg" -o "$compressedImage.webp"
  rm "$compressedImage.jpg"
done

