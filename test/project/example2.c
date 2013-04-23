
void foo();

void foo(){
int i;
double A[100];
double B[100];
for(i=0;i<100;i=i+1){
  A[i]=B[i+1];

}

for(i=0;i<100;i=i+1){
  A[i+1]=A[i];

}


}

int main() {
	foo();
}
