#!/bin/bash

languages=( Latvian )
for lang in "${languages[@]}"
do
    # for data set in data/languages/Latvian-20-char-context parameters are:
    ./train.sh ${lang} 20-char-context v1
    # where v1 is an experiment identifier (can be any string)
done
