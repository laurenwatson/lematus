#!/bin/sh

lang='English'

python translate.py \
     -m models_1/${lang}-20-char-context-base1/model.npz \
     -i tiny_data/languages_1/${lang}-20-char-context/dev-sources \
     -o tiny_data/languages_1/${lang}-20-char-context/dev-hypothesis \
     -k 12 -n -p 1
