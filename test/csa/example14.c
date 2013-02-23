/*
 *   error example for array and pointer
 *
 */
int main() {
	int a[3][3][3], b[4][4][4][4], *p;
	double d[5][5];
	int i, j;

	p = &p;
	p = &a[2];

	p = a[3];
	a[3][3] = b[4];
	*p = d[5];	
	i = p;
}

