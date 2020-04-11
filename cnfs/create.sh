#!/usr/bin/bash

# Prerequisites
#------
# You need installed:
#  python
#  cadical: https://github.com/arminbiere/cadical
#  ccanr: http://lcs.ios.ac.cn/~caisw/SAT.html
#  grainofsalt: https://github.com/msoos/grainofsalt
#     -- please install to directory ~/development/grainofsalt/
#
# The system uses makewff, as pert of the well-known WalksSAT package:
#------
# Generate random formulas using the fixed clause length model.
# The -seed argument can be used to initialize the random number
# generator.
#
#
# The system uses grainofsalt with "crypto1"
#------
# This generates a random problem from the crypto1 stream cipher, with
# preset number of outputs. When the number of outputs is low, it always
# generates a satisfiable problem. Increasing the number of outputs
# creates harder and harder problems


set -x

rm makewff
gcc makewff.c -o makewff

base=450
cryptocomplex=45

lastseed=0
for number_of_problems in {0..19};
do
    echo "Doing $base"
    num=$(python -c "print('%d' % (4.25*${base}))")
    for i in  $(seq $lastseed 1 1000)
    do
        fnamesls="f$base-seed${i}.cnf"
        ./makewff -seed $i  -cnf 3 ${base} ${num} > $fnamesls
        (ulimit -t 2
        ccanr -inst $fnamesls > solution-$fnamesls || true
        )
        x=$(grep "s SATISFIABLE" solution-$fnamesls)
        echo "x is: $x"
        if [[ "$x" == *"SATISFIABLE"* ]]; then
            echo "seed was: $i"
            break;
        fi
        rm -f solution-$fnamesls
        rm -f $fnamesls
    done;
    (cd ~/development/grainofsalt/build/
    rm -f satfiles/*
    echo "Using seed: ${i}"
    ./grainofsalt --seed ${i} --crypto crypto1 --outputs $cryptocomplex --karnaugh 0 --init no --num 1 > out
    )
    fnamecdcl=$(grep "File output" ~/development/grainofsalt/build/out | awk '{print $3}')
    cp ~/development/grainofsalt/build/satfiles/$fnamecdcl .
    cadical $fnamecdcl > solution-$fnamecdcl || true
    echo "crypto file was: $fnamecdcl"
    echo "SLS    file was: $fnamesls"
    finalfile="combined-crypto1-wff-seed-${i}-wffvars-$base-cryptocplx-$cryptocomplex.cnf"
    ./multipart-match-sol.py $fnamecdcl $fnamesls solution-$fnamecdcl solution-$fnamesls 5 > $finalfile
    echo "created $finalfile"
    lastseed=$((i+1))
done;


