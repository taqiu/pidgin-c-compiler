/*
 *   assignment left side and unary operation
 *
 */

int gx, *gp;
int ga[4][5];

int foo(int px, int *pp, int pa[3][3]);

int foo(int px, int *pp, int pa[3][3]) {
	int lx, *lp;
	int la[5][5];
	
	lx = -lx;
	lx = - px;
	lx = -gx;
	

	lp = &lx;
	lp = &gx;
	lp = &px;
	gx = lx;
	px = lx;
	*lp = lx;
	*lp = lx;
	*pp = lx;
	lp = &lx;
	gp = &lx;
	pp = &lx;
	ga[1][2] = lx;
	pa[1][2] = lx;
	la[1][2] = lx;

	return 0;
}
