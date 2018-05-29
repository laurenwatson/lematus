#!/bin/bash
source venv/bin/activate
lang=$1
type=$2
experiment_id=$3

# theano device, in case you do not want to compute on gpu, change it to cpu
device=gpu0

basedir=.
datadir=${basedir}/data/languages
modeldir=${basedir}/models/${lang}-${type}-${experiment_id}
datadir=${basedir}/data/languages/${lang}-${type}

mkdir -p ${modeldir}
mkdir -p ${modeldir}/data

#theano compilation directory
base_compiledir=theano
mkdir -p ${base_compiledir}

cp ${basedir}/validate.sh ${modeldir}/.

echo "Copying data sets"
cp ${datadir}/train-* ${modeldir}/data/.
cp ${datadir}/test-* ${modeldir}/data/.
cp ${datadir}/dev-* ${modeldir}/data/.

echo "Building Dictionaries"
python ${basedir}/data/build_dictionary.py ${modeldir}/data/train-sources ${modeldir}/data/train-targets


dim_word=300
dim=100
batch_size=60

n_words_src=($(wc -l ${modeldir}/data/train-sources.json))
n_words_src=$((n_words_src-1))

n_words_trg=($(wc -l ${modeldir}/data/train-targets.json))
n_words_trg=$((n_words_trg-1))

maxlen=75

optimizer="adadelta"

dispFreq=100

validate_every_n_epochs=1 #increase to make training faster
valid_freq=($(wc -l ${modeldir}/data/train-sources))
valid_freq=$((valid_freq / batch_size * ${validate_every_n_epochs})) 

burn_in_for_n_epochs=10 #increase to make training faster
validBurnIn=($(wc -l ${modeldir}/data/train-sources))
validBurnIn=$((validBurnIn *${burn_in_for_n_epochs} / batch_size))

max_epochs=1000

echo "Sarting training"

THEANO_FLAGS=mode=FAST_RUN,floatX=float32,device=$device,base_compiledir=${base_compiledir} python ${basedir}/nematus/nmt.py \
    --model ${modeldir}/model.npz \
    --datasets ${modeldir}/data/train-sources ${modeldir}/data/train-targets \
    --valid_datasets ${modeldir}/data/dev-sources ${modeldir}/data/dev-targets \
    --dictionaries ${modeldir}/data/train-sources.json ${modeldir}/data/train-targets.json \
    --dim_word ${dim_word} \
    --dim ${dim} \
    --n_words_src ${n_words_src} \
    --n_words ${n_words_trg} \
    --maxlen ${maxlen} \
    --optimizer ${optimizer} \
    --batch_size ${batch_size} \
    --dispFreq ${dispFreq} \
    --max_epochs ${max_epochs} \
    --external_validation_script ${modeldir}/validate.sh \
    --weight_normalisation \
    --reload \
    --no_reload_training_progress \
    --use_dropout \
    --enc_depth 2 \
    --dec_depth 2 \
    --patience 10 \
    --validBurnIn ${validBurnIn} \
    --validFreq ${valid_freq} &>> ${modeldir}/training.log
echo "End of training"

echo "Lemmatizing test set"
THEANO_FLAGS=mode=FAST_RUN,floatX=float32,device=$device,on_unused_input=warn,base_compiledir=${base_compiledir} python ${basedir}/nematus/translate.py \
     -m ${modeldir}/best_model/model.npz \
     -i ${modeldir}/data/test-sources  \
     -o ${modeldir}/best_model/test-hypothesis \
     -k 12 -n -p 1

echo "Done"



