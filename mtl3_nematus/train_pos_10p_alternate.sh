lang=$1
type='20-char-context'
run=$2
experiment_id=$3
size=$4
basedir=.
datadir=tiny_data/languages_${size}/${lang}-${type}
modeldir=${basedir}/models_${size}/${lang}-${type}-${experiment_id}${run}

mkdir -p ${modeldir}
mkdir -p ${modeldir}/data

#theano compilation directory
base_compiledir=tf
mkdir -p ${base_compiledir}

cp ${basedir}/validate.sh ${modeldir}/.

echo "Copying data sets"
cp ${datadir}/train-* ${modeldir}/data/.
cp ${datadir}/test-* ${modeldir}/data/.
cp ${datadir}/dev-* ${modeldir}/data/.

echo "Building Dictionaries"
python ../data/build_dictionary.py ${modeldir}/data/train-sources ${modeldir}/data/train-targets
python ../data/build_dictionary.py ${modeldir}/data/train-sources ${modeldir}/data/train-ae-targets
python ../data/build_dictionary.py ${modeldir}/data/train-sources ${modeldir}/data/train-pos-targets
python ../data/build_dictionary.py ${modeldir}/data/dev-sources ${modeldir}/data/dev-targets
python ../data/build_dictionary.py ${modeldir}/data/dev-sources ${modeldir}/data/dev-ae-targets
python ../data/build_dictionary.py ${modeldir}/data/dev-sources ${modeldir}/data/dev-pos-targets
python ../data/build_dictionary.py ${modeldir}/data/test-sources ${modeldir}/data/test-targets
python ../data/build_dictionary.py ${modeldir}/data/test-sources ${modeldir}/data/test-ae-targets
python ../data/build_dictionary.py ${modeldir}/data/test-sources ${modeldir}/data/test-pos-targets


dim_word=300
dim=100
batch_size=60

n_words_src=($(wc -l ${modeldir}/data/train-sources.json))
n_words_src=$((n_words_src-1))

n_words_trg=($(wc -l ${modeldir}/data/train-targets.json))
n_words_trg=$((n_words_trg-1))

n_words_ae_trg=($(wc -l ${modeldir}/data/train-ae-targets.json))
n_words_ae_trg=$((n_words_ae_trg-1))

n_words_pos_trg=($(wc -l ${modeldir}/data/train-pos-targets.json))
n_words_pos_trg=$((n_words_pos_trg-1))

maxlen=75

optimizer="adam"

dispFreq=100

validate_every_n_epochs=10 #increase to make training faster
valid_freq=($(wc -l ${modeldir}/data/train-sources))
valid_freq=$((valid_freq / batch_size * ${validate_every_n_epochs}))

burn_in_for_n_epochs=0 #increase to make training faster
validBurnIn=($(wc -l ${modeldir}/data/train-sources))
validBurnIn=$((validBurnIn *${burn_in_for_n_epochs} / batch_size))

max_epochs=1000
echo 'target source things'
echo ${n_words_src}
echo ${n_words_trg}
echo ${n_words_ae_trg}
echo ${n_words_pos_trg}


##had to delete weight_normalization, valid_burnin and --reload, --reload \
#--no_reload_training_progress \
echo "Starting training"
CUDA_VISISBLE_DEVICES=0 python nmt.py \
  --model ${modeldir}/model.npz \
  --datasets ${modeldir}/data/train-sources ${modeldir}/data/train-targets ${modeldir}/data/train-ae-targets ${modeldir}/data/train-pos-targets \
  --valid_datasets ${modeldir}/data/dev-sources ${modeldir}/data/dev-targets ${modeldir}/data/dev-ae-targets ${modeldir}/data/dev-pos-targets \
  --dictionaries ${modeldir}/data/train-sources.json ${modeldir}/data/dev-targets.json ${modeldir}/data/dev-ae-targets.json ${modeldir}/data/dev-pos-targets.json \
  --dim_word ${dim_word} \
  --dim ${dim} \
  --n_words_src ${n_words_src} \
  --n_words ${n_words_trg} \
  --n_words_ae ${n_words_ae_trg} \
  --n_words_pos ${n_words_pos_trg} \
  --maxlen ${maxlen} \
  --optimizer ${optimizer} \
  --batch_size ${batch_size} \
  --dispFreq ${dispFreq} \
  --saveFreq 1000 \
  --run_alternate 1 \
  --max_epochs ${max_epochs} \
  --use_dropout \
  --enc_depth 2 \
  --dec_depth 2 \
  --patience 10 \
  --validFreq ${valid_freq} &> ${modeldir}/output_${lang}-${type}-${experiment_id}${run}.txt
echo "End of training"


#mid=${type}-${experiment_id}
#echo "Starting validation"
#./validate_pos.sh ${lang} ${mid} ${run}
#echo "End of validation"
