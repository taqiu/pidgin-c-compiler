/*
 *  correct example for expression type inference
 *
 */

int main() {
	int a, b[2], c[3][3], *d, e, f;
	double i, j[3], *k;
	
	a = b[1] + c[2][2] + *d * e;
	f = (*d * e) - (c[2][1] + a) * e;

	i = b[2] + (*d + e) / f;
	j[2] = b[2] >  e - (*k * i) / j[1];

	!a;
	a;
	b[0];
	c[0];
	*d;
	
	a < b[1];
	c[1][2] >= b[1];
	*d <= e;
	j[3] > a;
	e < *k;
}
