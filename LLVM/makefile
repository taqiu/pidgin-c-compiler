all: test_matmul

test_matmul: matmul.o test_matmul.o
	gcc matmul.o test_matmul.o -o test_matmul
test_matmul.o: test_matmul.c 
	gcc -c test_matmul.c -o test_matmul.o
matmul.o: matmul-x86.s
	gcc -o matmul.o -m64 matmul-x86.s -c
matmul-x86.s: matmul.s
	llc -o matmul-x86.s matmul.s
clean:
	rm -rf *.o test_matmul matmul-x86.s


