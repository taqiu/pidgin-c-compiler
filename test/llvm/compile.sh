#! /bin/bash

for i in {0..6} 
do
	# echo -- run example$i.c   
	clang -S -emit-llvm example$i.c
	../../pcc.rb < example$i.c > example$i-me.s
	llc -o example$i-x86.s example$i-me.s
done
