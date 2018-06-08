#!/bin/sh

# device, in case you do not want to compute on gpu, change it to cpu
device=gpu0

basedir=../..

currentdir=$(dirname $0)

#theano compilation directory
base_compiledir=${basedir}/tf
mkdir -p ${base_compiledir}

mkdir -p ${currentdir}/best_model

# decode
#flags:
# -m models to use
# -i input file
# -o output file
# -k beam size (default 5)
# -n normalize scores by sentence Length
# -p number of processes (default 5)
echo ${currentdir}
#THEANO_FLAGS=mode=FAST_RUN,floatX=float32,device=$device,on_unused_input=warn,base_compiledir=${base_compiledir} python ./nematus_tf/translate.py \
CUDA_VISIBLE_DEVICES=0 python ./nematus_tf/translate.py \
     -m ${currentdir}/model.npz.dev.npz \
     -i ${currentdir}/data/dev-sources \
     -o ${currentdir}/dev-hypothesis \
     -k 12 -n -p 1

#model selection based on dev set accuracy
BEST=`cat ${currentdir}/best_model/best_accuracy || echo 0`
python3 ./data/accuracy.py ${currentdir}/data/dev-targets < ${currentdir}/dev-hypothesis >> ${currentdir}/accuracy
ACCURACY=`python3 ./data/accuracy.py ${currentdir}/data/dev-targets < ${currentdir}/dev-hypothesis`
BETTER=`echo "$ACCURACY > $BEST" | bc`

echo "ACCURACY = $ACCURACY"

if [ "$BETTER" = "1" ]; then
  echo "New best model; saving."
  echo $ACCURACY > ${currentdir}/best_model/best_accuracy
  cp ${currentdir}/model.npz.dev.npz ${currentdir}/best_model/model.npz
  cp ${currentdir}/model.npz.json ${currentdir}/best_model/.
  cp ${currentdir}/dev-hypothesis ${currentdir}/best_model/dev-hypothesis
fi
