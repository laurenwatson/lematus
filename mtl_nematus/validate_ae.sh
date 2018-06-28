#!/bin/sh

langs=(English Turkish)

for lang in "${langs[@]}"
do
  python trans_1.py \
       -m ../../Dissertation_Results/AutoEncoding/10k/${lang}-20-char-context-ae-100p-run1/model.npz \
       -i ../../Dissertation_Results/AutoEncoding/10k/${lang}-20-char-context-ae-100p-run1/data/dev-sources \
       -o ../../Dissertation_Results/AutoEncoding/10k/${lang}-20-char-context-ae-100p-run1/data/dev-hypothesis-ae1 \
       -k 12 -n -p 1

  python nematus_tf/translate.py \
      -m ../../Dissertation_Results/AutoEncoding/10k/${lang}-20-char-context-ae-100p-run2/model.npz \
      -i ../../Dissertation_Results/AutoEncoding/10k/${lang}-20-char-context-ae-100p-run2/data/dev-sources \
      -o ../../Dissertation_Results/AutoEncoding/10k/${lang}-20-char-context-ae-100p-run2/data/dev-hypothesis-ae2 \
      -k 12 -n -p 1

  python nematus_tf/translate.py \
      -m ../../Dissertation_Results/AutoEncoding/10k/${lang}-20-char-context-ae-100p-run3/model.npz \
      -i ../../Dissertation_Results/AutoEncoding/10k/${lang}-20-char-context-ae-100p-run3/data/dev-sources \
      -o ../../Dissertation_Results/AutoEncoding/10k/${lang}-20-char-context-ae-100p-run3/data/dev-hypothesis-ae3 \
      -k 12 -n -p 1
done
