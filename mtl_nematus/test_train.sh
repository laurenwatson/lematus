ource venv/bin/activate
lang='English'
type='20-char-context'
experiment_id='base1'

basedir=.
datadir=tiny_data/languages_1
modeldir=${basedir}/models_1/${lang}-${type}-${experiment_id}
datadir=${basedir}/tiny_data/languages_1/${lang}-${type}

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
python ../data/build_dictionary.py ${modeldir}/data/dev-sources ${modeldir}/data/dev-ae-targets
python ../data/build_dictionary.py ${modeldir}/data/test-sources ${modeldir}/data/test-ae-targets


dim_word=50
dim=20
batch_size=60

n_words_src=($(wc -l ${modeldir}/data/train-sources.json))
n_words_src=$((n_words_src-1))

n_words_trg=($(wc -l ${modeldir}/data/train-targets.json))
n_words_trg=$((n_words_trg-1))

n_words_ae_trg=($(wc -l ${modeldir}/data/train-ae-targets.json))
n_words_ae_trg=$((n_words_ae_trg-1))

maxlen=75

optimizer="adam"

dispFreq=100

validate_every_n_epochs=100 #increase to make training faster
valid_freq=($(wc -l ${modeldir}/data/train-sources))
valid_freq=$((valid_freq / batch_size * ${validate_every_n_epochs}))

burn_in_for_n_epochs=10 #increase to make training faster
validBurnIn=($(wc -l ${modeldir}/data/train-sources))
validBurnIn=$((validBurnIn *${burn_in_for_n_epochs} / batch_size))

max_epochs=1000

touch output_test_${lang}_${experiment_id}.txt
##had to delete weight_normalization, valid_burnin and --reload, --reload \
#--no_reload_training_progress \
echo "Starting training"
python nmt.py \
  --model ${modeldir}/model.npz \
  --datasets ${modeldir}/data/train-sources ${modeldir}/data/train-targets ${modeldir}/data/train-ae-targets \
  --valid_datasets ${modeldir}/data/dev-sources ${modeldir}/data/dev-targets ${modeldir}/data/dev-ae-targets \
  --dictionaries ${modeldir}/data/train-sources.json ${modeldir}/data/train-targets.json ${modeldir}/data/train-ae-targets.json \
  --dim_word ${dim_word} \
  --dim ${dim} \
  --n_words_src ${n_words_src} \
  --n_words ${n_words_trg} \
  --n_words_ae ${n_words_ae_trg} \
  --maxlen ${maxlen} \
  --optimizer ${optimizer} \
  --batch_size ${batch_size} \
  --dispFreq ${dispFreq} \
  --saveFreq 10000 \
  --run_alternate 1 \
  --max_epochs ${max_epochs} \
  --use_dropout \
  --enc_depth 2 \
  --dec_depth 2 \
  --patience 10 \
  --validFreq ${valid_freq}
echo "End of training"
