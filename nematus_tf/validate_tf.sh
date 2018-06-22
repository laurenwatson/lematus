#!/bin/sh

model_type=Full_model
lang=English

python translate.py \
     -m ${model_type}/${lang}-20-char-context-base1/model.npz \
     -i ${model_type}/${lang}-20-char-context-base1/data/dev-sources \
     -o ${model_type}/${lang}-20-char-context-base1/data/dev-hypothesis \
     -k 12 -n -p 1
