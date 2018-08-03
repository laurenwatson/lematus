#!/bin/bash

languages=( English )
exp_id='-3-pos-ae-10p-1k-testrun'
for lang in "${languages[@]}"
do
    echo 'TRAINING'
    # language run experiment_id size
    ./train_pos_10p_alternate.sh ${lang} 1 ${exp_id} 1

  #  echo 'VALIDATING'
    # language run experiment_id
  #  ./validae_pos_aux.sh ${lang} 1 ${exp_id}

done
