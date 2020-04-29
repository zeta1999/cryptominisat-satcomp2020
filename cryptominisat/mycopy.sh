#!/bin/bash

rm -rf cms
mkdir -p cms
mkdir -p cms/src
cp -r ~/development/sat_solvers/cryptominisat/src/* cms/src/
cp -r ~/development/sat_solvers/cryptominisat/cmake cms/
rm -rf cms/src/predict/
cp -r ~/development/sat_solvers/cryptominisat/CMakeLists.txt cms/
cp -r ~/development/sat_solvers/cryptominisat/cryptominisat5Config.cmake.in cms/

rm -rf breakid
mkdir breakid
mkdir breakid/src
cp -r ~/development/sat_solvers/breakid/src/* breakid/src/
cp ~/development/sat_solvers/breakid/CMakeLists.txt breakid/
cp ~/development/sat_solvers/breakid/breakidConfig.cmake.in breakid/
cp -r ~/development/sat_solvers/breakid/cmake breakid/

rm -rf bliss
