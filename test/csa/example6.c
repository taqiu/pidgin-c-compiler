/*
 *    correct example for pointer and array
 *
 */

int main() {
	int i, *j;
	int a[3], b[5][5], *c[5];
	
	*j = 34;
	a[3] = 80;
	j = &i;
	i = *j;
	*j = i;

	j = a;
	j = b[3];
	j = c[3];
}
