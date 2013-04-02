/*
 *  functions call and assignment casting 
 *
 */

int foo();
int bar(double x);

int foo() {
	int i;
	double d;
	
	d = i;
	d = bar(i);
	return i;
}

int bar(double x) {

	return 0;
}


