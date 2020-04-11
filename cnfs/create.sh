#!/usr/bin/bash

set -x

base=600
echo "Doing $base"
num=$(python -c "print('%d' % (4.25*${base}))")
./makewff -seed 29988413  -cnf 3 ${base} ${num} > f$base.cnf
walksat f$base.cnf
ccanr -inst f$base.cnf
(cd ~/development/grainofsalt/build/
rm satfiles/*
./grainofsalt --seed 0 --crypto crypto1 --outputs 50 --karnaugh 0 --init no --num 1 > out
file=$(grep "File output" out | awk '{print $3}')
echo "crypto file was: $file"
)
cp ~/development/grainofsalt/build/satfiles/$file .
./multipart.py $file f$base.cnf > out4.cnf

base=650
echo "Doing $base"
num=$(python -c "print('%d' % (4.25*${base}))")
./makewff -seed 21978423  -cnf 3 ${base} ${num} > f$base.cnf
walksat f$base.cnf
ccanr -inst f$base.cnf
(cd ~/development/grainofsalt/build/
rm satfiles/*
./grainofsalt --seed 1 --crypto crypto1 --outputs 50 --karnaugh 0 --init no --num 1 > out
file=$(grep "File output" out | awk '{print $3}')
echo "crypto file was: $file"
)
cp ~/development/grainofsalt/build/satfiles/$file .
./multipart.py $file f$base.cnf > out5.cnf

base=700
echo "Doing $base"
num=$(python -c "print('%d' % (4.25*${base}))")
./makewff -seed 31978313  -cnf 3 ${base} ${num} > f$base.cnf
walksat f$base.cnf
ccanr -inst f$base.cnf
(cd ~/development/grainofsalt/build/
rm satfiles/*
./grainofsalt --seed 2 --crypto crypto1 --outputs 50 --karnaugh 0 --init no --num 1 > out
file=$(grep "File output" out | awk '{print $3}')
echo "crypto file was: $file"
)
cp ~/development/grainofsalt/build/satfiles/$file .
./multipart.py $file f$base.cnf > out6.cnf
