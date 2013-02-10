/* test case for pointers */

void foo(int *x, double *y[], int z);
int * bar(); 
double baz(int r, double x[d][d+9][]);

void main() {
	int x, *p;
	int * a[9], y;
	void f;
	double d, *dp;

	p = &x;
	*p = x;
	a[0] = &y;
	* a[0] = y;

	foo(&x, dp, x);
	foo(p, &d, *p);
	p = bar();
	return;
}

void foo(int *x, double *y[], int z) {
	*x = *x + 3;
}

int * bar() {
	int * a;
	*a = 5;
	return a;
}

double baz(int r) {
	r = 1 + 3 + (8 *0);
	-n;
	!m;
	+l;
	return r;
}
