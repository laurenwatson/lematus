import sys

lang = 'English'
data_path = sys.argv[1]
output_file = open(data_path+'/dev-baseline2-hypothesis','w')

with open(data_path+'/train-sources') as s:
    with open(data_path+'/train-targets') as t:
        input2lemma = {}
        for line in s:
            line_content = line.split("<lc>")[1].split("<rc>")
            inflection = "".join(line_content[0].strip().split()).lower()
            lemma = "".join(t.readline().strip().split()[1:-1]).lower()
            if inflection not in input2lemma.keys():
                input2lemma[inflection]={}
                lemma_dict = input2lemma[inflection]
                lemma_dict[lemma] = 1
            else:
                lemma_dict = input2lemma[inflection]
                if lemma in lemma_dict.keys():
                    lemma_dict[lemma]+=1
                else:
                    lemma_dict[lemma]=1

with open(data_path+'/dev-sources') as s:
    for line in s:
        line_content = line.split("<lc>")[1].split("<rc>")
        inflection = "".join(line_content[0].strip().split()).lower()
        if inflection not in input2lemma.keys():
            prediction=inflection
        else:
            lemma_dict = input2lemma[inflection]
            most_common_lemma = ''
            freq = 0
            for key in lemma_dict.keys():
                if lemma_dict[key]>freq:
                    most_common_lemma = key
                    freq = lemma_dict[key]
            prediction = most_common_lemma

        output_file.write(prediction+ "\n")
