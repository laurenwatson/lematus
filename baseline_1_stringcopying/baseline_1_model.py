import sys

lang = 'English'
data_path = sys.argv[1]
output_file = open(data_path+'/dev-baseline1-hypothesis','w')

with open(data_path+'/dev-sources') as s:
    with open(data_path+'/dev-targets') as t:
        for line in s:
            line_content = line.split("<lc>")[1].split("<rc>")
            inflection = "".join(line_content[0].strip().split()).lower()
            lemma = "".join(t.readline().strip().split()[1:-1]).lower()
            prediction = inflection
            output_file.write(inflection+ "\n")
