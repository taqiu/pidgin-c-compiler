define i32 @foo() {
   %b = alloca double
   %c = alloca double
   %a = alloca [9 x [7 x i32]]
   %x = alloca [2 x i32]
   call void @bar(i32 9)
   %temp1 = load double* %b
   %temp2 = load double* %c
   %temp3 = fadd double %temp1, %temp2
   %temp4 = getelementptr inbounds [9 x [7 x i32]]* %a, i32 0, i32 0
   %temp5 = getelementptr inbounds [2 x i32]* %x, i32 0, i32 0
   %temp6 = call double @buz(double %temp3, i32 4, [7 x i32]* %temp4, i32* %temp5)
   store double %temp6, double* %b
   ret i32 0
}

define void @bar(i32 %i) {
   %i.addr = alloca i32
   store i32 %i, i32* %i.addr
   ret void
}

define double @buz(double %x, i32 %y, [7 x i32]* %a, i32* %b) {
   %b.addr = alloca i32*
   store i32* %b, i32** %b.addr
   %a.addr = alloca [7 x i32]*
   store [7 x i32]* %a, [7 x i32]** %a.addr
   %y.addr = alloca i32
   store i32 %y, i32* %y.addr
   %x.addr = alloca double
   store double %x, double* %x.addr
   ret double 0.0
}
