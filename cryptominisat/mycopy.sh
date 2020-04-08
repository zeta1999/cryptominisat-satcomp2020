#!/bin/bash

rm -rf cms
mkdir -p cms
mkdir -p cms/src
cp -r ~/development/sat_solvers/cryptominisat/src/* cms/src/
rm -rf cms/src/predict/
cp -r ~/development/sat_solvers/cryptominisat/CMakeLists.txt cms/
cp -r ~/development/sat_solvers/cryptominisat/cryptominisat5Config.cmake.in cms/

