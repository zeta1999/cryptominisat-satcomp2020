#!/bin/bash
set -e
set -x

rm -f *.zip
rm -f cms55*.tar.gz
declare -a arr=(
"main_ccnr"
"main_walksat"
"nolimits_ccnr"
"nolimits_walksat"
"parallel"
)

for i in "${arr[@]}"
do
(
rm -f "cmsat_${i}.tar.gz"
cd cryptominisat
./pack.sh "${i}"
mv "cmsat_${i}.tar.gz" ../
)
done

