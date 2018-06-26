#!/bin/sh

lang='Turkish'

python trans_1.py \
     -m models_10/${lang}-20-char-context-ae-100-run1/model.npz \
     -i models_10/${lang}-20-char-context-ae-100-run1/data/dev-sources \
     -o models_10/${lang}-20-char-context-ae-100-run1/data/dev-hypothesis-ae1 \
     -k 12 -n -p 1

python trans_1.py \
     -m models_10/${lang}-20-char-context-ae-100-run2/model.npz \
     -i models_10/${lang}-20-char-context-ae-100-run2/data/dev-sources \
     -o models_10/${lang}-20-char-context-ae-100-run2/data/dev-hypothesis-ae2 \
     -k 12 -n -p 1

python trans_1.py \
     -m models_10/${lang}-20-char-context-ae-100-run3/model.npz \
     -i models_10/${lang}-20-char-context-ae-100-run3/data/dev-sources \
     -o models_10/${lang}-20-char-context-ae-100-run3/data/dev-hypothesis-ae3 \
     -k 12 -n -p 1
