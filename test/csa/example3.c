/*
 *    correct example for function definition and function call
 *
 */

int i, j;
double f;
int foo();
void bar(int i, double j);
char* buz(char * s, int a[5][5]);

int main() {
	int a, b;
	double d;	

	a = foo();
	bar(a, d);
	bar(10, 15.5);
}

int foo() {
	bar(i, f);
	i = foo();
}

void bar(int i, double j) {
	int d[5][5];
	char str[89];

	foo();
	bar(3, 5);
	buz("dddd", d);
	buz(str, d);
}


char* buz(char * s, int a[5][5]) {
	
}

