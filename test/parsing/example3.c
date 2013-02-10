/* Test case for delaration statements and function definitons */
/*
	pidginc_program	::=     type_decls fn_defs
	
	type_decls	::=     type_decl
 	                |       type_decls type_decl

	type_decl	::=     type_name decl_list 

	type_name	::=	int
 	                |	double
 	                |	char
 	                |	void

	decl_list	::=	decl
 	                |	decl_list , decl
 
	decl	        ::=	var_decl
 	                |	fn_decl
 
	var_decl	::=	ident
                        |	array_ref
 
        array_ref	::=	ident [ array_index_list ]
 
       array_index_list ::=	array_index_list ][ expr
 	                |	expr

	fn_decl	        ::=	ident ( )
 	                |	ident ( formal_params_list )
*/
int i,j;
int foo();
double d, bar();
void baz (int x, double y);
void qux (char a[]);
char c[56];
int array[3][4][5];
void a; /* According to the syntax of PidginC, this statement is valid. I think this might be a bug */

int main() {
	int i, j, k;
	int foo(); 
	double d, bar();
	void a, baz(int x, double y);
	char q, w, E, R, T;
	char c[56];
	int array[3][4][5];
	
	i = 9;
	k = 8;
	j = i + k;
}

char foo() {
	int sd;
	sd = 87;
}
