#!/bin/bash
#Author: Toms Bergmanis toms.bergmanis@gmail.com
UD_directory=ud-treebanks-v2.1 #change for other versions
languages=( Latvian ) # list of languages to process 
mkdir -p languages
for lang in "${languages[@]}"
do
    # This script rewrites sentences from UDT format to a format that is 
    # used by contexts.py (this inbetween was useful for other experiments 
    # that were not included in the original Lematus paper. 
    #For more details see extract_from_UDT.py
    python3 extract_from_UDT.py ${UD_directory} ${lang} 
done

N=( 20 ) # N - left and N-right sentence characters to extract 

for n in "${N[@]}"
do
    for lang in "${languages[@]}"
    do
        targetDir=languages/${lang}-${N}-char-context
        mkdir -p ${targetDir}

        python3 format_for_lematus.py $UD_directory/UD_${lang}/dev ${lang} dev ${n}
        mv dev-* ${targetDir}/.

        python3 format_for_lematus.py $UD_directory/UD_${lang}/train ${lang} train ${n}
        mv train-* ${targetDir}/.

        python3 format_for_lematus.py $UD_directory/UD_${lang}/test ${lang} test ${n}
        mv test-* ${targetDir}/.

    done
done
