#!/bin/bash
languages=( English )
exp_id='pos-10p-10k-run'
for lang in "${languages[@]}"
do
    echo 'TRAINING'
    # language run experiment_id size
    ./train_pos_10p_alternate.sh ${lang} 2 ${exp_id} 10

    echo 'VALIDATING'
    # language run experiment_id
    ./validae_pos_aux.sh ${lang} 2  ${exp_id}

done
