#include <stdio.h>
#include <stdlib.h>
/*
int gx, gy, ga[6][6];   
double gd;
*/

double foo();
void add(int x, int y, int a[6][6]); 
double mult(int a[6][6], int b);

double bar(double x);
int buz(double x);

int main() {
	double out;

	/* test case 1 */
	out = foo();    /* invoke from llvm assemblly */
	printf("Test case 1 (29.5)- output: %lf\n", out);

	/* test case 2 */
	out = bar(10); /* invoke from llvm assemblly */
	printf("Test case 2 (-2236.103448) - output: %lf\n", out);
}

/*
double bar(double x) {
	int a, b, *p, *pa[8][7];
	double re;

	a = 90;
	p = &a;
	pa[3][4] = p;
	pa[4][3] = &b;
	*pa[4][3] = (*p + 21) * 2 + (+45);

	re = buz(a) + *pa[3][4] + *pa[4][3]  + *p + (buz(78) + x) * (-a) + (-1*3)*a/87.0;

	return re;
}

int buz(double x) {
	double y;
	y = x + y + 100;
	
	return 20;
}
*/

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
