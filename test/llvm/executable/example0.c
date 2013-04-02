/*
 *  function and assignment casting 
 *  pointer and pointer array
 *  unary operation
 *  
 */

double bar(double x);
int buz(double x);

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
