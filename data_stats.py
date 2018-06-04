#Author: Lauren Watson (from work by Toms Bergmanis toms.bergmanis@gmail.com)
#Usage example python3 get_stats.py 20-char-context-v1 test Latvian

#get num tokens for each languages
#get num unseen tokens for each language
#get num ambiguous tokens for each language

import sys

languages = ['English', 'Croatian', 'French', 'Hindi', 'Hungarian', 'Turkish']
model_name = sys.argv[1]

for data_set in ['train', 'dev', 'test']:

    for lang in languages:

        model=lang + "-" + model_name

        num_lines = 0

        target_filepath = "data/languages/" + model +"/train-targets"
        source_filepath = "data/languages/" + model +"/train-sources"

        with open(target_filepath, "r") as t:
            with open(source_filepath, "r") as s:
                for line in s:
                    num_lines += 1
                    line_content = line.split("<lc>")[1].split("<rc>")
                    wordform = "".join(line_content[0].strip().split()).lower()
                    lemma = "".join(t.readline().strip().split()[1:-1]).lower()



        print( lang + ' has number of ' + data_set + ' lines: ', num_lines)
