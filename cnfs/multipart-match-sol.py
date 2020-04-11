#!/usr/bin/env python
from __future__ import with_statement
import sys
import string

if len(sys.argv) != 5:
    print("You must use it as: CNF1 CNF2 CNF1-solution CNF2-solution MAX_NUM_MATCHED_VARS")
    exit(-1)

print("c %s" % sys.argv)


# create header
numvars = []
headerNumCls = 0
for fname in sys.argv[1:3]:
    print("c using CNF input file: ", fname)
    thisnumvars = 0
    with open(fname, "r") as ins:
        for line in ins:
            if len(line) == 0:
                print("Empty line in CNF!")
                continue

            if line[0] == 'p' or line[0] == 'c':
                continue

            for part in line.split():
                if part.strip() == 'x':
                    continue
                thisnumvars = max(thisnumvars, abs(int(part)))

            headerNumCls += 1
        numvars.append(thisnumvars)

solutions = []
for fname in sys.argv[3:5]:
    print("c using CNF solution file: ", fname)
    sol = {}
    with open(fname, "r") as ins:
        for line in ins:
            line=line.strip()
            if len(line) == 0:
                continue
            if line[0] != "v":
                continue
            line = line[1:]
            line = line.split()
            line = [l.strip() for l in line]
            for l in line:
                l = int(l)
                if l == 0:
                    continue
                sol[abs(l)] = l

    #print ("Sol for %s: %s" % (fname, sol))
    solutions.append(sol)

commonvars = min(numvars)
commonsols = {}
total_common_sols = 0
for v in range(1, commonvars):
    if solutions[0][v] == solutions[1][v]:
        #print("common solution on var: ", v)
        commonsols[v] = True
        total_common_sols += 1

print("c Total common solutions:", total_common_sols)
total_common_sols = min(total_common_sols, int(sys.argv[5]))
print("c limiting common sols to ", total_common_sols)

var_map = []
var_map.append({})
var_map.append({})
variable = 1
match = 0
for i in range(2):
    for v in range(1,numvars[i]+1):
        if v in commonsols and v in var_map[0] and match < total_common_sols:
            var_map[i][v] = var_map[0][v]
            match+=1
        else:
            var_map[i][v] = variable
            variable+=1

variable-=1
newvars = sum(numvars)-total_common_sols
assert newvars == variable
#print(var_map[0])
#print(var_map[1])

print("p cnf %d %d" % (newvars, headerNumCls))

# print final CNF
ret = ""
at = 0
numvarsUntilNow = 0
for f in sys.argv[1:3]:
    with open(f, "r") as ins:
        for line in ins:
            # ignore header and comments
            if line[0] == 'p' or line[0] == 'c':
                continue

            line = line.rstrip().lstrip()
            lits = line.split()
            towrite = ""
            for lit in lits:
                lit = lit.strip()
                lit = int(lit)

                # end of line
                if lit == 0:
                    towrite += "0"
                    break

                # map var
                newLit = var_map[at][abs(lit)]

                # invert if needed
                if lit < 0:
                    newLit = -1*newLit

                # write updated literal
                towrite += "%d " % newLit

            # end of this line in file
            print(towrite)
    at+=1
