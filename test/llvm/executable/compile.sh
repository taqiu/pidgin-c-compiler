#! /bin/bash
../../../pcc.rb < example.c > example.s
../../../pcc.rb < example0.c > example0.s
#clang -S -emit-llvm example.c
llc -o example-x86.s example.s
llc -o example0-x86.s example0.s
gcc -o example.o -m64 example-x86.s -c
gcc -o example0.o -m64 example0-x86.s -c
gcc main.c  example.o example0.o -o main
#gcc main.c -o main

