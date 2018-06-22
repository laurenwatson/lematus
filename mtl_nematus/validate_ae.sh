#!/bin/sh

lang='English'

python trans_1.py \
     -m models_10/English-20-char-context-ae100/model.npz \
     -i tiny_data/languages_10/${lang}-20-char-context/dev-sources \
     -o tiny_data/languages_10/${lang}-20-char-context/dev-hypothesis-ae1 \
     -k 12 -n -p 1
