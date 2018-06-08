#Author: Lauren Watson github: laurenwatson (based heavily on work by Toms Bergmanis toms.bergmanis@gmail.com)
#Use example python get_stats.py 20-char-context

#get num tokens for each languages
#get num tokens where worform==lemma
#get num unseen tokens for each language

#TO DO: get num ambiguous tokens for each language
#TO DO: plot histograms of word freqs to observe law

import sys

languages = ['English', 'Croatian', 'French', 'Hindi', 'Hungarian', 'Turkish']
model_name = sys.argv[1]

for lang in languages:



    for data_set in ['train', 'dev', 'test']:


        model=lang + "-" + model_name

        num_lines = 0
        num_copied = 0.0
        target_filepath = "data/languages/" + model +"/"+data_set+"-targets"
        source_filepath = "data/languages/" + model +"/"+data_set+"-sources"

        with open(target_filepath, "r") as t:
            with open(source_filepath, "r") as s:
                while num_lines<8000:
                    for line in s:
                        num_lines += 1
                        line_content = line.split("<lc>")[1].split("<rc>")
                        wordform = "".join(line_content[0].strip().split()).lower()
                        lemma = "".join(t.readline().strip().split()[1:-1]).lower()

                        if wordform == lemma:
                            num_copied+=1



        print( lang + ' has number of ' + data_set + ' lines: ', num_lines)
        print( lang + ' has percentage of ' + data_set + ' tokens copied: ', num_copied/num_lines)


    train_target_filepath = "data/languages/" + model +"/train-targets"
    train_source_filepath = "data/languages/" + model +"/train-sources"
    dev_target_filepath = "data/languages/" + model +"/dev-targets"
    dev_source_filepath = "data/languages/" + model +"/dev-sources"

    seen_tokens={}
    unseen_count = 0.0
    dev_count = 0

    with open(train_source_filepath, "r") as train_target:
        for line in train_target:
            line_content = line.split("<lc>")[1].split("<rc>")
            wordform = "".join(line_content[0].strip().split()).lower()

            if wordform in seen_tokens.keys():
                seen_tokens[wordform]+=1
            else:
                seen_tokens[wordform]=1

    with open(dev_source_filepath, 'r') as dev_target:
        for line in dev_target:
            dev_count +=1
            line_content = line.split("<lc>")[1].split("<rc>")
            wordform = "".join(line_content[0].strip().split()).lower()

            if wordform not in seen_tokens.keys():
                unseen_count +=1
                
    print( lang + ' has percent unseen in dev_set: ', unseen_count/dev_count)
