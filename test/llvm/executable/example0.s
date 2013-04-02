define double @bar(double %x) {
   %x.addr = alloca double
   store double %x, double* %x.addr
   %a = alloca i32
   %b = alloca i32
   %p = alloca i32*
   %pa = alloca [8 x [7 x i32*]]
   %re = alloca double
   store i32 90, i32* %a
   store i32* %a, i32** %p
   %temp0 = load i32** %p
   %temp1 = getelementptr inbounds [8 x [7 x i32*]]* %pa, i32 0, i32 3
   %temp2 = getelementptr inbounds [7 x i32*]* %temp1, i32 0, i32 4
   store i32* %temp0, i32** %temp2
   %temp3 = getelementptr inbounds [8 x [7 x i32*]]* %pa, i32 0, i32 4
   %temp4 = getelementptr inbounds [7 x i32*]* %temp3, i32 0, i32 3
   store i32* %b, i32** %temp4
   %temp5 = load i32** %p
   %temp6 = load i32* %temp5
   %temp7 = add i32 %temp6, 21
   %temp8 = mul i32 %temp7, 2
   %temp9 = add i32 %temp8, 45
   %temp10 = getelementptr inbounds [8 x [7 x i32*]]* %pa, i32 0, i32 4
   %temp11 = getelementptr inbounds [7 x i32*]* %temp10, i32 0, i32 3
   %temp12 = load i32** %temp11
   store i32 %temp9, i32* %temp12
   %temp13 = load i32* %a
   %temp14 = sitofp i32 %temp13 to double
   %temp15 = call i32 @buz(double %temp14)
   %temp16 = getelementptr inbounds [8 x [7 x i32*]]* %pa, i32 0, i32 3
   %temp17 = getelementptr inbounds [7 x i32*]* %temp16, i32 0, i32 4
   %temp18 = load i32** %temp17
   %temp19 = load i32* %temp18
   %temp20 = add i32 %temp15, %temp19
   %temp21 = getelementptr inbounds [8 x [7 x i32*]]* %pa, i32 0, i32 4
   %temp22 = getelementptr inbounds [7 x i32*]* %temp21, i32 0, i32 3
   %temp23 = load i32** %temp22
   %temp24 = load i32* %temp23
   %temp25 = add i32 %temp20, %temp24
   %temp26 = load i32** %p
   %temp27 = load i32* %temp26
   %temp28 = add i32 %temp25, %temp27
   %temp29 = sitofp i32 78 to double
   %temp30 = call i32 @buz(double %temp29)
   %temp31 = load double* %x.addr
   %temp33 = sitofp i32 %temp30 to double
   %temp32 = fadd double %temp33, %temp31
   %temp34 = load i32* %a
   %temp35 = sub i32 0, %temp34
   %temp37 = sitofp i32 %temp35 to double
   %temp36 = fmul double %temp32, %temp37
   %temp39 = sitofp i32 %temp28 to double
   %temp38 = fadd double %temp39, %temp36
   %temp40 = sub i32 0, 1
   %temp41 = mul i32 %temp40, 3
   %temp42 = load i32* %a
   %temp43 = mul i32 %temp41, %temp42
   %temp45 = sitofp i32 %temp43 to double
   %temp44 = fdiv double %temp45, 87.0
   %temp46 = fadd double %temp38, %temp44
   store double %temp46, double* %re
   %temp47 = load double* %re
   ret double %temp47
}

define i32 @buz(double %x) {
   %x.addr = alloca double
   store double %x, double* %x.addr
   %y = alloca double
   %temp0 = load double* %x.addr
   %temp1 = load double* %y
   %temp2 = fadd double %temp0, %temp1
   %temp4 = sitofp i32 100 to double
   %temp3 = fadd double %temp2, %temp4
   store double %temp3, double* %y
   ret i32 20
}
