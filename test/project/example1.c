void foo();

void foo(){
  int i;
  int a;
  int b;
  i=100;
  a=10;
  b=20;

  for(i=0;i<100;i=i+1){
    a=2+b;
    b=a;
    
  }

  for(i=0;i<100;i=i+1){
    a=a*b;
  }
}
