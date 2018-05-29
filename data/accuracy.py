#!/usr/bin/env python
#Author: Toms Bergmanis toms.bergmanis@gmail.com
import sys

reference = sys.argv[1]

ref = open(reference, "r").read().split("\n")
i = 0
j = 0
for line in sys.stdin:
    line = line.strip()
    if ref[i] == line:
        j += 1
    i+=1
print(float(j)/i)
