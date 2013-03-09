#include <stdio.h>
#include <stdlib.h>
#define N 100
#define random() (-500 + 1000*((float)rand())/RAND_MAX)

int initialize(double *matrix, int n);
double dotproduct_c(double *A, double *B, int n);
void matmul_c(double *A, double *B, double *C, int n);

int main() {
	int i, length = N*N;
	int is_correct = 1;
	double a[N*N];
	double b[N*N];
	double c[N*N];
	double cc[N*N];
	struct timeval t_start, t_end;
	double assembly_time;
	double c_time;
	
	initialize(a, N);
	initialize(b, N);

	// get the start time
	gettimeofday(&t_start, NULL);
	matmul(a, b, c, N);    // invoke assembly matmul function
	// get the end time 
	gettimeofday(&t_end, NULL);
	assembly_time = t_end.tv_sec - t_start.tv_sec + (t_end.tv_usec - t_start.tv_usec)/1000000.0;

	// get the start time
	gettimeofday(&t_start, NULL);
	matmul_c(a, b, cc, N);	 // invoke c matmul function
	// get the end time 
	gettimeofday(&t_end, NULL);
	c_time = t_end.tv_sec - t_start.tv_sec + (t_end.tv_usec - t_start.tv_usec)/1000000.0;

	// compare the results
	is_correct = 1;
	for (i = 0; i < length; i++) 
		if (c[i] != cc[i]) {
			is_correct = 0;
			break;
		}

	printf("assembly time: %lfs, c time: %lfs\n", assembly_time, c_time);
	if (is_correct) 
		printf("test case pass!\n");	
	else 
		printf("test case failed!\n");

	return 0;
}

int initialize(double *matrix, int n) {
	int i;
	int length = n*n;
	for (i = 0; i < length; i++) {
		matrix[i] = random();
	}
}

double dotproduct_c(double *A, double *B, int n) {
  int i;
  double s;
  s = 0.0;
  for (i=0; i < n; i++)
    s = s + A[i]*B[i*n];
  return s;
}

void matmul_c(double *A, double *B, double *C, int n) {
  int i, j;
  for (i=0; i < n; i++)
    for (j=0; j < n; j++)
      /* C[i][j] == C[i*n+j] == dot product of row i of A and column j of B*/
        C[i*n+j] = dotproduct_c(&A[i*n], &B[j], n);
}
