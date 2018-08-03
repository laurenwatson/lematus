#!/bin/sh
lang=English
langs=(${lang})

run=1
mid=-3-pos-ae-10p-1k-testrun


for lang in "${langs[@]}"
do

  python trans_pos.py \
       -m models_1/${lang}-20-char-context-${mid}${run}/model.npz \
       -i models_1/${lang}-20-char-context-${mid}${run}/data/dev-sources \
       -o models_1/${lang}-20-char-context-${mid}${run}/data/dev-hypothesis-pos${run} \
       -k 12 -n -p 1

  #python trans_ae.py \
  #     -m models_1/${lang}-20-char-context-${mid}${run}/model.npz \
  #     -i models_1/${lang}-20-char-context-${mid}${run}/data/dev-sources \
  #     -o models_1/${lang}-20-char-context-${mid}${run}/data/dev-hypothesis-ae${run} \
  #     -k 12 -n -p 1

  #python trans_1.py \
  #     -m models_1/${lang}-20-char-context-${mid}${run}/model.npz \
  #     -i models_1/${lang}-20-char-context-${mid}${run}/data/dev-sources \
  #     -o models_1/${lang}-20-char-context-${mid}${run}/data/dev-hypothesis-main${run} \
  #     -k 12 -n -p 1


done
