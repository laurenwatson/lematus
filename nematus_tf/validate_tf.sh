#!/bin/sh

model_type=10k
lang=French

python translate.py \
     -m ../../Dissertation_Results/Baselines/${model_type}/${lang}/${lang}-20-char-context-base1/model.npz \
     -i ../../Dissertation_Results/Baselines/${model_type}/${lang}/${lang}-20-char-context-base1/data/dev-sources \
     -o ../../Dissertation_Results/Baselines/${model_type}/${lang}/${lang}-20-char-context-base1/data/dev-hypothesis-base1 \
     -k 12 -n -p 1

lang=Turkish

python translate.py \
    -m ../../Dissertation_Results/Baselines/${model_type}/${lang}/${lang}-20-char-context-base1/model.npz \
    -i ../../Dissertation_Results/Baselines/${model_type}/${lang}/${lang}-20-char-context-base1/data/dev-sources \
    -o ../../Dissertation_Results/Baselines/${model_type}/${lang}/${lang}-20-char-context-base1/data/dev-hypothesis-base1 \
    -k 12 -n -p 1
