/*
 *  Error example for misusing of function
 *
 */

int foo();
int*  bar(double a);

void main() {
	int i;
	double a;

	foo = 8;     /* regard function as variable */
	i = foo[9][8];
	a(8);

	i = bar(a); /* wrong return type*/
}

double foo() {  /* return type conflict */


} 

int* bar() {  /* parameters conflict */

}


