import sys

lang = sys.argv[1]
size = sys.argv[2]
data_dir = lang+'_'+size+'/'
inputs, lemmas, predictions, train_lemmas, train_inputs = [],[],[], [], []

with open(data_dir+'train-sources') as train_s:
        for line in train_s:
            line_content = line.split("<lc>")[1].split("<rc>")
            input = "".join(line_content[0].strip().split()).lower()
            train_inputs.append(input)

with open(data_dir+'train-targets') as train_t:
    for line in train_t:
        lemma = "".join(line.strip().split()[1:-1]).lower()
        train_lemmas.append(lemma)

with open(data_dir+'dev-sources') as s:
    for line in s:
        line_content = line.split("<lc>")[1].split("<rc>")
        input = "".join(line_content[0].strip().split()).lower()
        inputs.append(input)

with open(data_dir+'dev-targets') as t:
    for line in t:
        lemma = "".join(line.strip().split()[1:-1]).lower()
        lemmas.append(lemma)

with open(data_dir+'dev-baseline2-hypothesis') as h:
    for line in h:
        prediction = line.rstrip('\n')
        predictions.append(prediction)

correct = 0.0
copied = 0.0
seen = 0.0
unseen = 0.0
seen_copied = 0.0
unseen_copied = 0.0
seen_correct = 0.0
unseen_correct = 0.0
seen_shbc = 0.0
unseen_shbc = 0.0
unseen_incorrect = 0.0
seen_incorrect =0.0

for index, lem in enumerate(lemmas):

    # if correct
    if lem == predictions[index]:
        correct+=1

        # if input copied as prediction
    if predictions[index]==inputs[index]:
        copied+=1

        # if seen
    if inputs[index] in train_inputs:
        seen += 1
        if lem == predictions[index]:
            seen_correct+=1
            #if copied
        if predictions[index] == inputs[index]:
            seen_copied+=1
            #if incorrect
        if lem !=predictions[index]:
            seen_incorrect+=1
                #if wasn't copied but should have been
            if lem==inputs[index] and inputs[index] != predictions[index]:
                seen_shbc+=1

        # if unseen
    if inputs[index] not in train_inputs:
        unseen += 1
        if lem == predictions[index]:
            unseen_correct+=1
            #if copied
        if predictions[index] == inputs[index]:
            unseen_copied+=1
            #if incorrect
        if lem != predictions[index]:
            unseen_incorrect+=1
                #if wasn't copied but should have been
            if lem==inputs[index] and inputs[index] != predictions[index]:
                unseen_shbc+=1

    train_copied = 0.0
    for lemma, input in zip(train_lemmas, train_inputs):
        if lemma == input:
            train_copied+=1

print(lang, 'overall acc ', correct/len(predictions), ' seen acc ', seen_correct/seen, ' unseen acc ', unseen_correct/unseen)
