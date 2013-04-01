@gx = common global i32 0
@gy = common global i32 0
@ga = common global [6 x [6 x i32]] zeroinitializer
@gd = common global double 0.000000e+00

define double @foo() {
   %lx = alloca i32
   %ly = alloca i32
   %la = alloca [6 x [6 x i32]]
   %ld = alloca double
   store i32 1, i32* %lx
   store i32 2, i32* %ly
   store i32 3, i32* @gx
   store i32 4, i32* @gy
   %temp1 = getelementptr inbounds [6 x [6 x i32]]* @ga, i32 0, i32 4, i32 4
   store i32 5, i32* %temp1
   %temp2 = getelementptr inbounds [6 x [6 x i32]]* %la, i32 0, i32 3
   %temp3 = getelementptr inbounds [6 x i32]* %temp2, i32 0, i32 3
   store i32 6, i32* %temp3
   %temp4 = load i32* %lx
   %temp5 = getelementptr inbounds [6 x [6 x i32]]* %la, i32 0, i32 3
   %temp6 = getelementptr inbounds [6 x i32]* %temp5, i32 0, i32 3
   %temp7 = load i32* %temp6
   %temp8 = getelementptr inbounds [6 x [6 x i32]]* %la, i32 0, i32 0
   call void @add(i32 %temp4, i32 %temp7, [6 x i32]* %temp8)
   %temp9 = load i32* @gx
   %temp10 = getelementptr inbounds [6 x [6 x i32]]* @ga, i32 0, i32 4, i32 4
   %temp11 = load i32* %temp10
   %temp12 = getelementptr inbounds [6 x [6 x i32]]* @ga, i32 0, i32 0
   call void @add(i32 %temp9, i32 %temp11, [6 x i32]* %temp12)
   %temp13 = getelementptr inbounds [6 x [6 x i32]]* @ga, i32 0, i32 0
   %temp14 = load i32* %ly
   %temp15 = call double @mult([6 x i32]* %temp13, i32 %temp14)
   store double %temp15, double* %ld
   %temp16 = load double* %ld
   %temp17 = getelementptr inbounds [6 x [6 x i32]]* %la, i32 0, i32 0
   %temp18 = getelementptr inbounds [6 x i32]* %temp17, i32 0, i32 0
   %temp19 = load i32* %temp18
   %temp20 = mul i32 %temp19, 2
   %temp22 = sitofp i32 %temp20 to double
   %temp21 = fadd double %temp16, %temp22
   %temp23 = getelementptr inbounds [6 x [6 x i32]]* @ga, i32 0, i32 0, i32 0
   %temp24 = load i32* %temp23
   %temp25 = add i32 %temp24, 4
   %temp27 = sitofp i32 %temp25 to double
   %temp26 = fdiv double %temp27, 2.0
   %temp28 = fadd double %temp21, %temp26
   %temp29 = load i32* @gy
   %temp31 = sitofp i32 %temp29 to double
   %temp30 = fsub double %temp28, %temp31
   store double %temp30, double* @gd
   %temp32 = load double* @gd
   ret double %temp32
}

define void @add(i32 %x, i32 %y, [6 x i32]* %a) {
   %a.addr = alloca [6 x i32]*
   store [6 x i32]* %a, [6 x i32]** %a.addr
   %y.addr = alloca i32
   store i32 %y, i32* %y.addr
   %x.addr = alloca i32
   store i32 %x, i32* %x.addr
   %temp1 = load i32* %x.addr
   %temp2 = load i32* %y.addr
   %temp3 = add i32 %temp1, %temp2
   %temp4 = load [6 x i32]** %a.addr
   %temp5 = getelementptr inbounds [6 x i32]* %temp4, i32 0
   %temp6 = getelementptr inbounds [6 x i32]* %temp5, i32 0, i32 0
   store i32 %temp3, i32* %temp6
   ret void
}

define double @mult([6 x i32]* %a, i32 %b) {
   %b.addr = alloca i32
   store i32 %b, i32* %b.addr
   %a.addr = alloca [6 x i32]*
   store [6 x i32]* %a, [6 x i32]** %a.addr
   %re = alloca double
   %temp1 = load i32* %b.addr
   %temp3 = sitofp i32 %temp1 to double
   %temp2 = fadd double 0.7, %temp3
   store double %temp2, double* @gd
   %temp4 = load [6 x i32]** %a.addr
   %temp5 = getelementptr inbounds [6 x i32]* %temp4, i32 4
   %temp6 = getelementptr inbounds [6 x i32]* %temp5, i32 0, i32 4
   %temp7 = load i32* %temp6
   %temp8 = load double* @gd
   %temp10 = sitofp i32 %temp7 to double
   %temp9 = fmul double %temp10, %temp8
   store double %temp9, double* %re
   %temp11 = load double* %re
   ret double %temp11
}
