#!/bin/bash
set -e
set -x

rm -f cmsat_*.tar.gz
declare -a arr=(
"main_ccnr"
"main_ccnr_lsids"
"main_walksat"
"nolimits_ccnr"
"nolimits_ccnr_lsids"
"nolimits_walksat"
"parallel_ccnr"
)

for i in "${arr[@]}"
do
(
rm -f "cmsat_${i}.tar.gz"
cd cryptominisat
./pack.sh "${i}"
)
done

