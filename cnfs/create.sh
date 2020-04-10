./makewff -seed 2121884153  -cnf 3 400 1700 > f400.cnf
./multipart.py f400.cnf mizh-md5-47-3.cnf >out.cnf
./walksat f400.cnf

echo "700"

num=$(python -c 'print("%d" % (4.25*700))')
./makewff -seed 21884153  -cnf 3 700 ${num} > f700.cnf
./multipart.py f700.cnf mizh-md5-47-3.cnf >out.cnf
./walksat f700 -> 0.23s

