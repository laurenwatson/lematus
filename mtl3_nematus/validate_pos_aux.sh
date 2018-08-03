#!/bin/sh
lang=Turkish
langs=(${lang})

run=2
mid=pos-10p-10k-run


for lang in "${langs[@]}"
do
  python trans_pos.py \
       -m models_10/${lang}-20-char-context-${mid}${run}/model.npz \
       -i models_10/${lang}-20-char-context-${mid}${run}/data/dev-sources \
       -o models_10/${lang}-20-char-context-${mid}${run}/data/dev-hypothesis-aux-pos${run} \
       -k 12 -n -p 1

  python trans_1.py \
       -m models_10/${lang}-20-char-context-${mid}${run}/model.npz \
       -i models_10/${lang}-20-char-context-${mid}${run}/data/dev-sources \
       -o models_10/${lang}-20-char-context-${mid}${run}/data/dev-hypothesis-main-pos${run} \
       -k 12 -n -p 1


done
