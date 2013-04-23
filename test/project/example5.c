int main() {
	int A[10][10];
	int B[10][10];
	int C[10];
	int D[10][10];
	int i, j, k, a, b;


	/* output dependence */
	for (i = 0; i < 10; i = i+ 1) {
		a = a + b;
	}

	for (i = 0; i < 10; i = i+ 1) {
		C[i] = b;
		C[i] =  b;
	}

	for (i = 0; i < 10; i = i+ 1) {
		a = b;
	}


	for (i = 0; i < 10; i = i+ 1) {
		C[i] = C[i] + 10;
	}

	

	for (i = 0; i < 10; i = i+ 1) {
		j = j + 10;
	}

	for (i = 0; i < 10; i = i+ 1) {
		C[i+1] = C[i] + 10;
	}

	for (i = 0; i < 10; i = i+ 1) {
		C[2] = C[4] + 10;
	}

	for (i = 0; i < 10; i = i+ 1) {
		for (j = 0; j < 10; j = j + 1) {
			A[i][j+1] = A[i][j] + 10;
		}
	}

	for (i = 0; i < 10; i = i+ 1) {
		for (j = 0; j < 10; j = j + 1) {
			A[i+1][j+1] = A[i][j] + 10;
		}
	}

	for (i = 0; i < 10; i = i + 1) {
		C[i] = C[i] + 10;
		for (j = 0; j < 10; j = j + 1) {
			A[i+1][j] = i;
			B[i][j] = A[i][j];
			for (k = 0; k < 10; k = k + 1) {
				D[j+1][k] = D[j][k-1] + 1;
			}
			C[i] = B[i][j] * 7;
		}
	}
}
