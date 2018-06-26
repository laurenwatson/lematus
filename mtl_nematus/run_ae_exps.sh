languages=( English )
for lang in "${languages[@]}"
do
    # for data set in data/languages/Latvian-20-char-context parameters are:
    ./train_ae_model_10.sh ${lang} 20-char-context ae-50p-run1
    ./train_ae_model_10.sh ${lang} 20-char-context ae-50p-run2
    ./train_ae_model_10.sh ${lang} 20-char-context ae-50p-run3
    # where v1 is an experiment identifier (can be any string)
done
