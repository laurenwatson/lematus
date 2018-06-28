import sys

lang = sys.argv[1]
size = sys.argv[2]
data_dir = lang+'_'+size+'/'
inputs, lemmas, predictions = [],[],[]

with open(data_dir+'dev-sources') as s:
    for line in s:
        line_content = line.split("<lc>")[1].split("<rc>")
        input = "".join(line_content[0].strip().split()).lower()
        inputs.append(input)

with open(data_dir+'dev-targets') as t:
    for line in t:
        lemma = "".join(line.strip().split()[1:-1]).lower()
        lemmas.append(lemma)

with open(data_dir+'dev-baseline1-hypothesis') as h:
    for line in h:
        prediction = line.rstrip('\n')
        predictions.append(prediction)

correct = 0.0

for index, lem in enumerate(lemmas):
    if lem == predictions[index]:
        correct+=1

print(lang, correct/len(predictions))
