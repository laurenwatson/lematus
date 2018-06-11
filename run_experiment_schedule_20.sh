#!/bin/bash

languages=( Croatian )
for lang in "${languages[@]}"
do
    # for data set in data/languages/Latvian-20-char-context parameters are:
    ./train_20.sh ${lang} 20-char-context base1
    # where v1 is an experiment identifier (can be any string)
done
