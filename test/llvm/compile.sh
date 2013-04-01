#! /bin/bash

for i in {0..5} 
do
	# echo -- run example$i.c   
	clang -S -emit-llvm example$i.c
	../../pcc.rb < example$i.c > example$i-me.s
done
