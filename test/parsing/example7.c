/* test cast for compound statements */
/* 
 * compound_stmt  ::=	for ( simple_stmt ; expr ; simple_stmt ) block
 *                |	while ( expr ) block
 *  	          |	if ( expr ) block optional_else
 *  	 	 
 * optional_else  ::=	ε
 *  	          |	else block
 *
 *
 */

int main() {
	for (i = 0; i < 9; i = i +1) {
		j = i;
	}

	while (j[3][2] > 45) {
		k = 9.0;
	}

	if (y == 98) {
		print(a, d, f);
	}
	
	if (x < f) {
		dd = 3;
	} else {
		foo(d);
	}

}
