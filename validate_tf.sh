#!/bin/sh

lang='Turkish'

python nematus_tf/translate.py \
     -m models_10/${lang}-20-char-context-base1/model.npz \
     -i models_10/${lang}-20-char-context-base1/data/dev-sources \
     -o models_10/${lang}-20-char-context-base1/data/dev-hypothesis-base1 \
     -k 12 -n -p 1

python nematus_tf/translate.py \
    -m models_10/${lang}-20-char-context-base2/model.npz \
    -i models_10/${lang}-20-char-context-base2/data/dev-sources \
    -o models_10/${lang}-20-char-context-base2/data/dev-hypothesis-base2 \
    -k 12 -n -p 1

python nematus_tf/translate.py \
    -m models_10/${lang}-20-char-context-base3/model.npz \
    -i models_10/${lang}-20-char-context-base3/data/dev-sources \
    -o models_10/${lang}-20-char-context-base3/data/dev-hypothesis-base3 \
    -k 12 -n -p 1
