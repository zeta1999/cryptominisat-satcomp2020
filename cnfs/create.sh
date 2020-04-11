#!/usr/bin/bash

set -x

rm makewff
gcc makewff.c -o makewff

base=450
cryptocomplex=45

lastseed=0
for number_of_problems in {0..20};
do
    echo "Doing $base"
    num=$(python -c "print('%d' % (4.25*${base}))")
    for i in {${lastseed}..1000}
    do
        fnamesls="f$base-seed${i}.cnf"
        ./makewff -seed $i  -cnf 3 ${base} ${num} > $fnamesls
        (ulimit -t 2
        ccanr -inst $fnamesls > solution-$fnamesls
        )
        x=$(grep "s SATISFIABLE" solution-$fnamesls)
        echo "x is: $x"
        if [[ "$x" == *"SATISFIABLE"* ]]; then
            echo "seed was: $i"
            break;
        fi
        rm -f solution-$fnamesls
    done;
    (cd ~/development/grainofsalt/build/
    rm satfiles/*
    echo "Using seed: ${i}"
    ./grainofsalt --seed ${i} --crypto crypto1 --outputs $cryptocomplex --karnaugh 0 --init no --num 1 > out
    )
    fnamecdcl=$(grep "File output" ~/development/grainofsalt/build/out | awk '{print $3}')
    cp ~/development/grainofsalt/build/satfiles/$fnamecdcl .
    cadical $fnamecdcl > solution-$fnamecdcl
    echo "crypto file was: $fnamecdcl"
    echo "SLS    file was: $fnamesls"
    finalfile="combined-crypto1-wff-seed-$seed-wffvars-$base-cryptocplx-$cryptocomplex.cnf"
    ./multipart-match-sol.py $fnamecdcl $fnamesls solution-$fnamecdcl solution-$fnamesls 5 > $finalfile
    echo "created $finalfile"
    lastseed=$((i+1))
done;


