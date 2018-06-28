#!/bin/sh

langs=(English Turkish)

for lang in "${languages[@]}"
do
  python nematus_tf/translate.py \
       -m ../Dissertation_Results/AutoEncoding/10k/${lang}-20-char-context-ae-100p-run1/model.npz \
       -i ../Dissertation_Results/AutoEncoding/10k/${lang}-20-char-context-ae-100p-run1/data/dev-sources \
       -o ../Dissertation_Results/AutoEncoding/10k/${lang}-20-char-context-ae-100p-run1/data/dev-hypothesis-base1 \
       -k 12 -n -p 1

  python nematus_tf/translate.py \
      -m ../Dissertation_Results/AutoEncoding/10k/${lang}-20-char-context-ae-100p-run2/model.npz \
      -i ../Dissertation_Results/AutoEncoding/10k/${lang}-20-char-context-ae-100p-run2/data/dev-sources \
      -o ../Dissertation_Results/AutoEncoding/10k/${lang}-20-char-context-ae-100p-run2/data/dev-hypothesis-base2 \
      -k 12 -n -p 1

  python nematus_tf/translate.py \
      -m ../Dissertation_Results/AutoEncoding/10k/${lang}-20-char-context-ae-100p-run3/model.npz \
      -i ../Dissertation_Results/AutoEncoding/10k/${lang}-20-char-context-ae-100p-run3/data/dev-sources \
      -o ../Dissertation_Results/AutoEncoding/10k/${lang}-20-char-context-ae-100p-run3/data/dev-hypothesis-base3 \
      -k 12 -n -p 1
done
