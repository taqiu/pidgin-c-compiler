#! /bin/bash
# run all examples
cd ../..
for i in {0..15} 
do
	echo -- run example$i.c   
	ruby  pcc.rb < test/csa/example$i.c | grep '.rb:'
	ruby  pcc.rb  < test/csa/example$i.c # | grep error 
done
