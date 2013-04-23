void foo();
	void foo(){
	int i,j;
	int k;
	double A[100][100];
	double B[100][100];
	double C[100][100];
	for(i=0;i<100;i=i+1){
	  for(j=0;j<100;j=j+1){
	    A[i][j]=B[i+1][j-1] + C[1][k];
	    
	  }

	}

	for(i=0;i<100;i=i+1){
	  for(j=0;j<100;j=j+1){
	    A[i+1][j]=A[i][j];
	  }
	}

	for(i=0;i<100;i=i+1){
	  for(j=0;j<100;j=j+1){
	    A[i+1][j]=B[i][j];
	    B[i+1][j+2]=A[i+2][j];
	  }
	}
}
