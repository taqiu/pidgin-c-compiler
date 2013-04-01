#include <stdio.h>
#include <stdlib.h>
/*
int gx, gy, ga[6][6];   
double gd;
*/

double foo();
void add(int x, int y, int a[6][6]); 
double mult(int a[6][6], int b);


int main() {
	double out;

	out = foo();    /* invoke from llvm assemblly*/
	printf("out(29.5): %lf\n", out);
}

/*
double foo() {
	int lx, ly, la[6][6];    // local variables 
	double ld;

	lx = 1;
	ly = 2;
	gx = 3;
	gy = 4;
	ga[4][4] = 5;
	la[3][3] = 6;
	
	add(lx, la[3][3], la);
	add(gx, ga[4][4], ga);
	ld = mult(ga, ly);
	
	gd = ld + la[0][0] * 2 + (ga[0][0] + 4) / 2.0 - gy;

	return gd;
}

void add(int x, int y, int a[6][6]) {
	a[0][0] = x + y;
}

double mult(int a[6][6], int b) {
	double re;

	gd = 0.7 + b;
	re = a[4][4] * gd;

	return re;
}
*/
