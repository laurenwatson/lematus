#!/bin/sh
lang=$1
langs=(${lang})

mid=-$2
run=$3
type=Alternate
size=10k

for lang in "${langs[@]}"
do
  python trans_1.py \
       -m models_1/${lang}${mid}${run}/model.npz \
       -i models_1/${lang}${mid}${run}/data/dev-sources \
       -o models_1/${lang}${mid}${run}/data/dev-hypothesis-pos${run} \
       -k 12 -n -p 1
done
