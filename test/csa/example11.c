/*
 *  Error example for undeclaration
 *
 */
int a, b;


int main() {
	double i;

	for (a = 8; a < 20; a = a + 1) {
		break;
	}	

	if (a) {
		if (a) {      
			int j;
			if (a) {
				aa;   /*undeclaration*/
			}
		} else {
			j;	/* undeclaration */
		}
	} 
	
	for (j = 10; j < 23; i ) {   /* undeclaration */
		while (x) {         /* undeclaration of 'x'  */
			char x;
		}
	} 
} 

void foo() {    /* undeclatation */

}
