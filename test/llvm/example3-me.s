@x = common global i32 0
@y = common global i32 0
@xa = common global [4 x [5 x i32]] zeroinitializer
@ga = common global [2 x [4 x [4 x i32*]]] zeroinitializer
@d = common global double 0.000000e+00

define i32 @foo(i32 %i, [3 x i32*]* %da, [6 x [7 x i32]]* %da2) {
   %da2.addr = alloca [6 x [7 x i32]]*
   store [6 x [7 x i32]]* %da2, [6 x [7 x i32]]** %da2.addr
   %da.addr = alloca [3 x i32*]*
   store [3 x i32*]* %da, [3 x i32*]** %da.addr
   %i.addr = alloca i32
   store i32 %i, i32* %i.addr
   %a = alloca i32
   %b = alloca i32
   %c = alloca [5 x i32]
   %pr = alloca i32*
   %ar = alloca [2 x [2 x [3 x i32]]]
   %d = alloca double
   store i32 0, i32* %a
   %temp0 = load i32* @x
   store i32 %temp0, i32* %a
   %temp1 = load i32* %i.addr
   store i32 %temp1, i32* %a
   %temp2 = load i32* %b
   store i32 %temp2, i32* %a
   %temp3 = getelementptr inbounds [4 x [5 x i32]]* @xa, i32 0, i32 1, i32 2
   %temp4 = load i32* %temp3
   store i32 %temp4, i32* %a
   %temp5 = load [6 x [7 x i32]]** %da2.addr
   %temp6 = getelementptr inbounds [6 x [7 x i32]]* %temp5, i32 2
   %temp7 = getelementptr inbounds [6 x [7 x i32]]* %temp6, i32 0, i32 3
   %temp8 = getelementptr inbounds [7 x i32]* %temp7, i32 0, i32 4
   %temp9 = load i32* %temp8
   store i32 %temp9, i32* %a
   %temp10 = getelementptr inbounds [2 x [4 x [4 x i32*]]]* @ga, i32 0, i32 1, i32 2, i32 2
   %temp11 = load i32** %temp10
   %temp12 = load i32* %temp11
   store i32 %temp12, i32* %a
   %temp13 = getelementptr inbounds [5 x i32]* %c, i32 0, i32 2
   %temp14 = load i32* %temp13
   store i32 %temp14, i32* %a
   %temp15 = load [3 x i32*]** %da.addr
   %temp16 = getelementptr inbounds [3 x i32*]* %temp15, i32 1
   %temp17 = getelementptr inbounds [3 x i32*]* %temp16, i32 0, i32 2
   %temp18 = load i32** %temp17
   %temp19 = load i32* %temp18
   %temp20 = sitofp i32 %temp19 to double
   store double %temp20, double* %d
   %temp21 = getelementptr inbounds [2 x [2 x [3 x i32]]]* %ar, i32 0, i32 1
   %temp22 = getelementptr inbounds [2 x [3 x i32]]* %temp21, i32 0, i32 1
   %temp23 = getelementptr inbounds [3 x i32]* %temp22, i32 0, i32 2
   %temp24 = load i32* %temp23
   store i32 %temp24, i32* %a
   %temp25 = load i32** %pr
   %temp26 = load i32* %temp25
   store i32 %temp26, i32* %a
   %temp27 = load i32** %pr
   %temp28 = load i32* %temp27
   %temp29 = add i32 %temp28, 1
   store i32 %temp29, i32* %b
   %temp30 = load i32* @x
   %temp31 = load i32** %pr
   store i32 %temp30, i32* %temp31
   %temp32 = load i32* %a
   %temp33 = load i32* %b
   %temp34 = add i32 %temp32, %temp33
   %temp35 = add i32 %temp34, 3
   %temp36 = load i32* %a
   %temp37 = sdiv i32 %temp36, 4
   %temp38 = add i32 %temp35, %temp37
   %temp39 = load i32* %b
   %temp40 = mul i32 8, %temp39
   %temp41 = sub i32 %temp38, %temp40
   store i32 %temp41, i32* @x
   %temp42 = load i32* %a
   %temp43 = add i32 %temp42, 8
   %temp44 = add i32 %temp43, 1
   %temp45 = sitofp i32 %temp44 to double
   store double %temp45, double* %d
   %temp46 = load i32* %a
   ret i32 %temp46
}
