/*
 *   assignment and expression 
 *
 */

int x, y, xa[4][5], *ga[2][4][4];
double d;

int foo(int i, int *da[2][3], int da2[5][6][7]);

int foo(int i, int *da[2][3], int da2[5][6][7]) {
	int a, b, c[5], *pr, ar[2][2][3];
	double d;

	
	a = 0;
	a = x;
	a = i;
	a = b;
	a = xa[1][2];
	a = da2[2][3][4];
	a = *ga[1][2][2]; 
	a = c[2];
	d = *da[1][2];    
	a = ar[1][1][2];
	a = *pr;
	b = *pr + 1;
	*pr = x;
	x = a + b + 3 + a / 4 - 8 * b;
	d = a + 8 + 1;
/*	a = x * (i + b); */

	return a;
}
