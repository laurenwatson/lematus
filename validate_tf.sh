#!/bin/sh

lang='English'

python nematus_tf/translate.py \
     -m models_full/${lang}-20-char-context-base1/model.npz \
     -i data/languages/${lang}-20-char-context/dev-sources \
     -o data/languages/${lang}-20-char-context/dev-hypothesis-base1 \
     -k 12 -n -p 1
