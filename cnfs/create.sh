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
# The system uses makewff, as part of the well-known WalksSAT package:
#------
# Generates random formulas using the fixed clause length model.
# The -seed argument can be used to initialize the random number
# generator. See WalkSAT and its authors for details. Source code included.
#
#
#
# The system uses grainofsalt with "crypto1"
#------
# This generates a random problem from the crypto1 stream cipher, with
# preset number of outputs. When the number of outputs is low, it always
# generates a satisfiable problem. Increasing the number of outputs
# creates harder and harder problems
#
#
#
# The system uses multipart-match-sol.py
#------
# This is a hand-written tool that does the following. It takes 2 satisfiable
# problems and their solutions, plus a parameter X:
#
# ./multipart-match-sol.py CNF1 CNF2 CNF1-solution CNF2-solution X
#
# It then creates a new CNF as an output that is a combination of the two
# but makes sure that X number of variables are re-used. These re-used
# variables are always matching on the solutions provided. This ensures that
# the output is SATISIFIABLE and that the 2 problems **cannot be cut apart**
#
#
#
# What the system does
#------
# Each run does the following. It generates 2 satisfiable problems. One from
# makewff, which can be **trivially* solved within 2 seconds with an SLS
# solver. And one from grainofsalt which can be **easily** solved with a
# CDCL solver, within 40 seconds. The system then uses multipart-match-sol.py
# to combine these two problems, such that exactly N variables are overlapping
# making sure the problems **cannot** be cut into 2 pieces, but the final
# CNF is satisfiable. N is set to 2.
#
#
# The system tries to mimic real-world problems that are combination of two
# easy problems, easy to solve separately by two separate types of systems.
# However, the very mild combination of them, truly combined but not highly
# overlapping (overlapping over N variables only) is HARD. In fact, it's hard
# for all solvers that don't use a hybrid strategy such as first employed by
# CaDiCaL and then by CryptoMiniSat. Hybrid strategies work, and this system
# demonstrates that quite well.
#
#
#
# Historical background
#------
# Early attempts at hybrid solving, such as ReasonLS by Shaowei Cai and Xindi
# Zhang combined SLS and CDCL solvers in shell-scripted, non-cohesive way.
# However, it ignited a very interesting development, culminating in CaDiCaL
# and CryptoMiniSat both having a hybrid SLS-CDCL strategy in SAT Race 2019.
# This combined hybrid strategy has been proven useful in industrial
# instances. This system effectively tests whether a hybrid strategy is
# employed by the underlying solver.
#
#
#
# Rationale
#------
# I mostly created the system to encourage hybrid solvers such as SLS+CDCL,
# but there are other options out there, e.g. Gauss-Jordan+CDCL (G-J can solve
# any CNF through linearization not just XORs) or Groebner-Basis+CDCL, etc.
# I think it's time to get out of the bubble of pure CDCL.
#
#
#
# Notes
#------
# The system COULD be solved with a non-hybrid system by somehow computing
# a way to cut them into 2 pieces, solve independently and then join back on
# the N variables. However, such computation may be hard, and no solver
# implements it. CryptoMiniSat used to have a setup where non-overlapping
# CNFs can be cut away. Such CNFs have been regularly submitted to
# SAT competitions


set -x

rm makewff
gcc makewff.c -o makewff


base=500
cryptocomplex=31
overlap=2

lastseed=100
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
    finalfile="combined-crypto1-wff-seed-${i}-wffvars-$base-cryptocplx-$cryptocomplex-overlap-$overlap.cnf"
    ./multipart-match-sol.py $fnamecdcl $fnamesls solution-$fnamecdcl solution-$fnamesls $overlap > $finalfile
    echo "created $finalfile"
    lastseed=$((i+1))
done


