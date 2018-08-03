#!/bin/sh

langs=(Hindi Hungarian French English Croatian Turkish)
nums=(1 2 3)

for lang in "${langs[@]}"
do
  for num in "${nums[@]}"
  do
    python nematus_tf/translate.py \
         -m ../Dissertation_Results/Baselines/1k/${lang}/${lang}-20-char-context-base${num}/model.npz \
         -i ../Dissertation_Results/Baselines/1k/${lang}/${lang}-20-char-context-base${num}/data/dev-sources \
         -o ../Dissertation_Results/Baselines/1k/${lang}/${lang}-20-char-context-base${num}/data/dev-hypothesis-base${num} \
         -k 12 -n -p 1
  done
done
