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
   %temp0 = getelementptr inbounds [6 x [6 x i32]]* @ga, i32 0, i32 4, i32 4
   store i32 5, i32* %temp0
   %temp1 = getelementptr inbounds [6 x [6 x i32]]* %la, i32 0, i32 3
   %temp2 = getelementptr inbounds [6 x i32]* %temp1, i32 0, i32 3
   store i32 6, i32* %temp2
   %temp3 = load i32* %lx
   %temp4 = getelementptr inbounds [6 x [6 x i32]]* %la, i32 0, i32 3
   %temp5 = getelementptr inbounds [6 x i32]* %temp4, i32 0, i32 3
   %temp6 = load i32* %temp5
   %temp7 = getelementptr inbounds [6 x [6 x i32]]* %la, i32 0, i32 0
   call void @add(i32 %temp3, i32 %temp6, [6 x i32]* %temp7)
   %temp8 = load i32* @gx
   %temp9 = getelementptr inbounds [6 x [6 x i32]]* @ga, i32 0, i32 4, i32 4
   %temp10 = load i32* %temp9
   %temp11 = getelementptr inbounds [6 x [6 x i32]]* @ga, i32 0, i32 0
   call void @add(i32 %temp8, i32 %temp10, [6 x i32]* %temp11)
   %temp12 = getelementptr inbounds [6 x [6 x i32]]* @ga, i32 0, i32 0
   %temp13 = load i32* %ly
   %temp14 = call double @mult([6 x i32]* %temp12, i32 %temp13)
   store double %temp14, double* %ld
   %temp15 = load double* %ld
   %temp16 = getelementptr inbounds [6 x [6 x i32]]* %la, i32 0, i32 0
   %temp17 = getelementptr inbounds [6 x i32]* %temp16, i32 0, i32 0
   %temp18 = load i32* %temp17
   %temp19 = mul i32 %temp18, 2
   %temp21 = sitofp i32 %temp19 to double
   %temp20 = fadd double %temp15, %temp21
   %temp22 = getelementptr inbounds [6 x [6 x i32]]* @ga, i32 0, i32 0, i32 0
   %temp23 = load i32* %temp22
   %temp24 = add i32 %temp23, 4
   %temp26 = sitofp i32 %temp24 to double
   %temp25 = fdiv double %temp26, 2.0
   %temp27 = fadd double %temp20, %temp25
   %temp28 = load i32* @gy
   %temp30 = sitofp i32 %temp28 to double
   %temp29 = fsub double %temp27, %temp30
   store double %temp29, double* @gd
   %temp31 = load double* @gd
   ret double %temp31
}

define void @add(i32 %x, i32 %y, [6 x i32]* %a) {
   %a.addr = alloca [6 x i32]*
   store [6 x i32]* %a, [6 x i32]** %a.addr
   %y.addr = alloca i32
   store i32 %y, i32* %y.addr
   %x.addr = alloca i32
   store i32 %x, i32* %x.addr
   %temp0 = load i32* %x.addr
   %temp1 = load i32* %y.addr
   %temp2 = add i32 %temp0, %temp1
   %temp3 = load [6 x i32]** %a.addr
   %temp4 = getelementptr inbounds [6 x i32]* %temp3, i32 0
   %temp5 = getelementptr inbounds [6 x i32]* %temp4, i32 0, i32 0
   store i32 %temp2, i32* %temp5
   ret void
}

define double @mult([6 x i32]* %a, i32 %b) {
   %b.addr = alloca i32
   store i32 %b, i32* %b.addr
   %a.addr = alloca [6 x i32]*
   store [6 x i32]* %a, [6 x i32]** %a.addr
   %re = alloca double
   %temp0 = load i32* %b.addr
   %temp2 = sitofp i32 %temp0 to double
   %temp1 = fadd double 0.7, %temp2
   store double %temp1, double* @gd
   %temp3 = load [6 x i32]** %a.addr
   %temp4 = getelementptr inbounds [6 x i32]* %temp3, i32 4
   %temp5 = getelementptr inbounds [6 x i32]* %temp4, i32 0, i32 4
   %temp6 = load i32* %temp5
   %temp7 = load double* @gd
   %temp9 = sitofp i32 %temp6 to double
   %temp8 = fmul double %temp9, %temp7
   store double %temp8, double* %re
   %temp10 = load double* %re
   ret double %temp10
}
