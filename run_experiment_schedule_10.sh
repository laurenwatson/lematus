#!/bin/bash

languages=( French )
for lang in "${languages[@]}"
do
    # for data set in data/languages/Latvian-20-char-context parameters are:
    ./train_10.sh ${lang} 20-char-context base2
    # where v1 is an experiment identifier (can be any string)
done
