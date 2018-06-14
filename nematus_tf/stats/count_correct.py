#Directly adapted from code by: Toms Bergmanis toms.bergmanis@gmail.com

import sys
from collections import defaultdict

model_name = '20-char-context-base1'
data_set = 'dev' # either dev or test
langs=['Hungarian', 'Croatian', 'French', 'English', 'Turkish']

for lang in langs:
    model= lang + "-" + model_name

    train_inflections = []
    train_inflections2lemmas = defaultdict(list)
    dev_inflections = []

    with open("models_20/"+lang+"-20-char-context-base1/data/train-targets".format(model), "r") as t:
        with open("models_20/"+lang+"-20-char-context-base1/data/train-sources".format(model), "r") as s:
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

    correct_unseen_tokens = 0.0
    total_unseen_tokens= 1.0

    correct_seen_unambiguous_tokens = 0.0
    total_seen_unambiguous_tokens = 1.0

    copied_tokens = 0.0
    unseen_should_have_been_copied = 0.0
    total_should_have_been_copied = 0.0
    ambiguous_should_have_been_copied = 0.0
    unambiguous_should_have_been_copied = 0.0
    total_incorrect_unseen = 0.0
    blah = 0.0
    with open("models_20/"+lang+"-20-char-context-base1/data/dev-sources".format(model,data_set), "r") as i:
        with open("models_20/"+lang+"-20-char-context-base1/data/dev-targets".format(model,data_set), "r") as o:
            with open("models_20/"+lang+"-20-char-context-base1/data/dev-hypothesis".format(model,data_set), "r") as p:
                for line in i:
                    try:
                        inflection = "".join(line.split("<lc>")[1].split("<rc>")[0].strip().split()).lower()
                    except:
                        inflection = "".join(line.split("<w>")[1].split("</w>")[0].strip().split()).lower()

                    lemma = "".join(o.readline().strip().split()[1:-1]).lower()
                    prediction = "".join(p.readline().strip().split()[1:-1]).lower()


                    if lemma == prediction:
                        correct_tokens += 1
                    if lemma != prediction and inflection==lemma:
                        total_should_have_been_copied += 1
                    if lemma==inflection:
                        copied_tokens+=1
                    total_number_of_tokens +=1

                    #ambiguous tokens
                    if len(set(train_inflections2lemmas[inflection])) > 1:
                        if prediction == lemma:
                            correct_ambigous_tokens+= 1
                        if prediction != lemma and inflection == lemma:
                            ambiguous_should_have_been_copied += 1
                        total_ambiguous_tokens += 1

                    #unseen tokens
                    elif not inflection in train_inflections:
                        if prediction == lemma:
                            correct_unseen_tokens += 1.0
                        if prediction != lemma:
                            if inflection != lemma:
                                if prediction == inflection:
                                    blah += 1
                        if prediction != lemma and inflection == lemma:
                            unseen_should_have_been_copied += 1
                            #if lang=='English':
                                #print(inflection, lemma, prediction)
                        total_unseen_tokens+= 1
                        if prediction != lemma:
                            total_incorrect_unseen +=1
                    #seen unambiguous tokens
                    else:
                        if prediction == lemma:
                            correct_seen_unambiguous_tokens += 1.0
                        if prediction != lemma and inflection == lemma:
                            unambiguous_should_have_been_copied += 1
                        total_seen_unambiguous_tokens += 1

    results = []
    results.append(("{:.2f}%".format(100*float(correct_ambigous_tokens) / total_ambiguous_tokens)))
    results.append(("{:.2f}%".format(100*float(correct_unseen_tokens) / total_unseen_tokens )))
    results.append(( "{:.2f}%".format(100*float(correct_seen_unambiguous_tokens) / total_seen_unambiguous_tokens)))
    results.append(( "{:.2f}%".format(100*float(correct_tokens) / total_number_of_tokens)))
    results.append(( "{:.2f}%".format(100*float(copied_tokens) / total_number_of_tokens)))
    results.append(( "{:.2f}%".format(100*float(unseen_should_have_been_copied) / total_unseen_tokens)))
    results.append(( "{:.2f}%".format(100*float(total_should_have_been_copied) / total_number_of_tokens)))
    results.append(("{:.2f}%".format(100*float(ambiguous_should_have_been_copied) / total_ambiguous_tokens)))
    results.append(( "{:.2f}%".format(100*float(unambiguous_should_have_been_copied) / total_seen_unambiguous_tokens)))
    results.append(( "{:.2f}%".format(100*float(unseen_should_have_been_copied) / total_incorrect_unseen)))
    results.append(( "{:.2f}%".format(100*float(blah) / total_incorrect_unseen)))



    print(model, data_set, " ".join(results))
print('correct amb', 'correct unseen', 'correct unam', 'total correct', 'total copied', 'unseen SHBC',
    'total SHBC', 'amb SHBC', 'unamb SHBC', 'unseen SHBC', 'unseen should not HBC')
