#! /bin/bash
../../../pcc.rb < example.c > example.s
#clang -S -emit-llvm example.c
llc -o example-x86.s example.s
gcc -o example.o -m64 example-x86.s -c
gcc main.c  example.o  -o main
#gcc main.c -o main

