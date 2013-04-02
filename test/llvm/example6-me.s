define i32 @foo() {
   %i = alloca i32
   %d = alloca double
   %temp0 = load i32* %i
   %temp1 = sitofp i32 %temp0 to double
   store double %temp1, double* %d
   %temp2 = load i32* %i
   %temp3 = sitofp i32 %temp2 to double
   %temp4 = call i32 @bar(double %temp3)
   %temp5 = sitofp i32 %temp4 to double
   store double %temp5, double* %d
   %temp6 = load i32* %i
   ret i32 %temp6
}

define i32 @bar(double %x) {
   %x.addr = alloca double
   store double %x, double* %x.addr
   ret i32 0
}
