#!/bin/sh

langs=(French)

mid=-20-char-context-ae-joint-a50-1k-run
type=Joint
size=1k
for lang in "${langs[@]}"
do
  python trans_2.py \
       -m ../../Dissertation_Results/AutoEncoding/${size}/${lang}/${type}/${lang}${mid}1/model.npz \
       -i ../../Dissertation_Results/AutoEncoding/${size}/${lang}/${type}/${lang}${mid}1/data/dev-sources \
       -o ../../Dissertation_Results/AutoEncoding/${size}/${lang}/${type}/${lang}${mid}1/data/dev-hypothesis-ae1 \
       -k 12 -n -p 1

  python trans_2.py \
      -m ../../Dissertation_Results/AutoEncoding/${size}/${lang}/${type}/${lang}${mid}2/model.npz \
      -i ../../Dissertation_Results/AutoEncoding/${size}/${lang}/${type}/${lang}${mid}2/data/dev-sources \
      -o ../../Dissertation_Results/AutoEncoding/${size}/${lang}/${type}/${lang}${mid}2/data/dev-hypothesis-ae2 \
      -k 12 -n -p 1

  python trans_2.py \
      -m ../../Dissertation_Results/AutoEncoding/${size}/${lang}/${type}/${lang}${mid}3/model.npz \
      -i ../../Dissertation_Results/AutoEncoding/${size}/${lang}/${type}/${lang}${mid}3/data/dev-sources \
      -o ../../Dissertation_Results/AutoEncoding/${size}/${lang}/${type}/${lang}${mid}3/data/dev-hypothesis-ae3 \
      -k 12 -n -p 1
done
