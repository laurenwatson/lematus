#!/bin/bash

languages=( English )
for lang in "${languages[@]}"
do
    # for data set in data/languages/Latvian-20-char-context parameters are:
    ./train_pos_10p_alternate.sh ${lang} 2 
    # where v1 is an experiment identifier (can be any string)
done
