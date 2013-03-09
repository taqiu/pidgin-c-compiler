double dotproduct (double *A, double *B, int n) {
  int i;
  double s;
  s = 0.0;
  for (i=0; i < n; i++)
    s = s + A[i]*B[i*n];
  return s;
}

void matmul (double *A, double *B, double *C, int n) {
  int i, j;

  printf("matmul\n"); 

  for (i=0; i < n; i++)
    for (j=0; j < n; j++)
      /* C[i][j] == C[i*n+j] == dot product of row i of A and column j of B*/
        C[i*n+j] = dotproduct(&A[i*n], &B[j], n);
} 
