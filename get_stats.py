#Author: Toms Bergmanis toms.bergmanis@gmail.com
#Usage example python3 get_stats.py 20-char-context-v1 test Latvian 
import sys
from collections import defaultdict

model_name = sys.argv[1]
data_set = sys.argv[2] # either dev or test

for lang in sys.argv[3:]:
    model=lang + "-" + model_name

    train_inflections = []
    train_inflections2lemmas = defaultdict(list)
    dev_inflections = []
    
    with open("models/{}/data/train-targets".format(model), "r") as t:
        with open("models/{}/data/train-sources".format(model), "r") as s:
            for line in s:
                line_content = line.split("<lc>")[1].split("<rc>")

                inflection = "".join(line_content[0].strip().split()).lower()
                lemma = "".join(t.readline().strip().split()[1:-1]).lower()
                
                train_inflections.append(inflection)
                train_inflections2lemmas[inflection].append(lemma)
                

    train_inflections = set(train_inflections)
    
    
    correct_tokens = 0.0
    total_number_of_tokens = 0.0
    
    total_ambiguous_tokens = 1.0
    correct_ambigous_tokens = 0.0
        
    correct_unnseen_tokens = 0.0
    total_unseen_tokens= 1.0
    
    correct_seen_unambiguous_tokens = 0.0
    total_seen_unambiguous_tokens = 1.0
    
    with open("models/{}/data/{}-sources".format(model,data_set), "r") as i:
        with open("models/{}/data/{}-targets".format(model,data_set), "r") as o:
            with open("models/{}/best_model/{}-hypothesis".format(model,data_set), "r") as p:
                for line in i:
                    try:
                        inflection = "".join(line.split("<lc>")[1].split("<rc>")[0].strip().split()).lower()
                    except:
                        inflection = "".join(line.split("<w>")[1].split("</w>")[0].strip().split()).lower()

                    lemma = "".join(o.readline().strip().split()[1:-1]).lower()
                    prediction = "".join(p.readline().strip().split()[1:-1]).lower()


                    if lemma == prediction:
                        correct_tokens += 1
                    total_number_of_tokens +=1
                    
                    #ambiguous tokens
                    if len(set(train_inflections2lemmas[inflection])) > 1:  
                        if prediction == lemma:
                            correct_ambigous_tokens+= 1
                        total_ambiguous_tokens += 1
                    #unseen tokens
                    elif not inflection in train_inflections:
                        if prediction == lemma:
                            correct_unnseen_tokens += 1.0
                        total_unseen_tokens+= 1
                    #seen unambiguous tokens 
                    else:
                        if prediction == lemma:
                            correct_seen_unambiguous_tokens += 1.0
                        total_seen_unambiguous_tokens += 1

    results = []
    results.append(("{:.2f}%".format(100*float(correct_ambigous_tokens) / total_ambiguous_tokens)))
    results.append(("{:.2f}%".format(100*float(correct_unnseen_tokens) / total_unseen_tokens )))
    results.append(( "{:.2f}%".format(100*float(correct_seen_unambiguous_tokens) / total_seen_unambiguous_tokens)))
    results.append(( "{:.2f}%".format(100*float(correct_tokens) / total_number_of_tokens)))
    print(model, data_set, " ".join(results))

