/*
 * Wrong example - declaration
 *
 */

/* void example*/
void a;
void fun(void b, int r);
void x[2][2];

/* re-declaration */
int i, fun;
double i; 
int fun();

/* incorrect subscript */
int array[9.1];
double s;
int d;
char str[s+d];

/* undeclaration */
void main() {
	foo;
}
