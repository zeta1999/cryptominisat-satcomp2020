#!/bin/bash

set -e
set -x

rm -f cmsat_*.tar.gz
rm -rf m4ri-20200125
rm -rf cmake-3.11.1
rm -rf cms/build
rm -f bin/crypto*

(
cd bin
cp "${1}" starexec_run_default
)

tar czvf "cmsat_${1}.tar.gz" ./*
mv "cmsat_${1}.tar.gz" ../

rm -f bin/starexec_run_default
rm -f starexec_build
