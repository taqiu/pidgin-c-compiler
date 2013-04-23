int i;
int j;
int A[10][10];
int B[10][10];
int E[10][10];
int C,D,F;
int G[10];

void foo();
void bar();
void baz();

void foo(){

  for(i=0;i<10;i=i+1) {
    for(j=0;j<10;j=j+1){
      A[i][j]=B[i+1][j]+C;
      B[i-1][j+1]=A[i][j]+D;
      B[i+1][j-1]=E[i-1][j+1]*F;
    }
  }

}


void bar(){
  for(i=0;i<10;i=i+1){
    G[i]=C*D;
    for(j=0;j<10;j=j+1){
      A[i][i+1]=B[i+1][j];
      E[i][j]=A[j+2][i+1];
    }
  }
}

void baz(){
  for(i=0;i<10;i=i+1){
    for(j=0;j<10;j=j+1){
      A[j][i+1]=B[i+1][j];
      E[i][j]=A[j+2][i+1];
      
    }
  }


}



