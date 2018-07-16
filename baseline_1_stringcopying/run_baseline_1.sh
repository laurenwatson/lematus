languages=(English Turkish Croatian Hungarian Hindi French)
size=10k

for language in "${languages[@]}"
do
  mkdir -p ${language}_${size}

  data_path=../data/languages_10/${language}-20-char-context/
  cp ${data_path}/train-sources ${language}_${size}
  cp ${data_path}/train-targets ${language}_${size}
  cp ${data_path}/dev-sources ${language}_${size}
  cp ${data_path}/dev-targets ${language}_${size}
  cp acc.py ${language}_${size}

  python baseline_1_model.py ${language}_${size}

  python ${language}_${size}/acc.py ${language} ${size}
done
